import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

public struct HStack<Content>: View where Content: View {
    public let child: Content
    public let alignment: HorizontalAlignment
    public let spacing: CGFloat?

    public init(alignment: HorizontalAlignment = .center,
                spacing: CGFloat? = nil,
                @ViewBuilder content: () -> Content) {
        self.child = content()
        self.alignment = alignment
        self.spacing = spacing
    }

    public func iterate() -> AnyIterator<View> {
        return singleIterator(child)
    }
}
