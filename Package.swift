// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "FinanceFlow",
    products: [.library(name: "FinanceCore", targets: ["FinanceCore"])],
    targets: [
        .target(name: "FinanceCore"),
        .testTarget(name: "FinanceCoreTests", dependencies: ["FinanceCore"])
    ]
)
