// swiftlint:disable identifier_name

public struct Rect {
    public var x: Int
    public var y: Int
    public var width: Int
    public var height: Int

    public static let zero = Rect(x: 0, y: 0, width: 0, height: 0)
}

extension Rect: Equatable {
}
