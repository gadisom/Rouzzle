# Gate 2 - Review (의존성/레이어 위반 점검)

## DoD
- 레이어 임포트 기준 1차 리뷰를 완료해 상/하위 의존성 규칙 위반을 정리한다.
- `App -> Presentation`, `Presentation -> Domain`, `Domain -> Data` 단방향 의존 방향 위반 후보를 분리한다.
- Firebase/Factory 직접 호출 또는 Container 조회 코드가 ViewModel/Feature에서 누락되지 않았는지 점검한다.
- 다음 Gate로 넘어가기 위한 BLOCKER/ WARNING 리스트를 정량화한다.

## 필수 산출물
- [x] `Gate2-Review.md` 임시 작성본(아래 Findings 반영본)
- [x] 계층별 위험 항목 매트릭스(도메인, 프레젠테이션, 앱)
- [x] 깨진 의존성 후보 1차 분류 (`BLOCKER`, `WARNING`, `INFO`)

## 선택 산출물
- 경로 단위 리팩터링 PR 체크리스트(Feature별)
- 순환 의존성 후보 정리(현재는 import 기준으로 cycle 미검출 상태)

## Findings (우선순위 순)
1) [RESOLVED] Domain 계층의 플랫폼 의존성 정리
- 위치:
  - `Rouzzle_iOS/Sources/Domain/Entity/RoutineItem.swift`
- 내용:
  - Domain 엔티티에서 `SwiftData` 직접 모델링 어노테이션/타입 종속성이 제거되어
    플랫폼 독립성이 확보됨.
- 증거:
  - 영속 모델은 `Rouzzle_iOS/Sources/Data/Models/StoredRoutineModels.swift`로 이전
  - 영속/도메인 변환은 `Rouzzle_iOS/Sources/Data/Mapping/RoutinePersistenceMapper.swift`가 담당
- 조치:
  - Domain 경계에서 `SwiftData` 직접 의존을 제거하고 UseCase를 통해 데이터 로직 접근

2) [RESOLVED: 1차 반영 완료] Presentation/App의 Infrastructure 싱글턴 직접 호출
- 위치:
  - `Rouzzle_iOS/Sources/App/AppCompositionRoot.swift:6`, `Rouzzle_iOS/Sources/App/AppDependencies.swift:29`
  - `Rouzzle_iOS/Sources/Presentation/Features/AddRoutine/ViewModel/AddRoutineViewModel.swift:57`
  - `Rouzzle_iOS/Sources/Presentation/Features/Home/View/TaskListView.swift:88`
  - `Rouzzle_iOS/Sources/Presentation/Features/Home/ViewModel/RoutineHomeViewModel.swift:13`
- 내용:
  - `NotificationManager.shared` 직접 호출을 제거하고, `NotificationServiceProtocol`을 AppDependencies로 주입.
- 영향:
  - DI 경계 위반 리스크 해소. (주입 지점은 AppCompositionRoot/Dependencies로 고정)
- 조치:
  - 완료: `NotificationServiceProtocol` 추가, `AddRoutineViewModel`/`TaskListViewModel`/`RoutineHomeViewModel`에서 직접 참조 제거.

3) [RESOLVED: 1차 반영 완료] Presentation에서 Data 서비스 싱글턴 직접 사용
- 위치:
  - `Rouzzle_iOS/Sources/Presentation/Features/Home/ViewModel/RoutineHomeViewModel.swift:13`
- 내용:
  - `QuotesProvider.shared.provideQuote()`를 `QuotesProviderProtocol`로 추상화 후 AppDependencies 주입으로 전환.
- 영향:
  - UseCase/DI 경계 정렬 완화.
- 조치:
  - 완료: `QuotesProviderProtocol` 추가, `RoutineHomeViewModel` 생성자 주입으로 변경.

4) [INFO] Tuist 의존성 정합
- 위치:
  - `Project.swift`, `Rouzzle_iOS.xcodeproj` generated
- 내용:
  - `tuist generate --no-open`은 성공했으나, 기존 SwiftPM 의존성은 모두 제거된 상태.
- 영향:
  - Firebase/Factory 패키지 잔존 리스크는 낮음.

5) [INFO] 순환 의존성 후보
- 현재 import-기반 정적 스캔 기준으로 `Domain` → `Data`의 역방향 import는 없고, `App`이 최상단 조립점으로만 동작하는 구조가 보임.
- 실제 타깃 빌드에서 경로 기반 순환 분석이 추가로 필요함.

## 미결사항
- 로그인/소셜 잔재 기능은 소스/자산 기준 삭제 대상으로 정리 완료
- `Factory/Container` 용어가 일부 문서 템플릿에 잔존하며, 실제 구현 규약(Composition Root 전용 사용)은 Gate2에서 계속 모니터링
- 알림/루틴 상태 변경 직후 즉시 홈 데이터 반영을 위한 옵저버트리거 정책 정밀화(현재 `AppDataStore.refresh()` 트리거 일부 적용)

## 다음 단계 진입 조건 (Gate3)
- Gate2의 BLOCKER 1건을 해결하거나 타협/예외 승인
- BLOCKER 항목 완료 또는 예외 승인
- Firebase 유산 삭제와 DI 경계 개선 항목을 작업 티켓으로 분해

## 근거
- [CLEAN_ARCHITECTURE_DIRECTION.md](/Users/kim-jeongwon/Desktop/Rouzzle_iOS/Rouzzle_iOS/docs/ARCHITECTURE_KIT/architecture/core/CLEAN_ARCHITECTURE_DIRECTION.md): 3~10
- [MVVM_GUIDE.md](/Users/kim-jeongwon/Desktop/Rouzzle_iOS/Rouzzle_iOS/docs/ARCHITECTURE_KIT/architecture/ui-patterns/MVVM_GUIDE.md): 2.4, 6
