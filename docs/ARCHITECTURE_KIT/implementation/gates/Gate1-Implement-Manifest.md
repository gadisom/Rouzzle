# Gate 1 - Implement (Manifest / 프로젝트 구조)

## 1) Tuist Manifest 반영 상태

### 현재 상태 (2026-03-30)
- `Project.swift`
  - `Rouzzle_iOS` 단일 앱 타깃
  - `packages` 없음
  - `dependencies` 빈 배열
- `Tuist/Dependencies.swift`
  - 현재 미사용(현재 프로젝트는 추가 SwiftPM 패키지 의존성 없음)
- 앱 진입점
- `Rouzzle_iOS/Sources/App/Rouzzle_iOSApp.swift`

### 변경 의도
- Firebase 및 불필요 외부 의존성 제거를 위해 Tuist에서 의존성 스코프를 축소
- `Factory`/`Container`는 `AppCompositionRoot`에서만 허용하고, Feature/VM은 수동 생성자 주입만 사용

### 유지할 수 있는 공통 구조(멀티 모듈 전환 전)
- 루트 타깃 1개 유지
  - `Rouzzle_iOS`
  - `Sources` 루트 하위 레이어만 정규화
- 추후 멀티 모듈 전환 시 우선 순위
  - `App`, `Domain`, `Data`, `Presentation`, `Shared`를 각 모듈로 분리해도 의존성 방향은 동일 (`App -> Presentation/Domain/Data/Entity`)
  - DI 바인딩은 그대로 `App`만 담당

## 2) 추천 폴더 구조 (현재 + 확장 대비)

### 현재(동작 기준)
- `Sources/App`
- `Sources/Domain`
- `Sources/Data`
- `Sources/Presentation`
- `Sources/Shared`

### 권장 유지 구조(멀티 모듈이 아닌 현재 상태에서 그대로 사용)
- `Sources/App`
  - `Rouzzle_iOSApp.swift`
  - `AppDependencies.swift`
  - `AppCompositionRoot.swift`
- `Sources/Domain`
  - `UseCase`
  - `Repository`
  - `Entity`
- `Sources/Data`
  - `Repositories`(향후 실제 Repository 인터페이스 구현 추가 시)
  - `Services`
  - `DataSources`
- `Sources/Presentation`
  - `Components`
  - `Features`
  - `Shared`
  - `Modifiers`
- `Sources/Shared`
  - 공통 유틸/확장/기능 보조 모듈

## 3) Tuist generate 정합 체크 항목
- `Project.swift` 변경 후 `tuist generate --no-open` 성공
- 빌드 실패 원인인 과거 `Factory` 패키지 참조 제거 확인
- 추후 Firebase 패키지/SDK 추가 시 `Tuist/Dependencies.swift` 재도입 여부를 이 문서에서 선제 결정
