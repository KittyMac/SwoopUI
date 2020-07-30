// swiftlint:disable identifier_name

#if !canImport(CoreGraphics)

public typealias CGFloat = Float

public enum CGLineCap: Int32 {
    case butt = 0
    case round = 1
    case square = 2
}

public enum CGLineJoin: Int32 {
    case miter = 0
    case round = 1
    case bevel = 2
}

public class CGPath {
}

extension CGPath: Equatable {
    public static func == (lhs: CGPath, rhs: CGPath) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

public class CGMutablePath: CGPath {

}

public struct CGAffineTransform {
    public static var identity: CGAffineTransform {
        return CGAffineTransform()
    }
}

// MARK: - CGPoint

public struct CGPoint {
    public var x: CGFloat
    public var y: CGFloat
    public init() {
        self.init(x: CGFloat(), y: CGFloat())
    }
    public init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
}

extension CGPoint {
    public static var zero: CGPoint {
        return CGPoint(x: CGFloat(0), y: CGFloat(0))
    }

    public init(x: Int, y: Int) {
        self.init(x: CGFloat(x), y: CGFloat(y))
    }

    public init(x: Double, y: Double) {
        self.init(x: CGFloat(x), y: CGFloat(y))
    }
}

extension CGPoint: Equatable {
    public static func == (lhs: CGPoint, rhs: CGPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

extension CGPoint: Codable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let x = try container.decode(CGFloat.self)
        let y = try container.decode(CGFloat.self)
        self.init(x: x, y: y)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(x)
        try container.encode(y)
    }
}

// MARK: - CGSize

public struct CGSize {
    public var width: CGFloat
    public var height: CGFloat
    public init() {
        self.init(width: CGFloat(), height: CGFloat())
    }
    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
}

extension CGSize {
    public static var zero: CGSize {
        return CGSize(width: 0, height: 0)
    }

    public init(width: Int, height: Int) {
        self.init(width: CGFloat(width), height: CGFloat(height))
    }

    public init(width: Double, height: Double) {
        self.init(width: CGFloat(width), height: CGFloat(height))
    }
}

extension CGSize: Equatable {
    public static func == (lhs: CGSize, rhs: CGSize) -> Bool {
        return lhs.width == rhs.width && lhs.height == rhs.height
    }
}

// MARK: - CGRect

public struct CGRect {
    public var origin: CGPoint
    public var size: CGSize
    public init() {
        self.init(origin: CGPoint(), size: CGSize())
    }
    public init(origin: CGPoint, size: CGSize) {
        self.origin = origin
        self.size = size
    }
}

extension CGRect {
    public static var zero: CGRect {
        return CGRect(origin: CGPoint(), size: CGSize())
    }

    public init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height))
    }

    public init(x: Double, y: Double, width: Double, height: Double) {
        self.init(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height))
    }

    public init(x: Int, y: Int, width: Int, height: Int) {
        self.init(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height))
    }
}

extension CGRect {
    public static let null = CGRect(x: CGFloat.infinity,
                                    y: CGFloat.infinity,
                                    width: CGFloat(0),
                                    height: CGFloat(0))

    public static let infinite = CGRect(x: -CGFloat.greatestFiniteMagnitude / 2,
                                        y: -CGFloat.greatestFiniteMagnitude / 2,
                                        width: CGFloat.greatestFiniteMagnitude,
                                        height: CGFloat.greatestFiniteMagnitude)

    public var width: CGFloat { return abs(self.size.width) }
    public var height: CGFloat { return abs(self.size.height) }

    public var minX: CGFloat { return self.origin.x + min(self.size.width, 0) }
    public var midX: CGFloat { return (self.minX + self.maxX) * 0.5 }
    public var maxX: CGFloat { return self.origin.x + max(self.size.width, 0) }

    public var minY: CGFloat { return self.origin.y + min(self.size.height, 0) }
    public var midY: CGFloat { return (self.minY + self.maxY) * 0.5 }
    public var maxY: CGFloat { return self.origin.y + max(self.size.height, 0) }

