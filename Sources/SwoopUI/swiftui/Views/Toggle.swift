// swiftlint:disable nesting

public struct Toggle<Label>: View where Label: View {
    public var isOnValue: Binding<Bool>
    public var label: Label

    public init(isOnValue: Binding<Bool>, @ViewBuilder label: () -> Label) {
        self.isOnValue = isOnValue
        self.label = label()
    }

    public var body: some View {
        return label
    }
}

extension Toggle where Label == ToggleStyleConfiguration.Label {
    public init(_ configuration: ToggleStyleConfiguration) {
        self.isOnValue = configuration.isOn
        self.label = configuration.label
    }
}

extension Toggle where Label == Text {
    public init(_ titleKey: LocalizedStringKey, isOn: Binding<Bool>) {
        fatalError()
    }

    public init<S>(_ title: S, isOn: Binding<Bool>) where S: StringProtocol {
        fatalError()
    }
}

public protocol ToggleStyle {
    associatedtype Body: View
    func makeBody(configuration: Self.Configuration) -> Self.Body
    typealias Configuration = ToggleStyleConfiguration
}

public struct ToggleStyleConfiguration {
    public struct Label: View {
        public var body: Never
        public typealias Body = Never
    }

    public let label: ToggleStyleConfiguration.Label

    @_projectedValueProperty($isOn) private var isOnValue: Bool {
        get {
            fatalError()
        }

        nonmutating set {
            withExtendedLifetime(newValue) { }
            fatalError()
        }
    }

    public var isOn: Binding<Bool> {
        return Binding(get: { return self.isOnValue }, set: { newValue in self.isOnValue = newValue })
    }
}

extension View {
    public func toggleStyle<S>(_ style: S) -> some View where S: ToggleStyle {
        return self.modifier(ToggleStyleModifier(style))
    }
}

public struct CheckboxToggleStyle: ToggleStyle {
    public init() { }

    public func makeBody(configuration: CheckboxToggleStyle.Configuration) -> some View {
        return configuration.label
    }
}

public struct ToggleStyleModifier<Style>: ViewModifier {
    public typealias Body = Never
    public typealias Content = View

    var style: Style

    init(_ style: Style) {
        self.style = style
    }
}
