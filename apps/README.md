# 개발한 앱의 화면과 사용 흐름

직접 개발·유지보수했던 앱이 어떤 모습이고, 화면 뒤에서 어떤 처리가 이어지는지 정리했습니다.
각 앱의 화면, 사용 순서, 맡은 범위와 관련 코드 사례를 함께 볼 수 있습니다.

아래 이미지는 **2026년 10월 20일 확인한 공식 App Store 공개 스크린샷·홍보 이미지**입니다.
스토어의 예시 화면으로 제품 UI를 소개하며, 직접 실행해 캡처한 화면이나 특정 코드 버전의 동작 검증 자료와는 구분합니다.
개발 설명은 직접 맡은 작업과 소스에서 확인한 흐름을 기준으로 작성했습니다.

| 카찹 iOS | H2CARE Biz | H2CARE 사용자 앱 |
| --- | --- | --- |
| <a href="carchap-ios.md"><img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/c9/0f/28/c90f2842-291e-96d6-0977-ffcb84a852e8/53fecfdc-cfa3-4064-9f07-a3d3ce08ee8a_iOS_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba__U110f_U1173_U11ab_U1109_U1161_U110b_U1175_U110c_U11732.jpg/600x1300bb-60.jpg" width="230" alt="카찹 iOS 공개 UI"></a> | <a href="h2care-biz.md"><img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/c3/91/ad/c391ad43-1c7b-6ded-ce31-d191b37a0fc0/_U1107_U1175_U110c_U1173__U110b_U1162_U11b8_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba_03.png/600x1300bb-60.jpg" width="230" alt="H2CARE Biz 공개 UI"></a> | <a href="h2care.md"><img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/d4/43/6d/d4436deb-32e8-da30-61a0-2d589dad8046/_U1112_U1161_U110b_U1175_U110f_U1166_U110b_U1165__U110b_U1162_U11b8_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba_03.png/600x1300bb-60.jpg" width="230" alt="H2CARE 사용자 앱 공개 UI"></a> |
| Swift · UIKit | React · TypeScript · Capacitor | Flutter · Dart · Riverpod |
| [카풀·택시팟 검색, 채팅과 이동수단 지도](carchap-ios.md) | [충전소 운영정보, 예약 스케줄과 공지 관리](h2care-biz.md) | [충전소 검색, 상태 확인과 충전 예약](h2care.md) |

## 화면 출처

| 앱 | 공식 공개 페이지 |
| --- | --- |
| 카찹 iOS | [App Store](https://apps.apple.com/kr/app/id1506198003) |
| H2CARE Biz | [App Store](https://apps.apple.com/kr/app/id6744343740) |
| H2CARE 사용자 앱 | [App Store](https://apps.apple.com/kr/app/id6744085130) |

이미지는 App Store의 공개 이미지 주소를 연결해 표시합니다. 서비스명·로고·화면 이미지의 권리는 각 권리자에게 있습니다.
공개 이미지 주소가 변경되면 해당 앱의 공식 페이지에서 다시 확인할 수 있습니다.
[이미지별 출처](screenshots.json)에 원문 주소와 확인일을 남겼습니다.

[전체 포트폴리오](../README.md) · [공개용 독립 코드 예제](../examples/README.md)
