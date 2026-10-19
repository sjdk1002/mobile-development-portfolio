// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MobileDevelopmentExamples",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "CaseStudyCore", targets: ["CaseStudyCore"]),
        .library(name: "UIKitExamples", targets: ["UIKitExamples"])
    ],
    targets: [
        .target(name: "CaseStudyCore"),
        .target(name: "UIKitExamples", dependencies: ["CaseStudyCore"]),
        .testTarget(name: "CaseStudyCoreTests", dependencies: ["CaseStudyCore"])
    ]
)
