public protocol ViewModifier {
    associatedtype Body: View
    typealias Content = Never
    func body(content: Self.Content) -> Self.Body
}

extension ViewModifier where Self.Body == Never {
    public func body(content: Self.Content) -> Self.Body {
        fatalError()
    }
}

extension ViewModifier {
    public func concat<T>(_ modifier: T) -> ModifiedContent<Self, T> {
        return .init(content: self, modifier: modifier)
    }
}
