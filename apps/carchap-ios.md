# 카찹 iOS

**Swift · UIKit** · 카풀·택시팟 검색, 채팅과 이동수단 지도

## 공개 앱 화면

| 출도착지·날짜로 검색 | 채팅으로 일정 조율 | 주변 이동수단 지도 |
| --- | --- | --- |
| <a href="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/c9/0f/28/c90f2842-291e-96d6-0977-ffcb84a852e8/53fecfdc-cfa3-4064-9f07-a3d3ce08ee8a_iOS_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba__U110f_U1173_U11ab_U1109_U1161_U110b_U1175_U110c_U11732.jpg/600x1300bb-60.jpg"><img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/c9/0f/28/c90f2842-291e-96d6-0977-ffcb84a852e8/53fecfdc-cfa3-4064-9f07-a3d3ce08ee8a_iOS_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba__U110f_U1173_U11ab_U1109_U1161_U110b_U1175_U110c_U11732.jpg/600x1300bb-60.jpg" width="230" alt="카찹 iOS 출도착지·날짜로 검색 · App Store 공개 화면"></a> | <a href="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/9b/05/be/9b05be35-1d9c-2c82-00eb-39c4471dd812/904020e1-e1d3-473e-b57e-3820ef0ff8b8_iOS_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba__U110f_U1173_U11ab_U1109_U1161_U110b_U1175_U110c_U11736.jpg/600x1300bb-60.jpg"><img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/9b/05/be/9b05be35-1d9c-2c82-00eb-39c4471dd812/904020e1-e1d3-473e-b57e-3820ef0ff8b8_iOS_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba__U110f_U1173_U11ab_U1109_U1161_U110b_U1175_U110c_U11736.jpg/600x1300bb-60.jpg" width="230" alt="카찹 iOS 채팅으로 일정 조율 · App Store 공개 화면"></a> | <a href="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/ff/b8/bf/ffb8bf00-f06e-a980-da5c-123f45a3064b/afbb4791-1ef6-487c-9e3e-fed5a7e094a2_iOS_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba__U110f_U1173_U11ab_U1109_U1161_U110b_U1175_U110c_U11737.jpg/600x1300bb-60.jpg"><img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/ff/b8/bf/ffb8bf00-f06e-a980-da5c-123f45a3064b/afbb4791-1ef6-487c-9e3e-fed5a7e094a2_iOS_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba__U110f_U1173_U11ab_U1109_U1161_U110b_U1175_U110c_U11737.jpg/600x1300bb-60.jpg" width="230" alt="카찹 iOS 주변 이동수단 지도 · App Store 공개 화면"></a> |

출처: [공식 App Store](https://apps.apple.com/kr/app/id1506198003) · 2026-10-20 확인 · 스토어 공개 스크린샷·홍보 이미지

## 맡은 범위

카찹을 공동창업하고, Swift와 UIKit으로 iOS 앱의 지도·검색, 계정·인증, 카풀·채팅, 결제 기능을 개발하고 유지보수했습니다.
초기 개발 이후에도 기능 추가, 오류 수정과 출시 준비를 이어갔습니다.

## 사용 흐름

1. 출발지·도착지·날짜를 입력해 카풀이나 택시팟을 검색합니다.
2. 목록과 상세 화면에서 이동 경로, 시간과 조건을 확인합니다.
3. 채팅으로 일정을 조율하고, 필요한 경우 알림을 통해 대화로 다시 들어옵니다.
4. 지도에서는 주변 공유 킥보드·자전거 등 이동수단을 탐색합니다.

## 화면 뒤에서 처리한 일

| 화면·상황 | 처리한 내용 | 자세한 사례 |
| --- | --- | --- |
| 지도·카풀 화면 종료 | 화면이 닫히는 경로에 맞춰 마커, 이벤트 핸들러와 SDK delegate 참조를 정리했습니다. | [iOS 화면 생명주기](../cases/ios-lifecycle.md) |
| 채팅 첫 조회와 실시간 수신 | 초기 조회 상태와 메시지 ID를 확인해 같은 메시지를 목록에 중복 추가하지 않도록 수정했습니다. | [채팅 중복 수신](../cases/chat-and-notification.md#초기-조회와-실시간-수신이-겹치는-경우) |
| 앱 시작 중 채팅 알림 선택 | 이동할 채널 ID를 보관하고 홈의 서비스 라우팅에서 채팅 화면으로 연결했습니다. | [알림 진입](../cases/chat-and-notification.md#앱이-시작되는-동안-채팅-알림을-누르는-경우) |

검색·지도·채팅처럼 외부 데이터와 SDK 이벤트를 함께 사용하는 화면에서는 요청 결과뿐 아니라 화면이 사라지는 시점과 다시 들어오는 경로도 함께 다뤘습니다.

## 관련 공개 코드

당시 다뤘던 문제를 2026년 10월에 독립 예제로 다시 구현했습니다.
[자원 정리와 UIKit 연결](../examples/swift/README.md), [메시지 병합](../examples/swift/Sources/CaseStudyCore/ChatTimeline.swift), [알림 라우팅](../examples/swift/Sources/CaseStudyCore/PendingChatRouter.swift)을 볼 수 있습니다.

[다른 앱 화면](README.md) · [전체 포트폴리오](../README.md)
