internal class AnyLocationBase {
}

internal class AnyLocation<Value>: AnyLocationBase {
    internal let value = UnsafeMutablePointer<Value>.allocate(capacity: 1)

    init(value: Value) {
        self.value.pointee = value
    }
}

@propertyWrapper public struct State<Value>: DynamicProperty {
    internal var value: Value
    internal var location: AnyLocation<Value>?

    public init(wrappedValue value: Value) {
        self.value = value
        self.location = AnyLocation(value: value)
    }

    public init(initialValue value: Value) {
        self.value = value
        self.location = AnyLocation(value: value)
    }

    public var wrappedValue: Value {
        get { return location?.value.pointee ?? value }
        nonmutating set { location?.value.pointee = newValue }
    }

    public var projectedValue: Binding<Value> {
        return Binding(get: { return self.wrappedValue }, set: { newValue in self.wrappedValue = newValue })
    }
}

extension State where Value: ExpressibleByNilLiteral {
    public init() {
        self.init(wrappedValue: nil)
    }
}
