public class AnyViewStorageBase {

}

public class AnyViewStorage<V: View>: AnyViewStorageBase {
    public var view: V

    init(_ view: V) {
        self.view = view
    }
}

public struct AnyView: View {
    public var storage: AnyViewStorageBase

    public init<V>(_ view: V) where V: View {
        storage = AnyViewStorage<V>(view)
    }

    public init?(_fromValue value: Any) {
        fatalError()
    }
}