    public var isEmpty: Bool { return self.isNull || self.size.width == 0 || self.size.height == 0 }
    public var isInfinite: Bool { return self == .infinite }
    public var isNull: Bool { return self.origin.x == .infinity || self.origin.y == .infinity }

    public func contains(_ point: CGPoint) -> Bool {
        if self.isNull || self.isEmpty { return false }

        return (self.minX..<self.maxX).contains(point.x) && (self.minY..<self.maxY).contains(point.y)
    }

    public func contains(_ rect2: CGRect) -> Bool {
        return self.union(rect2) == self
    }

    public var standardized: CGRect {
        if self.isNull { return .null }

        return CGRect(x: self.minX,
                      y: self.minY,
                      width: self.width,
                      height: self.height)
    }

    public var integral: CGRect {
        if self.isNull { return self }

        let standardized = self.standardized
        let x = standardized.origin.x.rounded(.down)
        let y = standardized.origin.y.rounded(.down)
        let width = (standardized.origin.x + standardized.size.width).rounded(.up) - x
        let height = (standardized.origin.y + standardized.size.height).rounded(.up) - y
        return CGRect(x: x, y: y, width: width, height: height)
    }

    public func insetBy(dx: CGFloat, dy: CGFloat) -> CGRect {
        if self.isNull { return self }

        var rect = self.standardized

        rect.origin.x += dx
        rect.origin.y += dy
        rect.size.width -= 2 * dx
        rect.size.height -= 2 * dy

        if rect.size.width < 0 || rect.size.height < 0 {
            return .null
        }

        return rect
    }

    public func union(_ r2: CGRect) -> CGRect {
        if self.isNull {
            return r2
        } else if r2.isNull {
            return self
        }

        let rect1 = self.standardized
        let rect2 = r2.standardized

        let minX = min(rect1.minX, rect2.minX)
        let minY = min(rect1.minY, rect2.minY)
        let maxX = max(rect1.maxX, rect2.maxX)
        let maxY = max(rect1.maxY, rect2.maxY)

        return CGRect(x: minX,
                      y: minY,
                      width: maxX - minX,
                      height: maxY - minY)
    }

    public func intersection(_ r2: CGRect) -> CGRect {
        if self.isNull || r2.isNull { return .null }

        let rect1 = self.standardized
        let rect2 = r2.standardized

        let rect1SpanH = rect1.minX...rect1.maxX
        let rect1SpanV = rect1.minY...rect1.maxY

        let rect2SpanH = rect2.minX...rect2.maxX
        let rect2SpanV = rect2.minY...rect2.maxY

        if !rect1SpanH.overlaps(rect2SpanH) || !rect1SpanV.overlaps(rect2SpanV) {
            return .null
        }

        let overlapH = rect1SpanH.clamped(to: rect2SpanH)
        let overlapV = rect1SpanV.clamped(to: rect2SpanV)

        let width: CGFloat
        if overlapH == rect1SpanH {
            width = rect1.width
        } else if overlapH == rect2SpanH {
            width = rect2.width
        } else {
            width = overlapH.upperBound - overlapH.lowerBound
        }

        let height: CGFloat
        if overlapV == rect1SpanV {
            height = rect1.height
        } else if overlapV == rect2SpanV {
            height = rect2.height
        } else {
            height = overlapV.upperBound - overlapV.lowerBound
        }

        return CGRect(x: overlapH.lowerBound,
                      y: overlapV.lowerBound,
                      width: width,
                      height: height)
    }

    public func intersects(_ r2: CGRect) -> Bool {
        return !self.intersection(r2).isNull
    }

    public func offsetBy(dx: CGFloat, dy: CGFloat) -> CGRect {
        if self.isNull { return self }

        var rect = self.standardized
        rect.origin.x += dx
        rect.origin.y += dy
        return rect
    }
}

extension CGRect: Equatable {
    public static func == (lhs: CGRect, rhs: CGRect) -> Bool {
        if lhs.isNull && rhs.isNull { return true }

        let r1 = lhs.standardized
        let r2 = rhs.standardized
        return r1.origin == r2.origin && r1.size == r2.size
    }
}

#endif
