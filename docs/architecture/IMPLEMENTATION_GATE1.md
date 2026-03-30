# Gate 1 Implement: Tuist + 레이어 정합

## 목표
- iOS 앱을 단일 타깃(`Rouzzle_iOS`) 기반으로 유지한 채 MVVM + Clean 아키텍처 실행 규칙을 고정한다.
- Firebase 관련 흔적을 빌드/타깃/패키지에서 제거하고, DI 엔트리 포인트를 `Composition Root`에 한정한다.

## 적용 상태 (현재)
- Tuist 프로젝트 엔트리: `/Users/kim-jeongwon/Desktop/Rouzzle_iOS/Project.swift`
- 현재 타깃: `Rouzzle_iOS` 1개(App) 유지
- 현재 소스 분할: `Sources/App`, `Sources/Domain`, `Sources/Data`, `Sources/Presentation`, `Sources/Shared`로 스캔 범위 고정
- 최근 빌드 상태: `BUILD SUCCEEDED`

## Tuist 반영 내역
- `Project.swift`에서 App/Domain/Data/Presentation/Shared 레이어별 glob 분리
  - `Rouzzle_iOS/Sources/App/**/*.swift`
  - `Rouzzle_iOS/Sources/Domain/**/*.swift`
  - `Rouzzle_iOS/Sources/Data/**/*.swift`
  - `Rouzzle_iOS/Sources/Presentation/**/*.swift`
  - `Rouzzle_iOS/Sources/Shared/**/*.swift`
- 패키지 의존성 블록은 현재 비어 있음(현재 기준 Firebase 패키지 없음)

## 삭제/제거 반영 포인트
1. Firebase 관련 import 검색: `rg "Firebase|GoogleSignIn|SignInWithApple|google-services|Auth"`
2. `Project.swift`의 dependencies 블록 및 외부 패키지 블록 정합성 확인
3. `Rouzzle_iOS.xcworkspace`, `Rouzzle_iOS.xcodeproj` 재생성 전 `tuist generate` 권장

## 마이그레이션 순서
1. **폴더 규칙 잠금**: `Sources` 레이어 경계 기준 고정
2. **의존성 규칙 강제**: Feature/VM은 UseCase 경유 사용
3. **Composition Root 정리**: `AppCompositionRoot`에서 서비스/UseCase 생성
4. **Firebase 제거 체크 재확인**: 코드/자원/의존성 3중 점검
5. **빌드 게이트**: `xcodebuild ... build` 성공 확인

## Gate1 완료 체크
- [ ] [Project.swift](/Users/kim-jeongwon/Desktop/Rouzzle_iOS/Project.swift) 변경 반영
- [ ] Firebase 검색 0건
- [ ] 레이어 폴더 규칙 문서 고정
- [ ] `Composition Root` 경로만 DI 초기화 허용
- [ ] Gate 2 진입: 순환 의존성/레이어 침범 스캔 수행
