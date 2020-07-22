import Foundation

public protocol View {
    
}

extension View {
    
}

public struct TupleView<T> : View {
    public var value: T
    @inlinable public init(_ value: T) {
        self.value = value
    }
}

public struct EmptyView : View {
    
}
