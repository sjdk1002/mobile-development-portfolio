// 공개용으로 재구현한 예제. 제품 원본 코드가 아닙니다.
import Foundation

public struct SharePayload {
    public enum ValidationError: Error, Equatable {
        case invalidFilename
        case invalidBase64
        case emptyData
    }

    public let filename: String
    public let data: Data

    public init(filename: String, base64: String) throws {
        let trimmed = filename.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed != ".", trimmed != "..",
              !trimmed.contains("/"), !trimmed.contains("\\"),
              !trimmed.unicodeScalars.contains(where: { CharacterSet.controlCharacters.contains($0) })
        else { throw ValidationError.invalidFilename }
        guard let decoded = Data(base64Encoded: base64) else {
            throw ValidationError.invalidBase64
        }
        guard !decoded.isEmpty else { throw ValidationError.emptyData }
        self.filename = trimmed
        self.data = decoded
    }
}
