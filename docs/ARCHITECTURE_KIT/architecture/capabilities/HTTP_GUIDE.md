# HTTP Guide

## 1. 목적
이 문서는 HTTP 요청/응답 처리의 공통 정책을 정의한다.
핵심은 일관된 에러 경계, 안전한 재시도, 예측 가능한 상태 반영이다.

## 2. 적용 범위
- REST API 호출
- Request/Response 파싱
- HTTP status 기반 에러 처리
- 로깅/타임아웃/재시도 정책

## 3. 표준 데이터 흐름
`Feature/ViewModel -> UseCase -> Repository -> DataSource -> NetworkClient -> API`

규칙:
- Presentation은 HTTP 세부사항(status code, header)을 직접 다루지 않는다.
- Repository 경계에서 인프라 에러를 Domain Error로 매핑한다.

## 4. Request 규칙
- Endpoint는 `method/path/query/header/body`를 명시적으로 선언한다.
- 공통 헤더(언어/지역/인증)는 요청 직전에 결합한다.
- 타임아웃 없는 요청을 금지한다.
- 멱등성(idempotency)이 없는 요청은 자동 재시도 금지한다.

## 5. Response 규칙
- 성공 범위는 기본적으로 `2xx`로 제한한다.
- `204`(No Content) 케이스를 명시적으로 처리한다.
- 파싱 실패는 인프라/매핑 에러로 구분한다.
- DTO -> Entity 변환은 Repository/Data 경계에서 수행한다.

## 6. 에러 분류 규칙
- Transport Error: DNS, 연결 실패, timeout
- HTTP Error: 4xx, 5xx
- Decoding Error: 스키마 불일치, 데이터 형식 오류
- Business Error: Domain 레이어에서 의미를 가진 실패

매핑 원칙:
- DataSource/NetworkClient: 원인 수집
- Repository: Domain Error로 변환
- Presentation: 사용자 메시지/화면 상태 결정

## 7. 상태 코드 처리 기준
- `400`: 입력/요청값 교정 필요 (UI에서 필드 피드백)
- `401`: 인증 재처리(공통 정책)
- `403`: 권한 없음(가이드 메시지)
- `404`: 리소스 없음(공통 에러 화면/메시지)
- `429`: rate limit(대기/재시도 전략)
- `5xx`: 서버 장애(재시도 또는 공통 오류 처리)

## 8. 로깅 규칙
- Debug/QA: 요청/응답 로그 허용
- Release: 민감정보/본문 로그 금지
- 인증 토큰/개인정보는 마스킹한다.
- 에러 로그는 추적 가능 ID를 포함한다.

## 9. 재시도/타임아웃
- 기본 정책은 `ASYNC_CONCURRENCY_GUIDE.md`를 따른다.
- 재시도는 상한을 둔다.
- backoff + jitter를 사용한다.
- 재시도 여부는 요청 멱등성에 따라 결정한다.

## 10. 테스트 체크리스트
- 2xx/4xx/5xx 처리 경로가 분리되어 검증되는가?
- timeout 시나리오가 검증되는가?
- retry 상한(`N+1` 금지)이 검증되는가?
- 파싱 실패가 Domain Error로 올바르게 매핑되는가?
- Release 로깅 제한이 지켜지는가?

## 11. 앱별 설정값
- 공통 원칙 외 숫자값/예외는 `capabilities/detail/*`에서 관리한다.
- 예: `detail/CRYPTOBOOK_ASYNC_DEFAULTS.md`
