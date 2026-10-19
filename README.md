# 모바일 앱 개발 포트폴리오

**강한호 · Swift/UIKit · React/TypeScript · Capacitor**

카찹을 공동창업하고 초기 앱 개발부터 출시 이후의 기능 개선과 유지보수까지 맡았습니다.
모바일 앱을 중심으로 웹, 네이티브 기능, API와 운영 중 문제를 연결해 해결해왔습니다.

이 저장소에는 직접 맡았던 작업 중 설명할 수 있는 사례를 정리했습니다.
처리 흐름과 변경 내용을 글과 도식으로 담았습니다.

## 공개용 코드

실제 작업에서 다룬 문제를 **공개용 독립 예제로 다시 구현**했습니다. 2026년 10월에 작성한 코드이며 과거 제품의 원본과 구분합니다.

| 예제 | 바로 볼 코드 | 실행·설명 |
| --- | --- | --- |
| Swift / UIKit | [화면 자원 정리](examples/swift/Sources/CaseStudyCore/CleanupScope.swift), [UIKit 연결](examples/swift/Sources/UIKitExamples/MapChatViewController.swift) | [Swift 안내](examples/swift/README.md) |
| 채팅·알림 진입 | [메시지 목록](examples/swift/Sources/CaseStudyCore/ChatTimeline.swift), [알림 라우팅](examples/swift/Sources/CaseStudyCore/PendingChatRouter.swift) | [단위 테스트](examples/swift/Tests/CaseStudyCoreTests) |
| iOS 파일 공유 | [입력 확인](examples/swift/Sources/CaseStudyCore/SharePayload.swift), [공유 시트](examples/swift/Sources/UIKitExamples/SystemFileShare.swift) | [재구현 범위](examples/README.md) |
| React / TypeScript | [요청 공유·캐시](examples/react/src/RequestPool.ts), [React 훅](examples/react/src/useSharedResource.ts) | [React 안내](examples/react/README.md) |

[![Verify examples](https://github.com/sjdk1002/mobile-development-portfolio/actions/workflows/verify-examples.yml/badge.svg)](https://github.com/sjdk1002/mobile-development-portfolio/actions/workflows/verify-examples.yml)

## 맡았던 범위

| 프로젝트 | 담당한 일 | 사용 기술 |
| --- | --- | --- |
| 카찹 iOS | 지도·검색, 계정·인증, 카풀·채팅, 결제 기능 개발과 유지보수 | Swift, UIKit |
| H2CARE Biz | React 웹과 iOS·Android 앱 전반, 기기 기능 연동과 빌드 구성 | React, TypeScript, Capacitor, Swift, Java |
| H2CARE 관리자 웹·BizPro | 운영 화면과 API 연동, 캐시와 데이터 조회 상태 관리 | React, TypeScript, React Query |
| H2CARE 사용자 앱 | 앱 전반 개발·유지보수, 검색·예약·선결제·푸시·딥링크·영상 연동 | Flutter, Dart, Riverpod |
| 연결 서비스 | 차량 데이터와 동의·앱 복귀 흐름, CCTV 재생과 현장 프로그램 운영 보완 | Spring Boot, Node.js, MediaMTX |

초기 카찹 Android 앱에서는 Java·Retrofit·XML 파싱으로 이동수단과 충전소 데이터를 연결했습니다.
이후 iOS와 React 기반 제품으로 개발 범위가 이어졌습니다.

## 대표 작업

| 사례 | 다룬 문제 | 바꾼 내용 |
| --- | --- | --- |
| [iOS 화면 생명주기](cases/ios-lifecycle.md) | 화면과 지도·채팅 SDK의 참조 정리 | 객체 해제에만 맡기던 정리를 화면 종료 경로에서 먼저 실행 |
| [채팅과 알림 진입](cases/chat-and-notification.md) | 초기 조회와 실시간 수신 중복, 앱 시작 중 화면 이동 | 메시지 ID 비교, 채널 ID 보관과 홈 라우팅 연결 |
| [Capacitor 파일 공유](cases/capacitor-file-sharing.md) | 웹의 파일 데이터를 기기 공유 기능으로 전달 | Swift 공유 시트와 Android FileProvider 구현 |
| [React 요청 상태](cases/react-request-state.md) | 여러 화면의 같은 데이터 조회와 갱신 | 캐시 키 분리, 진행 중 Promise 공유, 요청 취소와 상태 관리 |

## 개발하고 확인하는 방식

- 기능별 브랜치와 PR로 변경을 나누고 동료 리뷰와 QA 내용을 반영했습니다.
- 앱 화면, SDK 콜백, API 응답이 이어지는 순서를 함께 확인했습니다.
- 운영 중 응답 지연은 AWS 지표, 서버 로그와 스레드를 함께 보며 원인을 조사했습니다.
- 실제 변경 내용과 이후에 보완할 검증 항목을 나눠 적었습니다.

각 문서의 도식은 당시 변경 내용을 설명하기 위해 다시 작성했습니다.

[GitHub 프로필](https://github.com/sjdk1002)
