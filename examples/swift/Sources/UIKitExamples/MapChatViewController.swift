// 공개용으로 재구현한 예제. 제품 원본 코드가 아닙니다.
#if canImport(UIKit)
import UIKit
import CaseStudyCore

@MainActor
public protocol MapResources: AnyObject {
    /// 실제 지도 SDK 어댑터에서 마커·터치 핸들러 연결을 정리할 자리입니다.
    func removeMarkers()
}

@MainActor
public protocol ChatEvents: AnyObject {
    var onMessage: ((ChatMessage) -> Void)? { get set }
}

@MainActor
public final class MapChatViewController: UIViewController {
    private let map: any MapResources
    private let chat: any ChatEvents
    private let cleanup = CleanupScope()
    private let messageLabel = UILabel()

    public init(map: any MapResources, chat: any ChatEvents) {
        self.map = map
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("Use init(map:chat:)") }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = "메시지 수신 대기"
        view.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        chat.onMessage = { [weak self] message in
            self?.messageLabel.text = message.text
        }
        cleanup.insert { [weak map, weak chat] in
            map?.removeMarkers()
            chat?.onMessage = nil
        }
    }

    public func close(animated: Bool = true) {
        cleanup.close()
        dismiss(animated: animated)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let isClosing = isBeingDismissed || isMovingFromParent
            || navigationController?.isBeingDismissed == true
        guard isClosing else { return }

        if let coordinator = transitionCoordinator {
            // 취소된 뒤로 가기 제스처에서는 연결을 유지합니다.
            coordinator.animate(alongsideTransition: nil) { [weak self] context in
                if !context.isCancelled { self?.cleanup.close() }
            }
        } else {
            cleanup.close()
        }
    }
}
#endif
