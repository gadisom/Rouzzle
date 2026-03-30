# TCA Guide

## 1. 목적
이 문서는 본 프로젝트의 TCA 사용 규칙을 정의한다.
핵심은 다음 3가지다.

- Feature는 상태 전이와 비즈니스 흐름을 예측 가능하게 유지한다.
- 외부 의존성은 `Client + DependencyKey + DependencyValues`로 추상화한다.
- 테스트에서 의존성을 쉽게 대체할 수 있도록 설계한다.

## 2. 표준 구현 규칙

### 2.1 Client 정의
- `struct`로 정의한다.
- 기능 단위 함수만 노출한다.
- 함수는 가능한 `@Sendable`로 선언한다.

예시:

```swift
struct NewsClient {
    var fetchNews: @Sendable (_ currency: String) async throws -> [NewsArticle]
}
```

### 2.2 DependencyKey 정의
- `liveValue`는 운영 구현을 연결한다.
- 테스트 대체 전략을 반드시 준비한다.
- DI 컨테이너(`Container.shared`/`Factory`) 참조는 브릿지 파일(`TCAKey.swift` 등, Composition Root 연동 지점)로 한정한다.
- Feature/Reducer/View에서 DI 컨테이너를 직접 참조하지 않는다.
- `liveValue`는 계산형(`static var`)을 기본으로 한다.

예시:

```swift
enum NewsClientKey: DependencyKey {
    static var liveValue: NewsClient {
        let useCase = resolveNewsArticleUseCase()
        return NewsClient { currency in
            try await useCase.execute(currency: currency)
        }
    }
}

extension DependencyValues {
    var newsClient: NewsClient {
        get { self[NewsClientKey.self] }
        set { self[NewsClientKey.self] = newValue }
    }
}
```

### 2.3 Feature 사용 규칙
- Reducer에서만 의존성을 호출한다.
- View는 Action만 보낸다.
- 에러는 `Domain Error` 또는 Feature 전용 에러 상태로 변환해 상태에 반영한다.

예시:

```swift
@Dependency(\.newsClient) var newsClient

case .fetchNews:
    return .run { send in
        do {
            let items = try await newsClient.fetchNews("BTC")
            await send(.newsResponse(.success(items)))
        } catch {
            await send(.newsResponse(.failure(.network(error.localizedDescription))))
        }
    }
```

## 3. 라우팅 규칙 (TCA)
- Child Feature는 화면 전환을 직접 실행하지 않는다.
- Child는 delegate action으로 의도를 부모에 전달한다.
- Parent/Root Feature가 `path/route`를 최종 변경한다.

## 4. Effect / Cancellation 규칙
- 장기 스트림(WS, timer)은 반드시 `CancelID`를 둔다.
- 화면 이탈/비가시화 시 cancel 정책을 명시한다.
- 재구독 정책은 Feature가 아니라 Capability 문서에서 관리한다.
- 비동기 상세 정책은 `capabilities/ASYNC_CONCURRENCY_GUIDE.md`를 따른다.

## 5. 테스트 규칙
- 신규 Feature는 TestStore 테스트를 기본으로 한다.
- 성공/실패/취소(취소 ID 포함) 시나리오를 최소 1개 이상 검증한다.
- 테스트에서는 `DependencyValues` override로 클라이언트를 대체한다.

예시:

```swift
let store = TestStore(initialState: .init()) {
    MyFeature()
} withDependencies: {
    $0.newsClient.fetchNews = { _ in [NewsArticle(title: "t", date: .now)] }
}
```

## 6. 금지 패턴
- Feature에서 Data 구현체를 직접 생성/참조
- View에서 네트워크/스토리지 직접 호출
- 의존성 주입 없이 전역 상태를 직접 읽기/쓰기
- Feature/Reducer/View에서 `Container.shared`/`Factory` 직접 참조
- 취소 불가능한 장기 스트림 Effect

## 7. 체크리스트
- `Client`가 기능별로 분리되어 있는가?
- `DependencyValues`에 접근 키가 일관되게 정의되어 있는가?
- Feature는 `@Dependency`만 사용하고 구체 구현을 모르는가?
- 장기 Effect에 `CancelID`가 있는가?
- 테스트에서 의존성 override가 가능한가?
