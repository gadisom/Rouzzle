# Gate 3 - Test / 정착 점검

## DoD
- `tuist generate --no-open` 기준 생성/동기화가 유지된다.
- 앱 기동 흐름(진입점 → AppDependencies 조립 → 기본 홈 탭/핵심 화면)에서 즉시 크래시 없이 진입 가능한 상태를 목표로 확인한다.
- Gate2에서 파악된 `BLOCKER/WARNING` 항목의 처리 범위를 다음 스프린트로 전환했을 때, 누락 없이 트래킹한다.

## 필수 산출물
- [ ] 빌드 정합 체크 (최소 1회):
  - `tuist generate --no-open` 재실행 기록
  - `xcodebuild` 빌드 또는 `xcodebuild -list` 정합 기록
- [ ] 기본 화면 동작 체크리스트
  - 홈 화면 진입
  - 루틴 추가/저장
  - 추천 뷰 표시
  - 타이머/알림 경로 진입
- [ ] 삭제 기능 비노출 검증
  - 로그인/회원가입/소셜/루즐 챌린지 화면/탭 노출 불가 확인
  - `Resources/Assets.xcassets/Login` 하위 삭제 대상 후보 점검
- [ ] 게이트별 이슈 이력 업데이트
  - Gate2에서 정리한 ISSUE 목록 상태 반영

## 선택 산출물
- 수동 QA 영상/스크린샷 기록
- 빌드 로그 요약본

## 미결사항
- Gate2에서 정리된 정합성 항목 중 일부(로그인/회원가입/루즐 챌린지 삭제 자산)는 차기 스프린트로 연계
- `Login` 자산 실제 삭제 범위 및 UI 영향 범위 미결정

## 다음 단계 진입 조건 (Merge/Hand-off)
- Gate2 핵심 항목(의존성 위반 항목)의 처리 설계 승인
- 기본 화면 동작 체크 1회 통과(또는 재현 이슈 포함 보고)
- 삭제 기능 비노출 검증 항목(로그인/회원가입/챌린지 경로) 완료

## 근거
- [CLEAN_ARCHITECTURE_DIRECTION.md](/Users/kim-jeongwon/Desktop/Rouzzle_iOS/Rouzzle_iOS/docs/ARCHITECTURE_KIT/architecture/core/CLEAN_ARCHITECTURE_DIRECTION.md): 9~10
- [APP_ONBOARDING_TEMPLATE.md](/Users/kim-jeongwon/Desktop/Rouzzle_iOS/Rouzzle_iOS/docs/ARCHITECTURE_KIT/APP_ONBOARDING_TEMPLATE.md): 1~4 Gate 산출물 체계
