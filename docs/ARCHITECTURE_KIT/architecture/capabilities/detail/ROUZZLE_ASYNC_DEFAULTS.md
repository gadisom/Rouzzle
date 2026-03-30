# Rouzzle Async Defaults

이 문서는 `ASYNC_CONCURRENCY_GUIDE.md`의 공통 규칙을 Rouzzle_iOS 앱에 고정한 값입니다.

## 앱 정보
- App name: Rouzzle_iOS
- Last updated: 2026-03-30

## 2. HTTP 기본값
- Request timeout: `10s`
- Resource timeout: `30s`
- Connect timeout: `5s`
- Retry 대상: `idempotent 요청(GET)`만
- Retry max: `2` (최대 시도 3회)
- Backoff: `300ms -> 600ms` (`multiplier: 2.0`)
- Jitter: `±20%`

## 3. WebSocket 기본값
- Initial connect timeout: `8s`
- Session reconnect retry max: `6`
- Reconnect backoff: `1s -> 2s -> 4s -> 8s -> 16s -> 30s(cap)`
- Subscription retry max: `3`
- Subscription retry delay: `500ms -> 1s -> 2s`

## 4. UI/Feature 기본값
- 사용자 직접 재시도 버튼 노출 기준: `3회 자동 재시도 실패 후`
- Reconnecting 상태 표시 기준: `1회 실패 직후`
- 일시적 disconnect 시 clear 정책: `clear 금지 (stale 유지)`

## 5. 예외 규칙
- 자동 재시도 금지 대상: 결제/주문/비멱등 요청
- 백그라운드 override 정책: WebSocket/HTTP 정책은 화면/기능 단위 필요 시 변경
