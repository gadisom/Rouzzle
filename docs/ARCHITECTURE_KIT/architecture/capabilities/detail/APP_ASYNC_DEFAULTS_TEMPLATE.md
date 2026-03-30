# App Async Defaults Template

이 문서는 `ASYNC_CONCURRENCY_GUIDE.md` 공통 규칙을 앱 스펙 값으로 고정하기 위한 템플릿이다.

## 1. 앱 정보
- App name:
- Version:
- Owner:
- Last updated:

## 2. HTTP 기본값
- Request timeout:
- Resource timeout:
- Connect timeout:
- Retry 대상:
- Retry max:
- Backoff:
- Jitter:

## 3. WebSocket 기본값
- Initial connect timeout:
- Session reconnect retry max:
- Reconnect backoff:
- Subscription retry max:
- Subscription retry delay:

## 4. UI/Feature 기본값
- 수동 재시도 버튼 노출 기준:
- Reconnecting 상태 표시 기준:
- disconnect 시 clear/stale 정책:

## 5. 예외 규칙
- 자동 재시도 금지 대상:
- 백그라운드 override 정책:

## 6. 검토 체크리스트
- timeout 값이 서비스 SLA와 합의되었는가?
- retry 상한이 무한 재시도를 유발하지 않는가?
- 비멱등 요청 자동 재시도 금지를 반영했는가?
- stale/clear 정책이 UX와 일치하는가?
- 변경 이력이 ADR에 기록되었는가?
