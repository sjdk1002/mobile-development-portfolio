# React / TypeScript 요청 관리 예제

[공개용 재구현 안내](../README.md)

`RequestPool`을 여러 화면이 공유하고, 각 화면은 `useSharedResource`로 결과를 받습니다.
계정·브랜드·역할별 데이터가 섞이지 않도록 키를 나누고, 같은 키의 진행 중 요청은 공유합니다.

## 실행

Node.js 24 이상에서 다음 명령으로 타입 검사와 테스트를 실행합니다.

```sh
cd examples/react
npm ci
npm test
```

## 코드에서 볼 부분

- `RequestPool.acquire` — 캐시, 진행 중 요청 공유, 강제 교체
- `RequestLease.release` — 한 화면이 닫혀도 다른 화면이 기다리는 요청은 유지
- 요청 식별자와 취소 신호 — 취소를 무시하고 늦게 완료된 결과의 캐시 쓰기 차단
- 훅의 실행 세대 — 이전 화면의 결과가 새 화면 상태를 덮지 않도록 처리
- 강제 갱신 시 다른 화면 — 취소된 요청에 머무르지 않고 교체된 요청에 합류

```ts
// pool은 컴포넌트 밖에서 데이터 종류별로 만듭니다.
const stations = new RequestPool<Station[]>();

// loader는 useCallback으로 유지하고 API 호출에 signal을 넘깁니다.
const state = useSharedResource(stations, { brand, role, user }, loader);
```

같은 pool과 키는 같은 데이터·loader를 의미해야 합니다. 서로 다른 API라면 별도 pool을 사용합니다.
서버 오류가 난 경우 실패를 보여주고, 강제 갱신 버튼 등에서 `reload()`를 호출할 수 있습니다.

## 검증 범위

요청 공유, 마지막 구독자 해제, 캐시 만료, 범위 분리, 늦은 응답과 오류, 재시도를 단위 테스트합니다.
React는 jsdom에서 실제로 마운트해 화면 전환, 구독 해제, 강제 갱신, StrictMode를 확인합니다.
실제 서버·로그인·권한 검증은 연결하지 않은 로컬 예제입니다.
