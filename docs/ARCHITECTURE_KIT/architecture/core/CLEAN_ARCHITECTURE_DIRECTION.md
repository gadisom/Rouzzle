# Clean Architecture Direction Guide

## 1. 목적
이 문서는 프로젝트의 클린아키텍처 방향성과 레이어 경계를 정의한다.
UI 패턴(MVVM, MVI, TCA 등)은 이 문서 범위에 포함하지 않는다.

## 2. 핵심 원칙
- 의존성은 항상 바깥에서 안쪽으로 향한다.
- 안쪽 레이어는 바깥 레이어를 모른다.
- 비즈니스 규칙은 프레임워크/플랫폼에서 독립적이어야 한다.
- 구현체는 교체 가능해야 하며, 핵심 로직은 변하지 않아야 한다.

## 3. 레이어 구성
- App: 조립과 실행 진입점
- Presentation: 화면/입력/표현 상태
- Domain: 유즈케이스, 비즈니스 규칙, 추상화
- Data: 외부 시스템 연동, 저장소 구현
- Entity: 핵심 모델, 불변 규칙

## 4. 의존성 방향
- Presentation -> Domain -> Entity
- Data -> Domain, Entity
- App -> Presentation, Domain, Data, Entity

## 5. 레이어 책임과 금지사항

### App
- 책임: DI 조립, 환경별 구성, 앱 엔트리
- 금지: 비즈니스 규칙 직접 구현

### Presentation
- 책임: 사용자 상호작용 처리, 상태 렌더링
- 금지: Data 구현체 직접 의존, 인프라 직접 호출

### Domain
- 책임: UseCase, Repository 인터페이스, Domain Error
- 금지: UI/플랫폼/네트워크 구현 의존

### Data
- 책임: Repository 구현, DataSource, DTO, 외부 연동
- 금지: 화면 상태/화면 전환 직접 제어

### Entity
- 책임: 순수 모델과 모델 자체 규칙
- 금지: DTO 포함, 플랫폼 의존 코드 포함

## 6. 모델 경계 규칙
- DTO는 Data 레이어에만 둔다.
- Entity는 Domain/Data/Presentation에서 참조 가능한 순수 모델로 유지한다.
- Domain은 DTO를 알지 않고 Entity와 추상화만 사용한다.

## 7. 에러 경계 규칙
- 외부 에러는 Data에서 인지한다.
- Data는 에러를 Domain 의미로 변환한다.
- Presentation은 Domain 에러를 사용자 표시 상태로 변환한다.

## 8. DI 규칙
- 추상화는 Domain에 둔다.
- 구현체는 Data에 둔다.
- 바인딩은 App(Composition Root)에서 수행한다.
- Factory/ServiceLocator 사용은 App 레이어에서만 허용한다.
- Feature/Presentation/Domain은 Factory/Container를 직접 resolve하지 않고 생성자 주입으로 받는다.
- 고수준 모듈은 저수준 구현체가 아닌 추상화에 의존한다.

## 9. 폴더/모듈 권장 구조
- Domain: UseCases, Repositories, Error
- Data: Repositories(Impl), DataSources, DTOs, Services, Error
- Entity: Core Models
- Presentation: 화면 단위 기능 모듈
- App: 조립/런처

## 10. 아키텍처 리뷰 체크리스트
- Domain이 바깥 레이어를 import하지 않는가?
- DTO가 Domain/Entity에 존재하지 않는가?
- Presentation이 Data 구현체를 직접 참조하지 않는가?
- Repository 인터페이스가 Domain에 존재하는가?
- DI 바인딩 코드가 App(Composition Root)에서 수행되는가?
- Entity가 플랫폼 독립성을 유지하는가?
- Feature/VM에서 DI 컨테이너(Firebase/Factory/Container) 조회가 없는가?
