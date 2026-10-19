// 공개용으로 재구현한 예제. 제품 원본 코드가 아닙니다.

@MainActor
public final class PendingChatRouter {
    private var pendingChannelID: String?
    private var isRootReady = false
    private let openChat: (String) -> Void

    public init(openChat: @escaping (String) -> Void) {
        self.openChat = openChat
    }

    /// 초기 화면에서는 마지막으로 요청된 채팅 하나를 보관합니다.
    public func requestOpen(channelID: String) {
        guard !channelID.isEmpty else { return }
        pendingChannelID = channelID
        flushIfReady()
    }

    public func setRootReady(_ ready: Bool) {
        isRootReady = ready
        flushIfReady()
    }

    private func flushIfReady() {
        guard isRootReady, let channelID = pendingChannelID else { return }
        // 라우팅 콜백이 다시 진입하더라도 같은 요청을 반복하지 않습니다.
        pendingChannelID = nil
        openChat(channelID)
    }
}
