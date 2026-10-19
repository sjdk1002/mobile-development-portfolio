import assert from "node:assert/strict";
import test from "node:test";
import { act, createElement, StrictMode } from "react";
import { createRoot, type Root } from "react-dom/client";
import { JSDOM } from "jsdom";
import { RequestPool, type RequestScope } from "../src/RequestPool.js";
import { useSharedResource, type ResourceState } from "../src/useSharedResource.js";

const dom = new JSDOM("<!doctype html><html><body></body></html>");
Object.assign(globalThis, { window: dom.window, document: dom.window.document, IS_REACT_ACT_ENVIRONMENT: true });
const scope = { brand: "demo", role: "operator", user: "sample-user" };
function deferred<T>() {
  let resolve!: (value: T) => void;
  const promise = new Promise<T>((yes) => { resolve = yes; });
  return { promise, resolve };
}

type Snapshot = ResourceState<string> & { reload(): void };
const snapshots = new Map<string, Snapshot>();
function Probe(props: { id: string; pool: RequestPool<string>; scope: RequestScope; loader: (signal: AbortSignal) => Promise<string> }) {
  const result = useSharedResource(props.pool, props.scope, props.loader);
  snapshots.set(props.id, result);
  return createElement("span", null, result.data ?? result.status);
}
async function mount(): Promise<{ root: Root; container: HTMLDivElement }> {
  snapshots.clear();
  const container = document.createElement("div");
  document.body.append(container);
  return { root: createRoot(container), container };
}
async function unmount(root: Root, container: HTMLDivElement) {
  await act(async () => root.unmount());
  container.remove();
}

test("React consumers share one request and unmount independently", async () => {
  const { root, container } = await mount();
  const pool = new RequestPool<string>();
  const pending = deferred<string>();
  let signal!: AbortSignal;
  let calls = 0;
  const loader = (input: AbortSignal) => { calls += 1; signal = input; return pending.promise; };
  const probe = (id: string) => createElement(Probe, { key: id, id, pool, scope, loader });
  try {
    await act(async () => root.render(createElement("div", null, probe("a"), probe("b"))));
    assert.equal(calls, 1);
    await act(async () => root.render(createElement("div", null, probe("b"))));
    assert.equal(signal.aborted, false);
    await act(async () => pending.resolve("shared"));
    assert.equal(snapshots.get("b")?.data, "shared");
  } finally { await unmount(root, container); }
});

test("changing scope ignores late results belonging to the previous screen", async () => {
  const { root, container } = await mount();
  const pool = new RequestPool<string>();
  const first = deferred<string>();
  const second = deferred<string>();
  let calls = 0;
  const loader = () => (++calls === 1 ? first.promise : second.promise);
  const render = (user: string) => createElement(Probe, { id: "a", pool, scope: { ...scope, user }, loader });
  try {
    await act(async () => root.render(render("one")));
    await act(async () => root.render(render("two")));
    await act(async () => second.resolve("new screen"));
    await act(async () => first.resolve("old screen"));
    assert.equal(snapshots.get("a")?.data, "new screen");
    assert.equal(snapshots.get("a")?.status, "ready");
  } finally { await unmount(root, container); }
});

test("a forced refresh lets other consumers join the replacement request", async () => {
  const { root, container } = await mount();
  const pool = new RequestPool<string>();
  const old = deferred<string>();
  const current = deferred<string>();
  let calls = 0;
  const loader = (signal: AbortSignal) => {
    calls += 1;
    if (calls > 1) return current.promise;
    return new Promise<string>((resolve, reject) => {
      void old.promise.then(resolve);
      signal.addEventListener("abort", () => reject(signal.reason), { once: true });
    });
  };
  const probe = (id: string) => createElement(Probe, { key: id, id, pool, scope, loader });
  try {
    await act(async () => root.render(createElement("div", null, probe("a"), probe("b"))));
    await act(async () => snapshots.get("a")?.reload());
    assert.equal(calls, 2);
    await act(async () => current.resolve("refreshed"));
    assert.equal(snapshots.get("a")?.data, "refreshed");
    assert.equal(snapshots.get("b")?.data, "refreshed");
  } finally { await unmount(root, container); }
});

test("React StrictMode effect cleanup does not leave the new request cancelled", async () => {
  const { root, container } = await mount();
  const pool = new RequestPool<string>();
  const loader = async () => "strict mode result";
  try {
    await act(async () => root.render(createElement(StrictMode, null, createElement(Probe, { id: "a", pool, scope, loader }))));
    assert.equal(snapshots.get("a")?.data, "strict mode result");
  } finally { await unmount(root, container); }
});
