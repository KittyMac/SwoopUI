public struct TupleView<T>: View {
    public var value: T
    
    public init(_ value: T) {
        self.value = value
    }
}

extension TupleView {
    public func iterate() -> AnyIterator<View> {
        var index = 0
        let tupleMirror = Mirror(reflecting: value)
        let tupleElements = tupleMirror.children.map({ $0.value })

        return AnyIterator({
            if index < tupleElements.count {
                let result = tupleElements[index]
                index += 1
                return result as? View
            } 
            return nil
        })
    }
}
