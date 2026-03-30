# Process Docs

이 디렉토리는 팀 운영 방식과 실행 프로세스를 관리한다.

## 구조
- `teams/`: agent team 운영 플로우, 팀별 역할, 핸드오프 규칙

## 시작 순서
1. `teams/README.md`를 읽고 전체 플로우를 이해한다.
2. 현재 작업이 어느 팀 단계인지 먼저 결정한다.
3. 해당 팀 문서의 입력/출력/완료조건(DoD)을 기준으로 작업한다.
4. `teams/README.md`의 Phase Gate 통과조건을 확인한 뒤 다음 단계로 이동한다.
5. 새 프로젝트에서 `agent-team` 템플릿을 즉시 사용하려면 tuist가 필요하다.

## 원칙
- 모르면 질문하고, 추측으로 진행하지 않는다.
- 주요 결정에는 대안/트레이드오프/선택 이유를 남긴다.
- 설계 없는 구현 금지
- 문서 규칙 위반 상태 merge 금지
- 정책값(timeout/retry 등) 변경 시 `architecture/capabilities/detail`과 `architecture/adr` 동시 업데이트
