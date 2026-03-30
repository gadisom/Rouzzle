# Gate 1 - Migration Order (적용 순서)

## 1) 현재 1차 마이그레이션 대상

### 1단계: 인프라 정합(완료)
1. Firebase/Factory 참조를 제거한 `Project.swift` 단일 의존성 상태 정리
2. `Tuist/Dependencies.swift` 제거
3. App 조립점 정리
   - `AppCompositionRoot.makeAppDependencies(modelContainer:)`
   - `Rouzzle_iOSApp`에서 직접 호출

### 2단계: Feature 경계 안정화(진행 예정)
1. Presentation -> AppDependencies 주입 방식 고정
2. ViewModel별 생성자 주입 시그니처 정합 점검
3. Preview에서 사용되는 `AppDependencies.makePreview()` 경로 일관화
   - 완료: `SampleData.shared.modelContainer` 재사용으로 프리뷰 컨테이너 생성 정규화

### 3단계: Firebase 잔재 삭제(문서화 선행 후 진행)
1. 로그인/소셜/루즐 챌린지 명칭 리소스 및 화면 참조 식별
2. 사용되지 않는 UI 애셋 삭제(`Resources/Assets.xcassets/Login` 하위)
3. 인증/회원가입 로직이 포함된 문서/주석/설정 정리

### 4단계: 아키텍처 정합 강화(권장)
1. `NotificationManager.shared`, `QuotesProvider.shared` DI 추상화 적용 완료
2. Data 계층과 Domain 계층 경계에 맞춘 의존성 검사
3. Gate2에서 `SwiftData 매핑 의존성` 블로커 축소 방안 확정

## 2) 권장 마이그레이션 순서(항목)
1. [완료] `App` 레이어 DI 고정
2. [완료] Tuist 의존성 정리 및 생성
3. [완료] 기능 단위 화면별 DI 주입 정렬
4. [예정] Firebase/로그인 유산 자산 삭제
5. [진행] 공통 모듈(공유 서비스/매니저) 추상화

## 3) Gate2 진입 조건
- 1~4단계 각각의 산출물/체크리스트 제출
- 삭제 대상 목록과 실제 삭제 범위 확정
- `Project.swift`와 `AppCompositionRoot` 조립 진입점이 문서와 일치

## 4) 미결
- SwiftData 직접 모델 의존(BLOCKER) 완화 전략은 Gate2에서 도메인 DTO+매핑 전략 승인 후 진행
