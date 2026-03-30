# UI Pattern: MVVM (Rouzzle_iOS)

## 규칙
- View는 화면 상태/액션만 선언하고 비즈니스 로직은 ViewModel로 위임
- ViewModel은 UseCase를 주입받아 도메인 작업을 수행
- 상태 변경은 `@Published`/`@StateObject` 기반 단방향 바인딩
- 상태 공유가 필요한 경우 App/Feature 단위 ViewModel로 범위를 제한

## 금지
- View에서 Data/Repository 직접 호출
- View에서 상태 계산과 저장소 I/O를 동시에 수행
