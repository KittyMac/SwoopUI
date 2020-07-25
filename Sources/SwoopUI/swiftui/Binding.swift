@propertyWrapper @dynamicMemberLookup public struct Binding<Value> {
    public var transaction: Transaction
    internal var location: AnyLocation<Value>
    fileprivate var value: Value

    public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
        self.transaction = Transaction()
        self.location = AnyLocation(value: get())
        self.value = get()
        set(value)
    }

    public init(get: @escaping () -> Value, set: @escaping (Value, Transaction) -> Void) {
        self.transaction = Transaction()
        self.location = AnyLocation(value: get())
        self.value = get()
        set(value, self.transaction)
    }

    public static func constant(_ value: Value) -> Binding<Value> {
        fatalError()
    }

    public var wrappedValue: Value {
        get { return location.value.pointee }
        nonmutating set { location.value.pointee = newValue }
    }

    public var projectedValue: Binding<Value> {
        self
    }

    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Value, Subject>) -> Binding<Subject> {
        fatalError()
    }
}

class StoredLocation<Value>: AnyLocation<Value> {

}

extension Binding {
    public func transaction(_ transaction: Transaction) -> Binding<Value> {
        fatalError()
    }
}

extension Binding {
    public init<V>(_ base: Binding<V>) where Value == V? {
        fatalError()
    }

    public init?(_ base: Binding<Value?>) {
        fatalError()
    }

    public init<V>(_ base: Binding<V>) where Value == AnyHashable, V: Hashable {
        fatalError()
    }
}
