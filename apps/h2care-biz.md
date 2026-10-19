# H2CARE Biz

**React · TypeScript · Capacitor** · 충전소 운영정보, 예약 스케줄과 공지 관리

## 공개 앱 화면

| 운영상태 확인·변경 | 예약 스케줄 관리 | 충전소 공지 관리 |
| --- | --- | --- |
| <a href="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/c3/91/ad/c391ad43-1c7b-6ded-ce31-d191b37a0fc0/_U1107_U1175_U110c_U1173__U110b_U1162_U11b8_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba_03.png/600x1300bb-60.jpg"><img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/c3/91/ad/c391ad43-1c7b-6ded-ce31-d191b37a0fc0/_U1107_U1175_U110c_U1173__U110b_U1162_U11b8_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba_03.png/600x1300bb-60.jpg" width="230" alt="H2CARE Biz 운영상태 확인·변경 · App Store 공개 화면"></a> | <a href="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/bb/29/4d/bb294dcf-2ced-3748-90ef-072a50216eab/_U1107_U1175_U110c_U1173__U110b_U1162_U11b8_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba_05.png/600x1300bb-60.jpg"><img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/bb/29/4d/bb294dcf-2ced-3748-90ef-072a50216eab/_U1107_U1175_U110c_U1173__U110b_U1162_U11b8_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba_05.png/600x1300bb-60.jpg" width="230" alt="H2CARE Biz 예약 스케줄 관리 · App Store 공개 화면"></a> | <a href="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/a2/b8/c7/a2b8c708-d2b3-2e5c-b7d3-74d0ce57d26b/_U1107_U1175_U110c_U1173__U110b_U1162_U11b8_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba_06.png/600x1300bb-60.jpg"><img src="https://is1-ssl.mzstatic.com/image/thumb/PurpleSource221/v4/a2/b8/c7/a2b8c708-d2b3-2e5c-b7d3-74d0ce57d26b/_U1107_U1175_U110c_U1173__U110b_U1162_U11b8_U1109_U1173_U110f_U1173_U1105_U1175_U11ab_U1109_U1163_U11ba_06.png/600x1300bb-60.jpg" width="230" alt="H2CARE Biz 충전소 공지 관리 · App Store 공개 화면"></a> |

출처: [공식 App Store](https://apps.apple.com/kr/app/id6744343740) · 2026-10-20 확인 · 스토어 공개 스크린샷·홍보 이미지

## 맡은 범위

React 웹과 Capacitor 기반 iOS·Android 앱 전반을 개발했습니다.
충전소 운영·예약 화면과 API 연동을 만들고, 권한·푸시·뒤로 가기·파일 공유처럼 웹과 기기 사이에 필요한 동작을 연결했습니다.

## 사용 흐름

1. 관리할 충전소를 선택하고 운영상태와 공지를 확인합니다.
2. 상태를 바꾸거나 예약자·예약 스케줄을 확인합니다.
3. 공지 내용과 노출 여부를 수정해 저장합니다.
4. 변경한 데이터가 관련 화면에도 반영되도록 조회 상태를 갱신합니다.

## 구동 방식

**React 화면 → React Query·API 연동 → 서버 데이터 → 화면 갱신**

웹은 브라우저에서, 모바일 앱은 Capacitor의 WebView에서 React 화면을 사용합니다.
공통 업무 화면은 React·TypeScript로 만들고, 카메라·위치·푸시·파일 공유 같은 기기 기능은 Capacitor와 플랫폼 구현으로 연결했습니다.

| 처리 구간 | 구현한 내용 |
| --- | --- |
| 충전소 데이터 조회 | 충전소 ID별 React Query 키로 홈 데이터를 조회하고, 현재 선택한 충전소의 상태를 표시했습니다. |
| 상태·공지 저장 이후 | 관련 조회를 무효화하거나 캐시를 갱신해 저장한 내용과 화면을 맞췄습니다. |
| 파일 공유 | React에서 파일명·MIME 타입·파일 데이터를 전달하고, iOS는 Swift 공유 시트, Android는 Java FileProvider와 공유 Intent로 연결했습니다. |
| 앱 사용 흐름 | 기기 권한, 푸시 진입과 Android 뒤로 가기 등 웹 화면 밖의 동작도 함께 처리했습니다. |

## 관련 구현 사례와 공개 코드

- [Capacitor 파일 공유](../cases/capacitor-file-sharing.md): 웹에서 만든 파일을 기기의 공유 기능으로 넘기는 순서입니다.
- [React 데이터 조회와 상태 관리](../cases/react-request-state.md): Biz의 React Query 연동과 BizPro·관리자 웹의 요청 관리 사례입니다.
- [공개 Swift·React 예제](../examples/README.md): 실제 작업에서 다룬 문제를 2026년 10월에 독립적으로 다시 구현했습니다.

스토어 이미지는 H2CARE Biz의 공개 서비스 UI를 보여줍니다. 이미지에 사용된 빌드의 기술 스택은 스토어 화면만으로 특정하지 않으며, 위 설명은 제가 맡은 React·Capacitor 구현을 기준으로 합니다.

[다른 앱 화면](README.md) · [전체 포트폴리오](../README.md)
