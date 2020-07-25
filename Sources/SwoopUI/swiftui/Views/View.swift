public protocol View {
    func iterate() -> AnyIterator<View>
}

public extension View {
    func iterate() -> AnyIterator<View> {
        return AnyIterator({return nil})
    }
}
