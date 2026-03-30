# Realtime WebSocket Guide

## 1. 목적
이 문서는 WebSocket 기반 실시간 데이터 처리 정책을 정의한다.
핵심은 세션 안정성, 구독 일관성, UI 반영 예측 가능성이다.

## 2. 적용 범위
- WS 세션 연결/해제/재연결
- 토픽 구독/해제
- 실시간 이벤트 파싱
- 테이블 캐시/스트림 제공

## 3. 책임 분리
- Session Manager: 연결 상태, reconnect/backoff
- Subscription Manager: 토픽 구독/해제, 구독 재시도
- WS DataSource: raw payload 수신 + DTO 파싱
- Repository: DTO -> Entity 변환 + 앱 제공 스트림/테이블 관리

## 4. 스트림 모델
- WS 원본은 장기 스트림이다.
- 앱에 제공되는 데이터는 Hot stream을 기본으로 한다.
- 화면 구독자는 테이블 변경 스트림을 구독해 UI를 갱신한다.

## 5. WS 테이블 규칙
- 테이블은 "최신 상태 캐시" 역할을 한다.
- 테이블은 토픽/도메인 기준으로 분리한다.
  - 예: all ticker, symbol ticker, candlestick
- clear 정책은 일시적 disconnect와 기능 종료를 구분한다.

## 6. 연결 수명주기
- 앱 active: 연결 유지/복구
- 앱 background: 정책에 따라 중단 또는 제한 유지
- 포그라운드 복귀: 세션 복구 + 필요한 구독 재개

주의:
- 화면 비가시화 시 불필요 구독은 정리한다.
- 장기 스트림은 반드시 취소 경로를 가진다.

## 7. 재시도 정책
- 세션 reconnect와 subscription retry를 분리한다.
- 둘 다 상한(max retry)과 backoff를 명시한다.
- timeout + retry 상한 초과 시 상태를 명확히 전이한다.

## 8. 끊김/복구 시 UI 정책
- 일시적 disconnect: stale 데이터 유지 + reconnecting 표시
- 장기 실패: 명시적 오류 상태 + 사용자 재시도 액션 노출
- clear는 로그아웃/심볼 전환/기능 종료 등 명시적 시점에서 수행한다.

## 9. 파싱/매핑 규칙
- DataSource에서 JSON -> DTO 파싱
- Repository에서 DTO -> Entity 변환
- 파싱 실패를 무조건 삼키지 말고 관측 가능한 에러로 수집한다.

## 10. Ping/Pong 및 서버 규약
- 거래소/서버별 ping/pong 요구사항을 문서로 고정한다.
- 서버가 요구하는 keepalive 주기를 준수한다.
- 규약 미준수 시 disconnect 처리와 복구 경로를 명시한다.

## 11. 테스트 체크리스트
- connect/disconnect/reconnect 경로가 검증되는가?
- retry 상한 및 backoff가 검증되는가?
- 구독 해제 시 리소스가 정리되는가?
- 파싱 실패/부분 실패가 상태에 반영되는가?
- background/foreground 전환 시 정책대로 동작하는가?

## 12. 앱별 설정값
- 공통 원칙 외 숫자값/예외는 `capabilities/detail/*`에서 관리한다.
- 예: `detail/CRYPTOBOOK_ASYNC_DEFAULTS.md`
