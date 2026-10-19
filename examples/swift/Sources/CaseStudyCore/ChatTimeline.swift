// 공개용으로 재구현한 예제. 제품 원본 코드가 아닙니다.

public struct ChatMessage: Identifiable, Equatable, Sendable {
    public let id: String
    public let sequence: Int
    public let text: String

    public init(id: String, sequence: Int, text: String) {
        self.id = id
        self.sequence = sequence
        self.text = text
    }
}

/// 한 채널의 메시지 목록. UI에서 사용할 때는 메인 액터에서 소유합니다.
public struct ChatTimeline {
    public struct SnapshotToken: Equatable, Sendable {
        fileprivate let generation: UInt64
    }

    private var generation: UInt64 = 0
    private var stored: [String: ChatMessage] = [:]
    private var buffered: [String: ChatMessage] = [:]
    public private(set) var isLoadingSnapshot = false

    public init() {}

    public var messages: [ChatMessage] {
        stored.values.sorted {
            $0.sequence == $1.sequence ? $0.id < $1.id : $0.sequence < $1.sequence
        }
    }

    public mutating func beginSnapshot() -> SnapshotToken {
        generation += 1
        isLoadingSnapshot = true
        buffered.removeAll()
        return SnapshotToken(generation: generation)
    }

    public mutating func receive(_ message: ChatMessage) {
        if isLoadingSnapshot {
            // 초기 조회 중 이벤트를 버리지 않고, ID별 마지막 값을 보관합니다.
            buffered[message.id] = message
        } else {
            stored[message.id] = message
        }
    }

    @discardableResult
    public mutating func completeSnapshot(
        _ snapshot: [ChatMessage], token: SnapshotToken
    ) -> Bool {
        guard accepts(token) else { return false }
        stored = Dictionary(snapshot.map { ($0.id, $0) }, uniquingKeysWith: { _, last in last })
        stored.merge(buffered, uniquingKeysWith: { _, event in event })
        finishLoading()
        return true
    }

    @discardableResult
    public mutating func failSnapshot(token: SnapshotToken) -> Bool {
        guard accepts(token) else { return false }
        // 조회가 실패해도 그동안 수신한 메시지와 기존 목록을 유지합니다.
        stored.merge(buffered, uniquingKeysWith: { _, event in event })
        finishLoading()
        return true
    }

    private func accepts(_ token: SnapshotToken) -> Bool {
        isLoadingSnapshot && token.generation == generation
    }

    private mutating func finishLoading() {
        buffered.removeAll()
        isLoadingSnapshot = false
    }
}
