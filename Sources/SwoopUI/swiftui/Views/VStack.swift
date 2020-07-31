import Foundation

public struct VStack<Content>: View where Content: View {
    public let child: Content
    public let alignment: VerticalAlignment
    public let spacing: CGFloat?

    public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.child = content()
        self.alignment = alignment
        self.spacing = spacing
    }

    public func iterate() -> AnyIterator<View> {
        return singleIterator(child)
    }
}
