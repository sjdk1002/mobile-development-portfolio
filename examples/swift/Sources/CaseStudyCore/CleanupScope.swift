// 공개용으로 재구현한 예제. 제품 원본 코드가 아닙니다.

/// 화면이 종료되는 경로에서 자원 정리를 명시적으로 실행합니다.
@MainActor
public final class CleanupScope {
    private var actions: [() -> Void] = []
    public private(set) var isClosed = false

    public init() {}

    public func insert(_ action: @escaping () -> Void) {
        guard !isClosed else {
            action()
            return
        }
        actions.append(action)
    }

    public func close() {
        guard !isClosed else { return }
        isClosed = true

        // 정리 중 다시 close가 호출되어도 중복 실행하지 않습니다.
        let pending = actions.reversed()
        actions.removeAll()
        for action in pending { action() }
    }
}
