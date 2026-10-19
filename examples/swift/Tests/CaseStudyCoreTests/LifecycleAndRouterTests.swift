import XCTest
@testable import CaseStudyCore

final class LifecycleAndRouterTests: XCTestCase {
    func testCleanupRunsOnceInReverseOrder() async {
        await MainActor.run {
            var events: [Int] = []
            let scope = CleanupScope()
            scope.insert { events.append(1) }
            scope.insert { events.append(2) }
            scope.close()
            scope.close()
            XCTAssertEqual(events, [2, 1])
        }
    }

    func testCleanupRegisteredAfterClosingRunsImmediately() async {
        await MainActor.run {
            let scope = CleanupScope()
            scope.close()
            var cleaned = false
            scope.insert { cleaned = true }
            XCTAssertTrue(cleaned)
        }
    }

    func testReentrantCleanupDoesNotRunTwice() async {
        await MainActor.run {
            var count = 0
            let scope = CleanupScope()
            scope.insert { count += 1; scope.close() }
            scope.close()
            XCTAssertEqual(count, 1)
        }
    }

    func testNotificationWaitsForRootAndIsConsumedOnce() async {
        await MainActor.run {
            var opened: [String] = []
            let router = PendingChatRouter { opened.append($0) }
            router.requestOpen(channelID: "channel-a")
            XCTAssertTrue(opened.isEmpty)
            router.setRootReady(true)
            router.setRootReady(true)
            XCTAssertEqual(opened, ["channel-a"])
        }
    }

    func testLatestPendingNotificationIsUsed() async {
        await MainActor.run {
            var opened: [String] = []
            let router = PendingChatRouter { opened.append($0) }
            router.requestOpen(channelID: "channel-a")
            router.requestOpen(channelID: "channel-b")
            router.requestOpen(channelID: "")
            router.setRootReady(true)
            XCTAssertEqual(opened, ["channel-b"])
        }
    }

    func testNewNotificationWaitsWhenRootBecomesUnavailable() async {
        await MainActor.run {
            var opened: [String] = []
            let router = PendingChatRouter { opened.append($0) }
            router.setRootReady(true)
            router.requestOpen(channelID: "first")
            router.setRootReady(false)
            router.requestOpen(channelID: "second")
            XCTAssertEqual(opened, ["first"])
            router.setRootReady(true)
            XCTAssertEqual(opened, ["first", "second"])
        }
    }
}
