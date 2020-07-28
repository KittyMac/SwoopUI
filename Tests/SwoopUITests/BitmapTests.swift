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
    
    func testBitmapFill1() {
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
    
    func testBitmapFill2() {
        let bitmap = Bitmap(4, 4)
        bitmap.fill(Color.white)
        bitmap.swap()
        XCTAssertEqual(bitmap.ascii(),
            """
            +----+
            |@@@@|
            |@@@@|
            |@@@@|
            |@@@@|
            +----+\n
            """)
    }

    static var allTests = [
        ("testBitmapEmpty", testBitmapEmpty),
        ("testBitmapFill1", testBitmapFill1),
        ("testBitmapFill2", testBitmapFill2),
    ]
}
