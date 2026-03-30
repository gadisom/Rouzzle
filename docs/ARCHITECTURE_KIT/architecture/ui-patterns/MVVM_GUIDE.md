# MVVM Guide

## 1. 목적
이 문서는 본 프로젝트의 MVVM 사용 규칙을 정의한다.
핵심은 다음 3가지다.

- View는 렌더링과 사용자 이벤트 전달에 집중한다.
- ViewModel은 상태 변환과 유즈케이스 호출을 담당한다.
- 외부 의존성은 추상화된 인터페이스/클라이언트로 주입한다.

## 2. 표준 구현 규칙

### 2.1 View 정의
- View는 화면 렌더링과 이벤트 전달만 담당한다.
- 비즈니스 로직, 데이터 가공 로직을 View에 두지 않는다.
- View는 ViewModel의 Output(State)을 구독해 렌더링한다.

### 2.2 ViewModel 정의
- ViewModel은 `Input -> Action -> State(Output)` 흐름을 관리한다.
- 네트워크/저장소 구현체를 직접 생성하지 않는다.
- 비동기 작업 결과를 화면 상태로 변환한다.
- 에러는 Domain Error 또는 화면 표시용 ErrorState로 변환한다.

예시 구조:

```swift
protocol HomeViewModelInput {
    func onAppear()
    func didTapRetry()
}

protocol HomeViewModelOutput {
    var state: AnyPublisher<HomeViewState, Never> { get }
}

final class HomeViewModel: HomeViewModelInput, HomeViewModelOutput {
    // useCase/client를 주입받아 상태를 관리
}
```

### 2.3 State 규칙
- 화면 상태는 명시적 타입으로 관리한다.
- 최소한 다음 상태를 고려한다.
  - loading
  - content
  - empty
  - error
- 여러 플래그 난립 대신 화면 의미 중심 상태를 우선한다.

### 2.4 DI 규칙
- ViewModel 생성 시 의존성을 생성자 주입한다.
- 조립(Composition Root)에서만 DI 컨테이너(Factory/Container/ServiceLocator)를 사용한다.
- `Feature/VM`은 생성자 주입만 사용하고, 내부에서 DI 컨테이너를 직접 조회하지 않는다.
- View/ViewModel에서 `Container.shared`를 직접 참조하지 않는다.

## 3. 라우팅 규칙 (MVVM)
- ViewModel은 라우팅 의도(예: Route, NavigationEvent)만 발행한다.
- 실제 화면 전환(push/present/path 반영)은 View/Coordinator/Router 계층에서 수행한다.
- Domain은 화면 전환을 직접 실행하지 않는다.

예시:

```swift
enum HomeRoute {
    case detail(symbol: String)
    case settings
}
```

## 4. Side Effect 규칙
- 외부 I/O(HTTP, WS, DB)는 UseCase/Client를 통해서만 수행한다.
- ViewModel은 작업 취소 정책을 명시한다.
- 장기 스트림은 구독 시작/해제 시점을 명확히 관리한다.
- 비동기 상세 정책은 `capabilities/ASYNC_CONCURRENCY_GUIDE.md`를 따른다.

## 5. 테스트 규칙
- ViewModel 단위 테스트를 기본으로 한다.
- 최소 시나리오:
  - 성공 시 상태 전이
  - 실패 시 상태 전이
  - 재시도/취소 시 상태 전이
  - 라우팅 이벤트 발행
- 테스트에서 의존성은 Fake/Stub로 대체한다.

## 6. 금지 패턴
- View에서 UseCase/Repository 직접 호출
- ViewModel에서 Data 구현체 직접 생성
- ViewModel 내부에서 `Container.shared`/`Factory` 직접 참조해 실제 구현을 resolve
- Domain에서 UIKit/SwiftUI 라우팅 직접 실행
- 상태를 의미 없는 Bool 조합으로만 관리

## 7. 체크리스트
- View가 렌더링/이벤트 전달만 수행하는가?
- ViewModel이 UseCase/Client를 주입받는가?
- ViewModel 상태 타입이 명시적으로 정의되어 있는가?
- 라우팅 실행과 라우팅 의도가 분리되어 있는가?
- ViewModel 테스트에서 의존성 대체가 가능한가?
