# CryptoBook Async Defaults

이 문서는 `ASYNC_CONCURRENCY_GUIDE.md`의 공통 원칙을 CryptoBook 앱에 적용할 때의 기본값을 정의한다.

## 1. HTTP 기본값
- Request timeout: `10s`
- Resource timeout: `30s`
- Connect timeout: `5s`
- Retry 대상: `idempotent 요청(GET)`만
- Retry 횟수: `max 2` (최대 시도 3회)
- Backoff: `300ms -> 600ms` (multiplier `2.0`)
- Jitter: `±20%`

## 2. WebSocket 기본값
- Initial connect timeout: `8s`
- Session reconnect retry: `max 6` (앱 active 상태 기준)
- Reconnect backoff: `1s -> 2s -> 4s -> 8s -> 16s -> 30s(cap)`
- Subscription retry: `max 3`
- Subscription retry delay: `500ms -> 1s -> 2s`

## 3. UI/Feature 기본값
- 사용자 직접 재시도 버튼 노출 기준: `3회 자동 재시도 실패 후`
- 재연결 상태 표기 시작: `1회 실패 직후`
- 데이터 clear 기본 정책: `일시적 disconnect 시 clear 금지 (stale 유지)`

## 4. 예외 규칙
- 결제/주문/비멱등 요청은 자동 재시도 금지
- 백그라운드 정책은 WS/HTTP 상세 문서에서 override 가능
- 기본값 변경 시 ADR 기록 필수
