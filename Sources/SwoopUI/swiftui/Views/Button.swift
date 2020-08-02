public struct Button<Label>: View where Label: View {
    public let label: Label
    public let action: () -> Void

    public init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
    }
}

extension Button where Label == Text {
    public init<S: StringProtocol>(_ title: S, action: @escaping () -> Void) {
        self.action = action
        self.label = Text(title)
    }
}

public protocol ButtonStyle {
    associatedtype Body: View
    func makeBody(configuration: Self.Configuration) -> Self.Body
    typealias Configuration = ButtonStyleConfiguration
}

public struct ButtonStyleConfiguration {
    public struct Label: View {
        public var storage: Any

        init(_ storage: Any) {
            self.storage = storage
        }
    }
    public let label: Label
    public let isPressed: Bool
}

extension View {
    public func buttonStyle<S>(_ style: S) -> View where S: ButtonStyle {
        let label = ButtonStyleConfiguration.Label(self)
        let configuration = ButtonStyleConfiguration(label: label, isPressed: false)
        return style.makeBody(configuration: configuration)
    }
}
