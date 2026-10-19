import Foundation
import XCTest
@testable import CaseStudyCore

final class SharePayloadTests: XCTestCase {
    func testValidPayloadPreservesData() throws {
        let data = Data("공개용 예제".utf8)
        let payload = try SharePayload(filename: " report.txt ", base64: data.base64EncodedString())
        XCTAssertEqual(payload.filename, "report.txt")
        XCTAssertEqual(payload.data, data)
    }

    func testFilenameCannotContainPathOrControlCharacters() {
        for filename in ["", "..", ".", "../report.txt", "folder/report.txt", "folder\\report.txt", "x\u{0}.txt"] {
            XCTAssertThrowsError(try SharePayload(filename: filename, base64: "YQ==")) {
                XCTAssertEqual($0 as? SharePayload.ValidationError, .invalidFilename)
            }
        }
    }

    func testInvalidBase64AndEmptyDataAreRejected() {
        XCTAssertThrowsError(try SharePayload(filename: "report.txt", base64: "%%%")) {
            XCTAssertEqual($0 as? SharePayload.ValidationError, .invalidBase64)
        }
        XCTAssertThrowsError(try SharePayload(filename: "report.txt", base64: "")) {
            XCTAssertEqual($0 as? SharePayload.ValidationError, .emptyData)
        }
    }
}
