public struct ZStack<Content>: View where Content: View {
    public let child: Content
    public let alignment: Alignment

    public init(alignment: Alignment = .center, @ViewBuilder content: () -> Content) {
        self.child = content()
        self.alignment = alignment
    }

    public func iterate() -> AnyIterator<View> {
        return singleIterator(child)
    }
}
