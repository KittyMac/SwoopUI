import Foundation
import Flynn

// swiftlint:disable identifier_name
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_parameter_count

public class Bitmap {

    private var width: Int = 0
    private var height: Int = 0
    private let channels: Int = 4

    private var bytes: UnsafeMutablePointer<UInt8>
    private var bytes32: UnsafeMutablePointer<UInt32>

    public var rowBytes: Int {
        return width * channels
    }

    init(_ width: Int, _ height: Int) {
        self.width = width
        self.height = height

        bytes = UnsafeMutablePointer<UInt8>.allocate(capacity: width * height * channels)
        bytes32 = bytes.withMemoryRebound(to: UInt32.self, capacity: width * height) { ptr in return ptr }

        clear()
    }

    deinit {
        bytes.deallocate()
    }

    fileprivate init(reference: Bitmap) {
        self.width = reference.width
        self.height = reference.height
        bytes = reference.bytes
        bytes32 = reference.bytes32
    }

    func resize(_ width: Int, _ height: Int) {
        if self.width != width || self.height != height {
            let old = Bitmap(reference: self)
            self.width = width
            self.height = height
            bytes = UnsafeMutablePointer<UInt8>.allocate(capacity: width * height * channels)
            bytes32 = bytes.withMemoryRebound(to: UInt32.self, capacity: width * height) { ptr in return ptr }

            blit(bytes32,
                 Rect(x: 0, y: 0, width: width, height: height),
                 rowBytes,
                 old.bytes32,
                 Rect(x: 0, y: 0, width: old.width, height: old.height),
                 old.rowBytes)
        }
    }

    func clear() {
        bytes32.initialize(repeating: 0, count: width * height)
    }

    func ascii() -> String {
        // Convert each pixel to greyscale value 0-9, then print each pixel as single ascii digit
        var ptr = bytes
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
                case 0: string.append("@")
                case 1: string.append("%")
                case 2: string.append("#")
                case 3: string.append("*")
                case 4: string.append("+")
                case 5: string.append("=")
                case 6: string.append("-")
                case 7: string.append(":")
                case 8: string.append(".")
                default: string.append(" ")
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

    // MARK: - Public Drawing

    func get(_ x: Int, _ y: Int) -> UInt32 {
        return bytes32[y * width + x]
    }

    func set(_ x: Int, _ y: Int, _ color: Color) {
        bytes32[y * width + x] = color.rgba32
    }

    func fill(_ color: Color) {
        bytes32.initialize(repeating: color.rgba32, count: width * height)
    }

    func copy(_ srcBitmap: Bitmap, _ srcRect: Rect, _ dstRect: Rect) {
        if srcRect.width == dstRect.width && srcRect.height == dstRect.height {
            blitExact(bytes32,
                      dstRect,
                      rowBytes,
                      srcBitmap.bytes32,
                      srcRect,
                      srcBitmap.rowBytes)
            return
        }

        blit(bytes32,
             dstRect,
             rowBytes,
             srcBitmap.bytes32,
             srcRect,
             srcBitmap.rowBytes)
    }

    func copy(_ srcBitmap: Bitmap, _ dstRect: Rect) {
        copy(srcBitmap,
             Rect(x: 0, y: 0, width: srcBitmap.width, height: srcBitmap.height), dstRect)
    }

    func copy(_ srcBitmap: Bitmap, _ dstPoint: Point) {
        copy(srcBitmap,
             Rect(x: dstPoint.x, y: dstPoint.y, width: srcBitmap.width, height: srcBitmap.height))
    }

    func copy(_ srcBitmap: Bitmap) {
        copy(srcBitmap,
             Rect(x: 0, y: 0, width: srcBitmap.width, height: srcBitmap.height),
             Rect(x: 0, y: 0, width: srcBitmap.width, height: srcBitmap.height))
    }

    // MARK: - Private Drawing

    private func blitExact(_ dstPtr32: UnsafeMutablePointer<UInt32>,
                           _ dstRect: Rect,
                           _ dstRowBytes: Int,
                           _ srcPtr32: UnsafeMutablePointer<UInt32>,
                           _ srcRect: Rect,
                           _ srcRowBytes: Int) {
        // Assumes that the two rectangles are the same size and
        // do not exceed the bounds of their respective bitmaps
        let dstRowOffset = (dstRowBytes / 4)
        let srcRowOffset = (srcRowBytes / 4)
        var dst = dstPtr32 + (dstRect.y * dstRowOffset) + dstRect.x
        var src = srcPtr32 + (srcRect.y * srcRowOffset) + srcRect.x
        let dstDelta = dstRowOffset - dstRect.width
        let srcDelta = srcRowOffset - srcRect.width
        for _ in 0..<dstRect.height {
            for _ in 0..<dstRect.width {
                dst.pointee = src.pointee
                dst += 1
                src += 1
            }
            dst += dstDelta
            src += srcDelta
        }
    }

    private func blit(_ dstPtr32: UnsafeMutablePointer<UInt32>,
                      _ dstRect: Rect,
                      _ dstRowBytes: Int,
                      _ srcPtr32: UnsafeMutablePointer<UInt32>,
                      _ srcRect: Rect,
                      _ srcRowBytes: Int) {
        // Assumes that the rectangles do not exceed the
        // bounds of their respective bitmaps
        // adapted from: fastBitmap.c in Graphics Gems 2
        let dstRowOffset = (dstRowBytes / 4)
        let srcRowOffset = (srcRowBytes / 4)

        let xs1 = srcRect.x
        var ys1 = srcRect.y
        let xs2 = srcRect.x + srcRect.width - 1
        let ys2 = srcRect.y + srcRect.height - 1

        let xd1 = dstRect.x
        var yd1 = dstRect.y
        let xd2 = dstRect.x + dstRect.width - 1
        let yd2 = dstRect.y + dstRect.height - 1

        let dx = abs(yd2 - yd1)
        var dy = abs(ys2 - ys1)
        let sx = (yd2 - yd1) > 0 ? 1 : -1
        let sy = (ys2 - ys1) > 0 ? 1 : -1
        var e = (dy << 1) - dx
        let dx2 = dx != 0 ? dx << 1 : 1

        dy = dy << 1

        for _ in 0...dx {

            if true {
                let dx = abs(xd2 - xd1)
                var dy = abs(xs2 - xs1)
                let sx = (xd2 - xd1) > 0 ? 1 : -1
                let sy = (xs2 - xs1) > 0 ? 1 : -1
                var e = (dy << 1) - dx
                let dx2 = dx != 0 ? dx << 1 : 1

                dy = dy << 1

                var y = xs1
                var x = xd1

                for _ in 0...dx {
                    dstPtr32[yd1 * dstRowOffset + x] = srcPtr32[ys1 * srcRowOffset + y]
                    while e >= 0 {
                        y += sy
                        e -= dx2
                    }
                    x += sx
                    e += dy
                }
            }

            while e >= 0 {
                ys1 += sy
                e -= dx2
            }
            yd1 += sx
            e += dy
        }
    }

}
