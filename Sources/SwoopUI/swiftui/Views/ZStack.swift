public struct ZStack<Content>: View where Content: View {
    public let children: Content
    public let alignment: Alignment

    public init(alignment: Alignment = .center, @ViewBuilder content: () -> Content) {
        self.children = content()
        self.alignment = alignment
    }

    public func iterate() -> AnyIterator<View> {
        return children.iterate()
    }
}

extension ZStack {

}
