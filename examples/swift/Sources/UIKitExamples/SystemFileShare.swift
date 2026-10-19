// 공개용으로 재구현한 예제. 제품 원본 코드가 아닙니다.
#if canImport(UIKit)
import UIKit
import CaseStudyCore

@MainActor
public enum SystemFileShare {
    public enum PresentationError: Error {
        case presenterNotVisible
        case alreadyPresenting
    }

    /// 닫힘·취소 후 이 공유 요청만의 임시 폴더를 지웁니다.
    public static func present(
        _ payload: SharePayload,
        from presenter: UIViewController,
        sourceView: UIView,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) throws {
        guard presenter.viewIfLoaded?.window != nil else {
            throw PresentationError.presenterNotVisible
        }
        guard presenter.presentedViewController == nil else {
            throw PresentationError.alreadyPresenting
        }

        let files = FileManager.default
        let directory = files.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try files.createDirectory(at: directory, withIntermediateDirectories: true)
        let fileURL = directory.appendingPathComponent(payload.filename)
        do {
            try payload.data.write(to: fileURL, options: .atomic)
        } catch {
            try? files.removeItem(at: directory)
            throw error
        }

        let controller = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        if let popover = controller.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceView.bounds
        }
        controller.completionWithItemsHandler = { _, completed, _, error in
            try? files.removeItem(at: directory)
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(completed))
            }
        }
        presenter.present(controller, animated: true)
    }
}
#endif
