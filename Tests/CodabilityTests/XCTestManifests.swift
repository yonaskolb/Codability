import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AnyContainerTests.allTests),
        testCase(AnyDecodableTests.allTests),
        testCase(AnyEncodableTests.allTests),
    ]
}
#endif
