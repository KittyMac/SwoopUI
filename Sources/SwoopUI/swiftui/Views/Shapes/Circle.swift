import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

public struct Circle: Shape {
    public func path(in rect: CGRect) -> Path {
        fatalError()
    }
    public init() {}
}
