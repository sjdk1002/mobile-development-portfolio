# 공개용 코드 예제

카찹·H2CARE에서 직접 다뤘던 문제를 설명하기 위해 **2026년 10월에 새로 구현한 독립 예제**입니다.
과거 제품에서 사용한 원본 코드나 당시의 테스트 결과를 옮긴 자료는 아닙니다.
샘플 데이터와 간단한 인터페이스로 같은 문제를 재현하고, 처리 방식을 확인할 수 있게 만들었습니다.

| 실제 작업 사례 | 공개 예제에서 볼 코드 |
| --- | --- |
| 화면을 닫는 경로에서 마커·delegate 정리 | [CleanupScope](swift/Sources/CaseStudyCore/CleanupScope.swift), [UIKit 연결](swift/Sources/UIKitExamples/MapChatViewController.swift) |
| 초기 채팅 조회와 실시간 수신의 중복 처리 | [ChatTimeline](swift/Sources/CaseStudyCore/ChatTimeline.swift) |
| 앱 시작 중 알림의 채널 ID를 보관한 뒤 화면 이동 | [PendingChatRouter](swift/Sources/CaseStudyCore/PendingChatRouter.swift) |
| 파일 데이터와 iOS 공유 시트 연결 | [SharePayload](swift/Sources/CaseStudyCore/SharePayload.swift), [SystemFileShare](swift/Sources/UIKitExamples/SystemFileShare.swift) |
| 캐시·진행 중 요청 공유와 강제 갱신 | [RequestPool](react/src/RequestPool.ts), [React 훅](react/src/useSharedResource.ts) |

## 먼저 읽을 부분

1. [Swift 예제 안내](swift/README.md) — 화면 종료, 메시지 중복, 알림 진입, 파일 공유
2. [React 예제 안내](react/README.md) — 구독자별 해제와 취소된 요청의 늦은 응답 처리
3. 각 폴더의 테스트 — 재현한 상황과 기대 결과

초기 조회 중 수신 메시지 버퍼링, 이전 조회 토큰 확인, 늦게 끝난 요청의 캐시 덮어쓰기 방지 등은 이번 예제에서 보완했습니다.
당시 제품 변경 내용은 [사례 문서](../README.md#대표-작업)에 따로 정리돼 있습니다.

코드 재구현과 테스트 작성에는 Codex를 사용했습니다. 면접에서는 각 처리의 이유와 흐름을 직접 설명할 수 있도록 살펴볼 자료입니다.
