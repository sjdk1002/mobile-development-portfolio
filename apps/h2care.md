# H2CARE 사용자 앱

**Flutter · Dart · Riverpod** · 충전소 검색, 상태 확인과 충전 예약

## 공개 앱 화면

| 주변 충전소 검색 | 충전소 상세·상태 확인 | 날짜·시간을 골라 예약 |
| --- | --- | --- |
| <a href="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/d4/43/6d/d4436deb-32e8-da30-61a0-2d589dad8046/_U1112_U1161_U110b_U1175_U110f_U1166_U110b_U1165__U110b_U1162_U11b8_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba_03.png/600x1300bb-60.jpg"><img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/d4/43/6d/d4436deb-32e8-da30-61a0-2d589dad8046/_U1112_U1161_U110b_U1175_U110f_U1166_U110b_U1165__U110b_U1162_U11b8_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba_03.png/600x1300bb-60.jpg" width="230" alt="H2CARE 사용자 앱 주변 충전소 검색 · App Store 공개 화면"></a> | <a href="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/89/9f/12/899f123b-fcd9-8918-925e-ff4c0ad62cb0/_U1112_U1161_U110b_U1175_U110f_U1166_U110b_U1165__U110b_U1162_U11b8_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba_04.png/600x1300bb-60.jpg"><img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/89/9f/12/899f123b-fcd9-8918-925e-ff4c0ad62cb0/_U1112_U1161_U110b_U1175_U110f_U1166_U110b_U1165__U110b_U1162_U11b8_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba_04.png/600x1300bb-60.jpg" width="230" alt="H2CARE 사용자 앱 충전소 상세·상태 확인 · App Store 공개 화면"></a> | <a href="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/ca/69/2b/ca692bad-3ff5-64b5-052f-efdbf9f348c3/_U1112_U1161_U110b_U1175_U110f_U1166_U110b_U1165__U110b_U1162_U11b8_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba_06.png/600x1300bb-60.jpg"><img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/ca/69/2b/ca692bad-3ff5-64b5-052f-efdbf9f348c3/_U1112_U1161_U110b_U1175_U110f_U1166_U110b_U1165__U110b_U1162_U11b8_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba_06.png/600x1300bb-60.jpg" width="230" alt="H2CARE 사용자 앱 날짜·시간을 골라 예약 · App Store 공개 화면"></a> |

출처: [공식 App Store](https://apps.apple.com/kr/app/id6744085130) · 2026-10-20 확인 · 스토어 공개 스크린샷·홍보 이미지

## 맡은 범위

Flutter 기반 H2CARE 사용자 앱 전반을 개발·유지보수했습니다.
충전소 검색·예약·선결제, 차량·카드 정보, 푸시·딥링크와 영상 연동을 다뤘습니다.

## 사용 흐름

1. 지도나 검색으로 주변 충전소를 찾습니다.
2. 충전소 상세에서 운영상태, 공지, 시설 정보와 이용자 제보를 확인합니다.
3. 예약을 지원하는 충전소에서 가능한 날짜와 시간을 선택합니다.
4. 예약 내용을 확인하고, 충전소가 제공하는 방식에 따라 예약·결제 흐름으로 이어집니다.

## 구동 방식

**Flutter 화면 → Riverpod 상태·ViewModel → Repository·Dio/Retrofit API → 응답·선택 상태 반영**

| 처리 구간 | 다룬 내용 |
| --- | --- |
| 지도·검색 | 검색 조건과 지도 마커를 통해 충전소를 찾고, 선택한 충전소의 상세 화면으로 연결했습니다. |
| 예약 | 날짜·시간대와 선택한 예약 정보를 상태로 관리하고 다음 단계로 전달했습니다. |
| 외부 서비스 연동 | 차량 정보·동의·앱 복귀 흐름과 충전소 CCTV 재생을 연결했습니다. |
| 푸시·공유 링크 | 외부 진입으로 전달된 정보에 맞춰 앱의 해당 화면으로 이동하도록 다뤘습니다. |

사용자 화면과 충전소 운영정보가 이어지는 앱이라서 화면 구성과 API 응답, 알림·외부 앱에서 돌아오는 경로를 함께 살펴봤습니다.
지도·목록·예약처럼 여러 단계에서 쓰는 선택 정보는 화면 이동 후에도 맞게 이어지도록 관리했습니다.

## 함께 볼 작업

충전소 관리자의 업무 흐름은 [H2CARE Biz](h2care-biz.md)에 정리했습니다.
이 저장소의 [Swift·React 코드](../examples/README.md)는 별도로 만든 공개 예제이며, H2CARE 제품 소스는 포함하지 않습니다.

[다른 앱 화면](README.md) · [전체 포트폴리오](../README.md)
