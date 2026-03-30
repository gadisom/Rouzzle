# Clean Architecture Direction (Rouzzle_iOS)

## 의존성 방향
`Presentation -> Domain -> Data`

- `Presentation`: View, ViewModel, Navigation, State 관리
- `Domain`: Entity, UseCase, Repository Protocol
- `Data`: Repository 구현체, DataStore, Service, DTO/Mapper
- `Shared`: 공통 확장, 유틸, 디자인 시스템

## 규칙
1. Feature/VM은 Repository를 직접 호출하지 않고 UseCase를 통해 접근한다.
2. Domain은 Data 계층 구현체를 import하지 않는다.
3. Data는 Domain/Shared 타입만 참조하고 UI 타입을 직접 사용하지 않는다.
4. Container/Locator는 Feature 밖에서만 구성되며 Feature 내부에서 직접 접근 금지.

## 에러/네트워크 정책
- 정책 정의 위치: `Domain/Error` 중심
- Data 전용 에러는 `DataError`로 래핑 후 Domain에 매핑
