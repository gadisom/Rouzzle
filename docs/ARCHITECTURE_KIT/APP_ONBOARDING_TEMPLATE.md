# 새 앱 온보딩 & 에이전트 실행 템플릿

이 문서는 새 앱을 시작할 때 한 번에 복사해서 쓰는 템플릿이다.
`{{ARCH_DOCS_ROOT}}`는 문서 루트 경로(예: `docs/architecture`)로 복붙 후 1회 치환한다.

## 0) 기본 정보
- 앱 이름: 
- 앱 타입(예: iOS 1개 앱/멀티 모듈/라이브러리): 
- 책임자: 
- 시작일: 
- 목표 릴리즈일: 

## 1) 아키텍처 뼈대 확정
- [ ] [core/CLEAN_ARCHITECTURE_DIRECTION.md]({{ARCH_DOCS_ROOT}}/core/CLEAN_ARCHITECTURE_DIRECTION.md) 기준 확정
- [ ] 레이어 경계 확정(도메인/데이터/UI)
- [ ] 의존성 방향 최종 합의
- [ ] 위반 금지 규칙 3개 이상 고정
  - 예) Feature는 Repo 직접 호출 금지
  - 예) Entity는 Data 레이어 DTO 직접 반입 금지
  - 예) Domain 에러 정책은 Domain에서 결정
  - 예) App/Composition Root에서만 DI 컨테이너(Factory/Container/ServiceLocator)를 사용하고, 현재 릴리즈 라인에서는 수동 생성자 주입을 기본으로 둔다.

## 2) UI 패턴 선택
- [ ] TCA 사용
  - 이유: 
  - 패턴 문서: [ui-patterns/TCA_GUIDE.md]({{ARCH_DOCS_ROOT}}/ui-patterns/TCA_GUIDE.md)
- [ ] MVVM 사용
  - 이유: 
  - 패턴 문서: [ui-patterns/MVVM_GUIDE.md]({{ARCH_DOCS_ROOT}}/ui-patterns/MVVM_GUIDE.md)
- [ ] 선택 사유(2~3줄): 

## 3) 능력(Capability) 적용
- [ ] HTTP
  - 사용 여부: 
  - 정책 파일: [capabilities/HTTP_GUIDE.md]({{ARCH_DOCS_ROOT}}/capabilities/HTTP_GUIDE.md)
- [ ] WebSocket
  - 사용 여부: 
  - 정책 파일: [capabilities/REALTIME_WS_GUIDE.md]({{ARCH_DOCS_ROOT}}/capabilities/REALTIME_WS_GUIDE.md)
- [ ] Async Concurrency
  - 사용 여부: 
  - 정책 파일: [capabilities/ASYNC_CONCURRENCY_GUIDE.md]({{ARCH_DOCS_ROOT}}/capabilities/ASYNC_CONCURRENCY_GUIDE.md)
- [ ] I18n
  - 사용 여부: 
  - 정책 파일: (필요 시)

## 4) 앱 특성값(오버라이드) 작성
- 다음 폴더에 앱별 값 문서를 생성: [capabilities/detail/]({{ARCH_DOCS_ROOT}}/capabilities/detail/)
- 파일명 예시: `APP_<APP_NAME>_ASYNC_DEFAULTS.md`
- 필수 고정값
  - [ ] timeout
  - [ ] retry 횟수
  - [ ] backoff 정책
  - [ ] 실패/에러 표시 UX 기준

## 5) ADR 기본 생성
- [ ] 첫 ADR 생성
- [ ] 변경될 때마다 ADR 번호 발급
- [ ] ADR는 결정의 이유 + 대안 + 트레이드오프 포함

## 6) Agent 팀 실행 계획
- [ ] 과제 단위로 issue/작업 생성 (1~3개)
- [ ] 과제당 Design→Implement→Review→Test 순회
- [ ] 각 단계 DoD 충족 여부 기록
- [ ] Gate 0~3 통과 기록

### tuist 선행 조건 (새 프로젝트 공통)
- 새 프로젝트에서 `agent-team`을 즉시 쓰려면 tuist가 필요하다.
- 설치 방식:
  - `brew install tuist`
  - 또는 `curl -Ls https://github.com/tuist/tuist/releases/latest/download/install.sh | bash`
- 스크립트 연동 환경변수:
  - `TUIST_AUTO_INSTALL=true` (부트스트랩 시 tuist 자동 설치 허용)

## Gate 0 (Design 준비)
- [ ] 설계 범위
- [ ] 경계/의존성
- [ ] 리스크 및 미결사항
- [ ] 구현 분해

## Gate 1 (Implement 준비)
- [ ] 테스트 우선 작성 계획
- [ ] 실패 경로 케이스 식별
- [ ] 코드 변경과 테스트 동시 계획

## Gate 2 (Review 준비)
- [ ] BLOCKER 0건 목표
- [ ] WARNING 추적 항목 등록

## Gate 3 (Merge 준비)
- [ ] 단위 테스트 통과
- [ ] 빌드 통과
- [ ] 핵심 E2E 또는 API 흐름 검증

## 과제 실행 체크리스트
각 과제는 아래 네 개를 필수로 남긴다.

- task-id: 
- 범위: 
- 위험도: 
- 관련 문서: 

### Design 결과
- 핵심 결정:
- 트레이드오프:
- 미결사항:

### Implement 결과
- 변경 파일:
- 테스트:
- 실패 사례 및 결과:

### Review 결과
- BLOCKER:
- WARNING:
- INFO:

### Test 결과
- pass/fail:
- 실패 재현:
- 원인/수정 포인트:

## 완료 기준
- [ ] core 문서와 앱 특성값 일관성 유지
- [ ] DoD 충족 기록
- [ ] 다음 앱 단계로 무리 없이 이관 가능
