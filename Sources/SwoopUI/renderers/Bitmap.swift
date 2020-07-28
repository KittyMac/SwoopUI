import Foundation
import Flynn

// swiftlint:disable identifier_name
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable line_length

public class Bitmap {

    private var width: Int = 0
    private var height: Int = 0
    private let channels: Int = 4

    private var frontBuffer: UnsafeMutablePointer<UInt8>
    private var backBuffer: UnsafeMutablePointer<UInt8>

    private var frontBuffer32: UnsafeMutablePointer<UInt32>
    private var backBuffer32: UnsafeMutablePointer<UInt32>

    init(_ width: Int, _ height: Int) {
        self.width = width
        self.height = height

        frontBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: width * height * channels)
        frontBuffer32 = frontBuffer.withMemoryRebound(to: UInt32.self, capacity: width * height) { ptr in return ptr }
        backBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: width * height * channels)
        backBuffer32 = backBuffer.withMemoryRebound(to: UInt32.self, capacity: width * height) { ptr in return ptr }

        clear()
    }

    func resize(_ width: Int, _ height: Int) {
        if self.width != width || self.height != height {
            self.width = width
            self.height = height

            frontBuffer.deallocate()
            backBuffer.deallocate()

            frontBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: width * height * channels)
            frontBuffer32 = frontBuffer.withMemoryRebound(to: UInt32.self, capacity: width * height) { ptr in return ptr }
            backBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: width * height * channels)
            backBuffer32 = backBuffer.withMemoryRebound(to: UInt32.self, capacity: width * height) { ptr in return ptr }

            clear()
        }
    }

    func swap() {
        let t = frontBuffer
        frontBuffer = backBuffer
        backBuffer = t
    }

    func clear() {
        frontBuffer32.initialize(repeating: 0, count: width * height)
        backBuffer32.initialize(repeating: 0, count: width * height)
    }

    func ascii() -> String {
        // Convert each pixel to greyscale value 0-9, then print each pixel as single ascii digit
        var ptr = frontBuffer
        var string = String()
        for y in 0..<height {

            if y == 0 {
                string.append("+")
                for _ in 0..<width {
                    string.append("-")
                }
                string.append("+\n")
            }

            string.append("|")

            for _ in 0..<width {
                let v = (ptr[0] / 3 + ptr[1] / 3 + ptr[2] / 3)
                switch v / 25 {
                case 0: string.append(" ")
                case 1: string.append(".")
                case 2: string.append(":")
                case 3: string.append("-")
                case 4: string.append("=")
                case 5: string.append("+")
                case 6: string.append("*")
                case 7: string.append("#")
                case 8: string.append("%")
                default: string.append("@")
                }
                ptr += channels
            }
            string.append("|")
            string.append("\n")

            if y == height-1 {
                string.append("+")
                for _ in 0..<width {
                    string.append("-")
                }
                string.append("+\n")
            }
        }
        return string
    }

    // MARK: - Drawing

    func fill(_ color: Color) {
        backBuffer32.initialize(repeating: color.rgba32, count: width * height)
    }

}
