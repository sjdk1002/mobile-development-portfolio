// 공개용으로 재구현한 예제. 제품 원본 코드가 아닙니다.
export interface RequestScope {
  readonly brand: string;
  readonly role: string;
  readonly user: string;
}

export const scopeKey = (scope: RequestScope): string =>
  JSON.stringify([scope.brand, scope.role, scope.user]);

export class RequestCancelledError extends Error {
  constructor(readonly reason: "replaced" | "unused") {
    super(`Request cancelled: ${reason}`);
    this.name = "RequestCancelledError";
  }
}

export interface RequestLease<T> {
  readonly promise: Promise<T>;
  release(): void;
}

interface Flight<T> {
  readonly id: symbol;
  readonly controller: AbortController;
  readonly promise: Promise<T>;
  subscribers: number;
}

/** 하나의 데이터 종류에 대해 조회 범위별 캐시와 진행 중 요청을 관리합니다. */
export class RequestPool<T> {
  private readonly cache = new Map<string, { value: T; expiresAt: number }>();
  private readonly flights = new Map<string, Flight<T>>();

  constructor(
    private readonly ttlMs = 5 * 60 * 1_000,
    private readonly now: () => number = Date.now,
  ) {}

  acquire(
    scope: RequestScope,
    loader: (signal: AbortSignal) => Promise<T>,
    options: { force?: boolean } = {},
  ): RequestLease<T> {
    const key = scopeKey(scope);
    const existing = this.flights.get(key);
    if (existing && !options.force) return this.subscribe(key, existing);

    if (!options.force) {
      const cached = this.cache.get(key);
      if (cached && this.now() < cached.expiresAt) {
        return { promise: Promise.resolve(cached.value), release() {} };
      }
    }

    if (existing) existing.controller.abort(new RequestCancelledError("replaced"));
    const id = Symbol(key);
    const controller = new AbortController();
    const promise = Promise.resolve()
      .then(() => {
        controller.signal.throwIfAborted();
        return loader(controller.signal);
      })
      .then((value) => {
        // 취소 신호를 무시하는 loader가 늦게 완료되어도 캐시를 덮지 않습니다.
        controller.signal.throwIfAborted();
        if (this.flights.get(key)?.id === id) {
          this.cache.set(key, { value, expiresAt: this.now() + this.ttlMs });
        }
        return value;
      })
      .catch((error: unknown) => {
        if (controller.signal.aborted) throw controller.signal.reason;
        throw error;
      })
      .finally(() => {
        if (this.flights.get(key)?.id === id) this.flights.delete(key);
      });
    const flight = { id, controller, promise, subscribers: 0 };
    this.flights.set(key, flight);
    return this.subscribe(key, flight);
  }

  invalidate(scope: RequestScope): void {
    this.cache.delete(scopeKey(scope));
  }

  private subscribe(key: string, flight: Flight<T>): RequestLease<T> {
    flight.subscribers += 1;
    let released = false;
    return {
      promise: flight.promise,
      release: () => {
        if (released) return;
        released = true;
        flight.subscribers -= 1;
        if (flight.subscribers === 0 && this.flights.get(key)?.id === flight.id) {
          this.flights.delete(key);
          flight.controller.abort(new RequestCancelledError("unused"));
        }
      },
    };
  }
}
