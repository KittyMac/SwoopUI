import XCTest
@testable import SwoopUI

final class BitmapTests: XCTestCase {
    
    func testBitmapEmpty() {
        let bitmap = Bitmap(4, 4)
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
    
    func testBitmapFill1() {
        let bitmap = Bitmap(4, 4)
        bitmap.fill(Color.red)
        XCTAssertEqual(bitmap.ascii(),
            """
            +----+
            |++++|
            |++++|
            |++++|
            |++++|
            +----+\n
            """)
    }
    
    func testBitmapFill2() {
        let bitmap = Bitmap(4, 4)
        bitmap.fill(Color.white, Rect(x: 1, y: 1, width: 2, height: 2))
        XCTAssertEqual(bitmap.ascii(),
            """
            +----+
            |@@@@|
            |@  @|
            |@  @|
            |@@@@|
            +----+\n
            """)
    }
    
    func testBitmapResize() {
        let bitmap = Bitmap(2, 2)
        bitmap.set(0, 0, Color(white: 0.0))
        bitmap.set(1, 0, Color(white: 0.25))
        bitmap.set(0, 1, Color(white: 0.5))
        bitmap.set(1, 1, Color(white: 0.75))
        XCTAssertEqual(bitmap.ascii(),
        """
        +--+
        |@#|
        |+:|
        +--+\n
        """)
        bitmap.scaleTo(7, 7)
        XCTAssertEqual(bitmap.ascii(),
            """
            +-------+
            |@@@####|
            |@@@####|
            |@@@####|
            |+++::::|
            |+++::::|
            |+++::::|
            |+++::::|
            +-------+\n
            """)
        bitmap.scaleTo(5, 2)
        XCTAssertEqual(bitmap.ascii(),
        """
        +-----+
        |@@###|
        |++:::|
        +-----+\n
        """)
        bitmap.scaleTo(1, 1)
        XCTAssertEqual(bitmap.ascii(),
        """
        +-+
        |@|
        +-+\n
        """)
    }
    
    func testBitmapResizePerformance() {
        let s = 2048
        let s3 = s * 3
        let bitmap = Bitmap(s, s)
        measure {
            bitmap.resize(s3, s3)
            bitmap.resize(s, s)
        }
    }
    
    func testBitmapCopyPerformance() {
        let s = 2048
        let bitmap1 = Bitmap(s, s)
        let bitmap2 = Bitmap(s, s)
        bitmap2.fill(Color(rgba32: 0xFFFFFF10))
        measure {
            bitmap1.draw(bitmap2, pixelCopy)
        }
    }
    
    func testBitmapSrcOverPerformance() {
        let s = 2048
        let bitmap1 = Bitmap(s, s)
        let bitmap2 = Bitmap(s, s)
        bitmap2.fill(Color(rgba32: 0xFFFFFF10))
        measure {
            bitmap1.draw(bitmap2, pixelSrcOver)
        }
    }
    
    func testBitmapSrcOver() {
        let bitmap1 = Bitmap(4, 4)
        bitmap1.fill(Color.black)
        let bitmap2 = Bitmap(4, 4)
        bitmap2.fill(Color(rgba32: 0xFFFFFF7F))
        bitmap1.draw(bitmap2)
        XCTAssertEqual(bitmap1.ascii(),
            """
            +----+
            |++++|
            |++++|
            |++++|
            |++++|
            +----+\n
            """)
    }    

    static var allTests = [
        ("testBitmapEmpty", testBitmapEmpty),
        ("testBitmapFill1", testBitmapFill1),
        ("testBitmapFill2", testBitmapFill2),
        ("testBitmapResize", testBitmapResize),
    ]
}
