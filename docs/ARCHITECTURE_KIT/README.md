# ARCHITECTURE_KIT

새 앱/새 프로젝트에서 바로 가져다 쓰는 아키텍처 템플릿 번들입니다.

## 폴더 구성
- `APP_ONBOARDING_TEMPLATE.md`: 새 앱 스타트업 체크리스트
- `architecture/`: 코어, UI 패턴, Capability, ADR 문서
- `process/`: Agent 팀 운영 프로세스 문서

## 사용법
1. `APP_ONBOARDING_TEMPLATE.md`를 새 프로젝트 문서에 복사
2. `architecture/README.md`를 읽고 코어/패턴/기능을 선택
3. `process/README.md`와 각 팀의 `00_INDEX.md`로 팀별 작업 흐름 실행
4. 앱별 값은 `architecture/capabilities/detail/`에 새 파일로 분기

## 주의
- 본 킷은 `crypto-book-iOS` 문서를 기준으로 구성되어 있습니다.
- 새 앱의 경로 규칙에 맞춰 링크는 필요 시 상대 경로로 치환하세요.
