public struct Group<Content> {
    public var content: Content
}

extension Group: View where Content: View {
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
}
