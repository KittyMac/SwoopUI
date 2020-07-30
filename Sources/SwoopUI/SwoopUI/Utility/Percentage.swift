// https://fabiancanas.com/blog/2015/5/21/making-a-numeric-type-in-swift.html

import Foundation

postfix operator %
public postfix func % (pct: Float) -> Percentage {
    return Percentage(pct)
}

public struct Percentage: PercentageNumericType {
    public var value: Float
    public init(_ value: Float) {
        self.value = value
    }

#if canImport(CoreGraphics)
    public init(_ value: CGFloat) {
        self.value = Float(value)
    }
#endif
}

public protocol PercentageNumericType: Comparable {
    var value: Float { get set }
    init(_ value: Float)
}

public func + <T: PercentageNumericType> (lhs: T, rhs: T) -> T {
    return T(lhs.value + rhs.value)
}

public func - <T: PercentageNumericType> (lhs: T, rhs: T) -> T {
    return T(lhs.value - rhs.value)
}

public func < <T: PercentageNumericType> (lhs: T, rhs: T) -> Bool {
    return lhs.value < rhs.value
}

public func == <T: PercentageNumericType> (lhs: T, rhs: T) -> Bool {
    return lhs.value == rhs.value
}

public prefix func - <T: PercentageNumericType> (number: T) -> T {
    return T(-number.value)
}

public func += <T: PercentageNumericType> (lhs: inout T, rhs: T) {
    lhs.value += rhs.value
}

public func -= <T: PercentageNumericType> (lhs: inout T, rhs: T) {
    lhs.value -= rhs.value
}
