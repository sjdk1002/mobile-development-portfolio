import assert from "node:assert/strict";
import test from "node:test";
import { RequestCancelledError, RequestPool, scopeKey } from "../src/RequestPool.js";

const scope = { brand: "demo", role: "operator", user: "sample-user" };
function deferred<T>() {
  let resolve!: (value: T) => void;
  let reject!: (reason: unknown) => void;
  const promise = new Promise<T>((yes, no) => { resolve = yes; reject = no; });
  return { promise, resolve, reject };
}

test("two subscribers share one request; one release does not abort it", async () => {
  const pool = new RequestPool<number>();
  const pending = deferred<number>();
  let calls = 0;
  let signal!: AbortSignal;
  const loader = (input: AbortSignal) => { calls += 1; signal = input; return pending.promise; };
  const first = pool.acquire(scope, loader);
  const second = pool.acquire(scope, loader);
  await Promise.resolve();
  assert.equal(calls, 1);
  first.release();
  first.release();
  assert.equal(signal.aborted, false);
  pending.resolve(42);
  assert.equal(await second.promise, 42);
  second.release();
});

test("the last subscriber releases and aborts a pending request", async () => {
  const pool = new RequestPool<number>();
  let signal!: AbortSignal;
  const lease = pool.acquire(scope, async (input) => {
    signal = input;
    return new Promise<number>((_, reject) => input.addEventListener("abort", () => reject(input.reason), { once: true }));
  });
  await Promise.resolve();
  const rejected = assert.rejects(lease.promise, (error: unknown) =>
    error instanceof RequestCancelledError && error.reason === "unused");
  lease.release();
  assert.equal(signal.aborted, true);
  await rejected;
});

test("TTL expires and explicit invalidation starts a new request", async () => {
  let now = 0;
  let calls = 0;
  const pool = new RequestPool<number>(100, () => now);
  const loader = async () => ++calls;
  assert.equal(await pool.acquire(scope, loader).promise, 1);
  now = 99;
  assert.equal(await pool.acquire(scope, loader).promise, 1);
  now = 100;
  assert.equal(await pool.acquire(scope, loader).promise, 2);
  pool.invalidate(scope);
  assert.equal(await pool.acquire(scope, loader).promise, 3);
});

test("brand, role and user have isolated keys including separator characters", async () => {
  assert.notEqual(scopeKey({ brand: "a|b", role: "c", user: "d" }), scopeKey({ brand: "a", role: "b|c", user: "d" }));
  const pool = new RequestPool<string>();
  assert.equal(await pool.acquire(scope, async () => "first").promise, "first");
  for (const other of [{ ...scope, brand: "other" }, { ...scope, role: "viewer" }, { ...scope, user: "other-user" }]) {
    assert.equal(await pool.acquire(other, async () => "isolated").promise, "isolated");
  }
});

test("late response from a replaced request cannot overwrite the new cache", async () => {
  const pool = new RequestPool<string>();
  const old = deferred<string>();
  const current = deferred<string>();
  const first = pool.acquire(scope, () => old.promise);
  await Promise.resolve();
  const rejected = assert.rejects(first.promise, (error: unknown) =>
    error instanceof RequestCancelledError && error.reason === "replaced");
  const second = pool.acquire(scope, () => current.promise, { force: true });
  current.resolve("new");
  assert.equal(await second.promise, "new");
  old.resolve("old");
  await rejected;
  assert.equal(await pool.acquire(scope, async () => "unexpected").promise, "new");
});

test("an old failure cannot remove the replacement flight", async () => {
  const pool = new RequestPool<string>();
  const old = deferred<string>();
  const current = deferred<string>();
  const first = pool.acquire(scope, () => old.promise);
  await Promise.resolve();
  const rejected = assert.rejects(first.promise);
  const second = pool.acquire(scope, () => current.promise, { force: true });
  await Promise.resolve();
  old.reject(new Error("old request failed"));
  await rejected;
  const third = pool.acquire(scope, async () => "wrong request");
  assert.equal(third.promise, second.promise);
  current.resolve("current");
  assert.equal(await third.promise, "current");
});

test("a genuine failure can be retried without caching the error", async () => {
  const pool = new RequestPool<string>();
  await assert.rejects(pool.acquire(scope, async () => { throw new Error("network failed"); }).promise, /network failed/);
  assert.equal(await pool.acquire(scope, async () => "recovered").promise, "recovered");
});
