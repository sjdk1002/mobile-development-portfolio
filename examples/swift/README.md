# Swift / UIKit 예제

[공개용 재구현 안내](../README.md)

Swift Package로 구성했습니다. 외부 SDK나 서버 계정 없이 핵심 로직을 테스트할 수 있습니다.

## 코드 읽는 순서

1. `CleanupScope` — 닫는 경로가 여러 개여도 정리를 한 번만 실행합니다.
2. `MapChatViewController` — 화면 닫기 전 정리, 일시적인 화면 가림과 취소된 뒤로 가기 구분, 약한 참조를 보여줍니다.
3. `ChatTimeline` — 초기 조회와 실시간 이벤트를 ID로 합칩니다. 조회 중 이벤트를 보관하고 이전 조회 결과는 토큰으로 걸러냅니다.
4. `PendingChatRouter` — 앱 초기 진입이 끝날 때까지 마지막 채널 ID를 보관합니다.
5. `SharePayload`와 `SystemFileShare` — 입력 확인, 임시 파일, iPad 공유 위치와 완료·취소 후 파일 정리를 연결합니다.

`MapResources`와 `ChatEvents`는 예제용 경계입니다. 지도나 채팅 SDK의 내부 구현을 제공하지 않습니다.
`ChatTimeline`은 한 채널의 목록이며 여러 실행 문맥에서 직접 동시에 수정하는 용도로 만들지 않았습니다.

## 확인 방법

macOS에서 Swift 5.9 이상으로 핵심 로직을 테스트합니다.

```sh
cd examples/swift
swift test
```

UIKit 부분은 Xcode에서 `Package.swift`를 열고 iOS Simulator 대상으로 빌드하거나 다음 명령을 사용합니다.

```sh
xcodebuild -scheme UIKitExamples -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

핵심 단위 테스트와 UIKit 빌드를 CI에서 나눠 확인합니다. 실제 기기의 공유 시트·iPad 표시와 화면 제스처는 수동 검증 항목입니다.
앱 실행 파일이나 실기기 검증 완료 결과를 제공하는 예제는 아닙니다.

## 면접에서 설명할 부분

- `deinit`에만 정리를 두면 어떤 참조가 남을 수 있는지
- 화면이 잠깐 가려진 경우와 실제로 닫히는 경우를 어떻게 구분하는지
- 조회 중 받은 메시지가 스냅샷에 겹치거나 조회가 실패하면 어떻게 되는지
- 알림을 보관하는 시점과 화면을 열 수 있는 시점을 왜 나누는지
- 파일 공유 취소와 실패, 임시 파일의 수명을 어떻게 처리하는지
