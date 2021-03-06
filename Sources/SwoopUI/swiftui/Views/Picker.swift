import Foundation

public protocol PickerStyle {

}

extension View {
    public func pickerStyle<S>(_ style: S) -> View where S: PickerStyle {
        return self.modifier(PickerStyleWriter(style))
    }
}

public struct SegmentedPickerStyle: PickerStyle {
    public init() { }
}

public struct DefaultPickerStyle: PickerStyle {
    public init() { }
}

public struct PopUpButtonPickerStyle: PickerStyle {
    public init() { }
}

public struct Picker<Label, SelectionValue, Content>: View where Label: View, SelectionValue: Hashable, Content: View {
    let selection: Binding<SelectionValue>
    let label: Label
    let content: Content

    public init(selection: Binding<SelectionValue>, label: Label, @ViewBuilder content: () -> Content) {
        self.selection = selection
        self.label = label
        self.content = content()
    }

    public var body: View {
        HStack {
            label
            content
        }
    }
}

extension Picker where Label == Text {
    public init(_ titleKey: LocalizedStringKey,
                selection: Binding<SelectionValue>,
                @ViewBuilder content: () -> Content) {
        self.selection = selection
        self.label = Text(titleKey)
        self.content = content()
    }

    public init<S>(_ title: S,
                   selection: Binding<SelectionValue>,
                   @ViewBuilder content: () -> Content) where S: StringProtocol {
        self.selection = selection
        self.label = Text(title)
        self.content = content()
    }
}

public struct PickerStyleWriter<Style>: ViewModifier {
    public typealias Body = Never
    public typealias Content = View

    var style: Style

    init(_ style: Style) {
        self.style = style
    }
}
