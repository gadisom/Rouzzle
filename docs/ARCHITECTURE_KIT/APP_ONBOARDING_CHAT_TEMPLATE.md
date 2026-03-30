# AI 온보딩 시작 프롬프트 (복붙용)

아래 내용을 복사해서 AI에 첫 메시지로 보내줘.

```md
# 새 앱 온보딩 시작

아래 템플릿만 기준으로 설계/구현/리뷰/테스트 플랜을 단계적으로 정리해줘.
- 문서 직접 수정은 요구하지 말고, 결과물(DoD, Gate별 체크리스트, 위험/미결사항)만 먼저 제시.
- 내가 승인하면 다음 Gate로 진행.

## 0) 기본 정보
- 앱 이름:
- 앱 타입: iOS 앱 / 멀티 모듈 / 라이브러리
- 타깃: iOS 버전:
- 팀 규칙 선호: 빠른 의사결정 / 안정성 우선 / 리스크 투명화

## 1) 핵심 범위
- 필수 기능(최대 5개):
  - 
  - 
- 사용할 Capability:
  - HTTP: [예/아니오]
  - WebSocket: [예/아니오]
  - Async/Concurrency: [예/아니오]
  - I18n: [예/아니오]

## 2) 아키텍처 방향
- UI 패턴: TCA 또는 MVVM (한 가지만)
- 의존성 방향: (예: UI -> Domain -> Data, Entity 공유)
- 금지 규칙 2~3개: (예: Feature에서 Repo 직접 호출 금지)
  - 예: Feature/VM/Reducer에서 App/Composition Root가 아닌 곳에서 `Container.shared`/`Factory` 직접 resolve 금지

## 3) 앱별 오버라이드
- timeout, retry 횟수, backoff, 에러 UX 정책을 값으로 제시해줘.
- 기본 값은 예시만 먼저 제안하고 내가 승인하면 고정.

## 4) 산출물 요구
다음 4단계로 정리:
1) Gate 0 (Design)
2) Gate 1 (Implement)
3) Gate 2 (Review)
4) Gate 3 (Test)

각 Gate는 아래 형식으로:
- DoD
- 필수/선택 산출물
- 미결사항
- 다음 단계 진입 조건

## 5) 실행 제약
- 새 프로젝트의 경우 tuist 미설치 가능성 반영
- tuist 미설치 시 설치 가이드는 제시하고, 계속 진행 가능성은 내가 결정

먼저 Gate 0만 제시하고, 내가 "계속" 하면 Gate 1부터 진행해줘.
```
