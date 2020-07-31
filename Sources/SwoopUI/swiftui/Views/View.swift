public protocol View {
    func iterate() -> AnyIterator<View>
}

public extension View {
    func iterate() -> AnyIterator<View> {
        return AnyIterator({return nil})
    }

    func singleIterator(_ content: View) -> AnyIterator<View> {
        var index = 0
        return AnyIterator({
            if index == 0 {
                index += 1
                return content
            }
            return nil
        })
    }
}
