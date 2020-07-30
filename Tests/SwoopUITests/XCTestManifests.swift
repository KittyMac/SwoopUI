import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SwoopUITests.allTests),
        testCase(BitmapTests.allTests),
    ]
}
#endif
