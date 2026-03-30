# Capabilities

기능별 운영 문서를 둡니다.
예: `ASYNC_CONCURRENCY_GUIDE.md`, `HTTP_GUIDE.md`, `REALTIME_WS_GUIDE.md`, `I18N_GUIDE.md`

프로젝트 전용 기본값은 `detail/` 하위에 둡니다.
예: `detail/CRYPTOBOOK_ASYNC_DEFAULTS.md`

## 권장 읽기 순서
1. `ASYNC_CONCURRENCY_GUIDE.md` (공통 비동기 원칙)
2. `HTTP_GUIDE.md` (요청/응답/에러 경계)
3. `REALTIME_WS_GUIDE.md` (세션/구독/재연결)
4. 필요 시 `I18N_GUIDE.md` 등 추가 Capability

## 처음 사용자 설정 순서
1. 공통 정책 문서를 먼저 확정합니다. 예: `ASYNC_CONCURRENCY_GUIDE.md`
2. `detail/APP_ASYNC_DEFAULTS_TEMPLATE.md`를 복제해 앱 전용 문서를 만듭니다.
3. 아래 필수 설정값을 스펙에 맞춰 채웁니다.
4. 프로젝트 문서로 고정한 뒤, 변경 시 ADR에 남깁니다.

## 필수 설정값
1. HTTP timeout (`request/resource/connect`)
2. HTTP retry 대상/횟수/backoff/jitter
3. WS connect timeout/reconnect 횟수/backoff
4. subscription retry 정책
5. UI 재시도 노출 기준, reconnecting 표시 기준
6. clear/stale 정책
7. 자동 재시도 금지 대상(비멱등 요청 등)

## detail/ 권장 파일
- `APP_ASYNC_DEFAULTS_TEMPLATE.md`: 새 프로젝트 시작용 템플릿
- `CRYPTOBOOK_ASYNC_DEFAULTS.md`: 현재 프로젝트 적용값
