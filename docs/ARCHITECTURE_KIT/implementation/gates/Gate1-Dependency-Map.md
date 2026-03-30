# Gate 1 - Dependency Map (현재 의존성 맵)

## 핵심 유즈케이스 경로

### 1. 화면 의존성
- `Presentation/Features/Home`
  - `RoutineHomeViewModel` / `TaskListViewModel`
  - 의존: `RoutineDataUseCaseProtocol`, `RecommendTaskUseCaseProtocol`, `AppDependencies`
- `Presentation/Features/AddRoutine`
  - `AddRoutineViewModel`
  - 의존: `RoutineDataUseCaseProtocol`, `RecommendTaskUseCaseProtocol`, `AppDependencies`
- `Presentation/Features/Recommend`
  - `RecommendViewModel`
  - 의존: `RoutineDataUseCaseProtocol`

### 2. App 조립 경로
- `Rouzzle_iOSApp` -> `AppCompositionRoot.makeAppDependencies`
- `AppCompositionRoot`
  - `RoutineDataUseCase(swiftDataService: SwiftDataServiceImpl)`
  - `RecommendTaskUseCase(recommendTaskService: RecommendTaskService)`
- `AppDependencies`에 주입 후 각 View에 전달

### 3. Domain 경로
- `RoutineDataUseCase` -> `SwiftDataServiceProtocol`
- `RecommendTaskUseCase` -> `RecommendTaskServiceProtocol`
- `Factory/Container`는 `App` 조립 지점에서만 사용되며 `Feature/VM`은 생성자 주입만 사용

### 4. Data 경로
- `SwiftDataServiceImpl` (`SwiftDataServiceProtocol` 구현)
- `RecommendTaskService` (`RecommendTaskServiceProtocol` 구현)
- `NotificationManager` (`UNUserNotificationCenter` 위임 및 알림 스케줄 처리)
- `QuotesProvider` (`QuotesProviderProtocol` DI 주입 후 사용)

## 위험한 접근 지점 (Gate2 사전 체크 후보)
- [완료] `Presentation`에서 `NotificationManager.shared` 직접 호출 제거
  - `AddRoutineViewModel`, `RoutineHomeViewModel`, `TaskListView`, `Rouzzle_iOSApp`
- [완료] `QuotesProvider.shared` 직접 참조 제거
  - `QuotesProviderProtocol`을 통해 `RoutineHomeViewModel`로 주입

## Firebase 제거 영향 후보
- 문자열 검색 기준으로는 현재 Swift 소스에서 Firebase API 직접 호출 없음
- 정적 파일/애셋의 로그인 자산은 제거 대상으로 처리 완료
  - 삭제 대상 후보로 등록
