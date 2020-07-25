import Foundation

public struct VStack<Content>: View where Content: View {
    public let children: Content
    public let alignment: HorizontalAlignment
    public let spacing: CGFloat?

    public init(alignment: HorizontalAlignment = .center,
                spacing: CGFloat? = nil,
                @ViewBuilder content: () -> Content) {
        self.children = content()
        self.alignment = alignment
        self.spacing = spacing
    }

    public func iterate() -> AnyIterator<View> {
        return children.iterate()
    }
}

extension VStack {

}
