public struct Group<Content> {
    public var _content: Content
}

extension Group: View where Content: View {
    public init(@ViewBuilder content: () -> Content) {
        self._content = content()
    }
}
