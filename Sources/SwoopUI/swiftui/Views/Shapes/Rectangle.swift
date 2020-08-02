import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

public struct Rectangle: Shape {
    public func path(in rect: CGRect) -> Path {
        fatalError()
    }
    public init() {}
}
