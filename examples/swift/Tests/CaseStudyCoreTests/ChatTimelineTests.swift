import XCTest
@testable import CaseStudyCore

final class ChatTimelineTests: XCTestCase {
    private func message(_ id: String, _ sequence: Int, text: String = "예제") -> ChatMessage {
        ChatMessage(id: id, sequence: sequence, text: text)
    }

    func testSnapshotAndRealtimeOverlapProduceOneMessagePerID() {
        var timeline = ChatTimeline()
        let token = timeline.beginSnapshot()
        timeline.receive(message("two", 2))
        timeline.receive(message("three", 3))
        timeline.completeSnapshot([message("one", 1), message("two", 2)], token: token)
        XCTAssertEqual(timeline.messages.map(\.id), ["one", "two", "three"])
    }

    func testRealtimeUpdateWinsOverSnapshot() {
        var timeline = ChatTimeline()
        let token = timeline.beginSnapshot()
        timeline.receive(message("one", 1, text: "새 내용"))
        timeline.completeSnapshot([message("one", 1, text: "이전 내용")], token: token)
        XCTAssertEqual(timeline.messages.first?.text, "새 내용")
    }

    func testOldSnapshotCannotReplaceNewLoad() {
        var timeline = ChatTimeline()
        let old = timeline.beginSnapshot()
        let current = timeline.beginSnapshot()
        XCTAssertFalse(timeline.completeSnapshot([message("old", 1)], token: old))
        XCTAssertTrue(timeline.isLoadingSnapshot)
        timeline.completeSnapshot([message("current", 2)], token: current)
        XCTAssertEqual(timeline.messages.map(\.id), ["current"])
    }

    func testFailurePreservesExistingAndBufferedMessages() {
        var timeline = ChatTimeline()
        timeline.receive(message("one", 1))
        let token = timeline.beginSnapshot()
        timeline.receive(message("two", 2))
        XCTAssertTrue(timeline.failSnapshot(token: token))
        XCTAssertFalse(timeline.isLoadingSnapshot)
        XCTAssertEqual(timeline.messages.map(\.id), ["one", "two"])
        XCTAssertFalse(timeline.completeSnapshot([], token: token))
    }

    func testDuplicateEventsUpdateInPlaceAndOrderingIsStable() {
        var timeline = ChatTimeline()
        timeline.receive(message("b", 1))
        timeline.receive(message("a", 1))
        timeline.receive(message("b", 1, text: "수정"))
        XCTAssertEqual(timeline.messages.map(\.id), ["a", "b"])
        XCTAssertEqual(timeline.messages.last?.text, "수정")
    }
}
