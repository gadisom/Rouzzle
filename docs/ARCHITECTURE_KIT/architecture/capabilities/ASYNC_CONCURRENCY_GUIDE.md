# Async Concurrency Guide

## 1. 목적
이 문서는 앱 전반의 비동기 처리 정책을 정의한다.
레이어마다 비동기 책임을 분리하고, 취소/재시도/타임아웃/상태 반영 규칙을 통일한다.

## 2. 적용 범위
- Swift Concurrency (`async/await`, `Task`, `AsyncStream`)
- Combine (`Publisher`, `AnyCancellable`)
- 장기 스트림(예: WS, timer)
- 네트워크/저장소 I/O

## 3. 핵심 원칙
- 비동기는 "실행 위치"와 "상태 반영 위치"를 분리한다.
- 시작한 비동기 작업은 반드시 취소 시점을 가진다.
- 타임아웃 없는 외부 I/O를 금지한다.
- 재시도는 무한 루프 없이 상한을 둔다.
- 실패는 로그로만 삼키지 않고 상태로 반영한다.

## 4. 설계 시작 기본값 (Default Profile)
- 단발 I/O: `async/await`
- 병렬 fan-out: `TaskGroup`
- 장기 이벤트 스트림: `AsyncStream` 또는 `AsyncThrowingStream`
- UI 상태 반영: `@MainActor` 보장
- 공유 가변 상태: 기본은 단일 경로 업데이트, 필요 시 `actor`
- 재시도/타임아웃: `RetryPolicy`, `TimeoutPolicy`를 명시적으로 둔다

이 기본값에서 벗어나는 경우는 아래 트레이드오프 표를 근거로 결정한다.

## 5. 선택 가이드 (트레이드오프)

### 5.1 비동기 primitive 선택

| 상황 | 기본 선택 | 장점 | 단점/주의 |
|---|---|---|---|
| 요청 1회 후 종료 | `async/await` | 단순, 가독성 높음 | 취소/타임아웃을 직접 넣어야 함 |
| 여러 요청 동시 실행 후 합치기 | `TaskGroup` | 병렬 성능, 명시적 합류 | 에러 전파/부분 성공 정책 필요 |
| 지속 수신(WS, timer) | `AsyncStream` | 취소/수명주기 제어 용이 | 종료 처리 누락 시 리소스 누수 위험 |
| UI 반응형 파이프라인 | `Combine` | 변환 연산자 풍부, 바인딩 용이 | 학습비용, 스케줄러 관리 필요 |
| 다중 태스크가 공유 상태 갱신 | `actor` | 데이터 레이스 방지 | 홉 비용, 설계 복잡도 증가 |

### 5.2 actor를 쓸지 판단하는 기준

actor 권장:
- 여러 비동기 작업이 동일 mutable state를 동시에 수정한다.
- 상태 불변식(예: 중복 구독 금지, 카운터 일관성)을 강하게 보장해야 한다.
- lock/queue로 관리하던 코드가 복잡해졌다.

actor 비권장:
- 상태 갱신 경로가 사실상 하나다(예: Reducer 단일 경로).
- 단순 값 전달만 한다.
- 호출 hot path에서 actor hop 비용이 민감하다.

### 5.3 두 가지 API 레벨 제공 원칙
- Simple API: 대부분 호출자가 바로 쓰는 안전 기본값 제공
- Advanced API: timeout/retry/backoff/cancel 정책을 외부에서 주입 가능

예시:

```swift
// Simple
func fetchTicker(symbol: String) async throws -> Ticker

// Advanced
func fetchTicker(
  symbol: String,
  retry: RetryPolicy,
  timeout: TimeoutPolicy
) async throws -> Ticker
```

## 6. 레이어별 책임

### Presentation
- 사용자 이벤트로 작업을 시작한다.
- 결과를 화면 상태(loading/content/empty/error/reconnecting)로 반영한다.
- 화면 이탈 시 취소 정책을 적용한다.

### Domain
- 비즈니스 흐름을 정의한다.
- 재시도/복구 전략이 비즈니스 규칙이면 UseCase에서 결정한다.

### Data
- 외부 I/O를 실행한다.
- 타임아웃/재시도/backoff를 인프라 정책으로 적용한다.
- 인프라 에러를 Domain 의미로 변환한다.

## 7. 작업 수명주기 규칙
- 단발 작업: 요청 시작 -> 결과 반영 -> 종료
- 장기 작업: 구독 시작 -> 이벤트 반영 -> 명시 취소
- 화면 단위 작업: 화면 생명주기와 함께 시작/종료
- 앱 단위 작업: 앱 생명주기 정책(포그라운드/백그라운드)과 동기화

## 8. 취소 규칙
- 장기 스트림은 반드시 취소 ID 또는 취소 토큰을 둔다.
- 동일 작업 중복 실행 시 `cancelInFlight` 또는 동등 정책을 적용한다.
- 취소 시 메모리/소켓/구독 자원을 함께 해제한다.

## 9. 타임아웃/재시도 규칙
- 네트워크 호출은 기본 타임아웃을 둔다.
- 재시도는 최대 횟수 `N`을 둔다.
- 재시도 간격은 exponential backoff를 기본으로 한다.
- `N+1`회 호출 금지 규칙을 테스트로 보장한다.

예시 정책 모델:

```swift
struct RetryPolicy: Sendable {
    let maxRetries: Int
    let initialDelayMs: Int
    let multiplier: Double
}

struct TimeoutPolicy: Sendable {
    let requestMs: Int
}
```

## 10. 상태 반영 규칙
- 요청 시작 시 `loading = true` 또는 동등 상태로 전환한다.
- 성공 시 loading 종료 + content 반영
- 실패 시 loading 종료 + error 반영
- 재연결 중은 `reconnecting` 상태를 명시한다.
- 일시적 끊김에서 기존 데이터 clear 여부는 Capability 정책에 따른다.

## 11. 동시성 안전 규칙
- 공유 가변 상태는 단일 경로로만 갱신한다.
- UI 상태는 MainActor(또는 UI 스레드 보장)에서 반영한다.
- race condition이 가능한 경로에는 시퀀싱 규칙을 둔다.

## 12. 설계 리뷰 질문 (필수)
- 이 작업은 단발인가, 장기 스트림인가?
- 취소 시점은 어디인가? (화면 이탈/탭 전환/앱 백그라운드)
- timeout 값과 retry 상한은 무엇인가?
- shared mutable state가 있는가? 있다면 actor가 필요한가?
- 호출자에게 Simple/Advanced API 두 레벨이 필요한가?

## 13. 테스트 체크리스트
- 성공/실패/취소 시 상태 전이가 검증되는가?
- 타임아웃이 실제로 동작하는가?
- 재시도 횟수 상한이 지켜지는가?
- 중복 실행 시 이전 작업이 정리되는가?
- 장기 스트림 종료 시 자원이 해제되는가?

## 14. 문서 연계
- TCA 사용 시: `ui-patterns/TCA_GUIDE.md`
- MVVM 사용 시: `ui-patterns/MVVM_GUIDE.md`
- WS/HTTP 상세 정책은 개별 Capability 문서에서 확장한다.
- 프로젝트별 숫자 기본값은 `capabilities/detail/*`에서 관리한다.
