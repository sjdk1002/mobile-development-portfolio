# iOS 화면을 닫을 때 SDK 참조 정리하기

카찹 iOS · Swift, UIKit, 지도 SDK, 채팅 SDK

관련 문제를 새로 구현한 공개 예제: [CleanupScope](../examples/swift/Sources/CaseStudyCore/CleanupScope.swift), [UIKit 화면 연결](../examples/swift/Sources/UIKitExamples/MapChatViewController.swift). [제품 변경과 예제의 범위](../examples/README.md)를 함께 볼 수 있습니다.

## 상황

카풀·지도 화면은 마커와 이벤트 핸들러, 채팅 delegate를 함께 사용했습니다.
기존 카풀 화면에서는 객체가 해제되는 `deinit`에서 마커와 delegate를 정리하고 있었습니다.

객체 해제 때 정리하는 방식만으로 두기보다, 화면을 닫는 경로에서 참조를 먼저 정리하도록 바꿨습니다.

## 바꾼 내용

- 카풀 화면의 마커 제거와 채팅 delegate 해제를 별도 정리 함수로 옮겼습니다.
- 화면을 닫을 때 정리 함수를 먼저 호출한 뒤 `dismiss`하도록 연결했습니다.
- 지도 검색 화면은 `viewWillDisappear`에서 마커의 지도 연결과 터치 핸들러를 해제했습니다.

![처리 흐름](../assets/ios-lifecycle.svg)

## 이 작업에서 다룬 점

화면을 닫는 동작과 외부 SDK가 보관한 참조를 함께 살펴봤습니다.
객체가 해제되는 시점에만 맡겨두던 정리를 화면 종료 경로로 옮긴 작업입니다.

지도 검색 화면은 사라지는 시점에도 정리가 필요해서 화면 생명주기 메서드에서 연결을 해제했습니다.
두 화면에 같은 정리 시점을 일괄 적용하지 않고 실제 종료 경로에 맞춰 처리했습니다.

## 추가로 확인할 부분

- 화면에 반복해서 진입하고 나갔을 때 객체가 해제되는지
- 지도 마커와 SDK delegate가 남아 있는지
- 다른 화면에 갔다가 돌아올 때 필요한 연결이 복구되는지

[전체 포트폴리오로 돌아가기](../README.md)
