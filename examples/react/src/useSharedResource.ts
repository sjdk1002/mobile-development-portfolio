// 공개용으로 재구현한 예제. 제품 원본 코드가 아닙니다.
import { useCallback, useEffect, useRef, useState } from "react";
import { RequestCancelledError, RequestPool, type RequestLease, type RequestScope } from "./RequestPool.js";

export interface ResourceState<T> {
  readonly status: "loading" | "ready" | "error";
  readonly data: T | undefined;
  readonly error: Error | undefined;
}

/** pool은 화면 밖에서, loader는 useCallback 등으로 안정적으로 유지합니다. */
export function useSharedResource<T>(
  pool: RequestPool<T>,
  scope: RequestScope,
  loader: (signal: AbortSignal) => Promise<T>,
): ResourceState<T> & { reload(): void } {
  const { brand, role, user } = scope;
  const [state, setState] = useState<ResourceState<T>>({
    status: "loading", data: undefined, error: undefined,
  });
  const reloadRef = useRef<(() => void) | undefined>(undefined);
  const reload = useCallback(() => reloadRef.current?.(), []);

  useEffect(() => {
    let active = true;
    let generation = 0;
    let lease: RequestLease<T> | undefined;
    setState({ status: "loading", data: undefined, error: undefined });

    const start = (force = false): void => {
      const requestGeneration = ++generation;
      lease?.release();
      const current = pool.acquire({ brand, role, user }, loader, { force });
      lease = current;
      setState((previous) => ({ ...previous, status: "loading", error: undefined }));
      const isCurrent = () => active && generation === requestGeneration;

      void current.promise
        .then((data) => {
          if (isCurrent()) setState({ status: "ready", data, error: undefined });
        })
        .catch((error: unknown) => {
          if (!isCurrent()) return;
          if (error instanceof RequestCancelledError && error.reason === "replaced") {
            // 다른 화면의 강제 갱신으로 취소됐다면 교체된 요청을 함께 기다립니다.
            start();
            return;
          }
          setState((previous) => ({
            ...previous, status: "error",
            error: error instanceof Error ? error : new Error(String(error)),
          }));
        })
        .finally(() => current.release());
    };

    const requestReload = () => start(true);
    reloadRef.current = requestReload;
    start();
    return () => {
      active = false;
      generation += 1;
      if (reloadRef.current === requestReload) reloadRef.current = undefined;
      lease?.release();
    };
  }, [pool, brand, role, user, loader]);

  return { ...state, reload };
}
