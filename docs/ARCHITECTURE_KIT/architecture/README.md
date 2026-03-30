# Architecture Docs

아키텍처 결정의 공통 뼈대를 관리하는 허브입니다.

## 빠른 진입 (입문 순서)
1. `core/CLEAN_ARCHITECTURE_DIRECTION.md`로 레이어 경계와 의존성 원칙을 확정한다.
2. `ui-patterns/`에서 사용할 패턴 가이드를 1개 선택한다. (`TCA_GUIDE.md` 또는 `MVVM_GUIDE.md`)
3. `capabilities/`에서 앱에 필요한 정책만 채택한다.
4. 앱/팀 별 실행값은 `capabilities/detail/`에 고정한다.
5. 아키텍처 방향 변경 시 `adr/`에 결정 사유를 남긴다.

## 문서 지도
- `core/`
  - 클린아키텍처 원칙 전용
  - 의존성 방향, 레이어 책임, 데이터/도메인 경계
- `ui-patterns/`
  - TCA/MVVM 등 UI 상태관리 패턴 운영 규칙
- `capabilities/`
  - 기능 정책 집합(HTTP, WS, i18n 등)
  - 앱 특성값은 `capabilities/detail/`에서 분기 관리
- `adr/`
  - 핵심 결정 기록 템플릿 및 누적 기록
- `templates/`
  - 문서 생성 시 재사용할 기본 골격

## 팀 운영 문서
- 프로세스 전체 허브: `docs/process/README.md`
- 팀별 역할/권한: `docs/process/teams/README.md`
- 팀별 진입 문서: 각 팀 폴더의 `00_INDEX.md`

## 운영 규칙
- 코어 문서는 앱/프로젝트 성격과 무관한 재사용 원칙을 기준으로 유지한다.
- 앱 특성값(타임아웃, 재시도 횟수)은 앱 문서로 분리한다.
- 모든 변경은 `ADR` 링크 가능한 근거와 함께 반영한다.
