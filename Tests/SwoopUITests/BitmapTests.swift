import XCTest
@testable import SwoopUI

final class BitmapTests: XCTestCase {
    func testBitmapEmpty() {
        let bitmap = Bitmap(4, 4)
        XCTAssertEqual(bitmap.ascii(),
            """
            +----+
            |    |
            |    |
            |    |
            |    |
            +----+\n
            """)
    }
    
    func testBitmapFill() {
        let bitmap = Bitmap(4, 4)
        bitmap.fill(Color.red)
        bitmap.swap()
        XCTAssertEqual(bitmap.ascii(),
            """
            +----+
            |----|
            |----|
            |----|
            |----|
            +----+\n
            """)
    }

    static var allTests = [
        ("testBitmapEmpty", testBitmapEmpty),
        ("testBitmapFill", testBitmapFill),
    ]
}
