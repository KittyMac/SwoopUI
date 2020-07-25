import Foundation

public protocol Shape: Animatable, View {
    func path(in rect: CGRect) -> Path
}

extension Shape {

}

public struct FillStyle: Equatable {
    public var isEOFilled: Bool
    public var isAntialiased: Bool
    public init(eoFill: Bool = false, antialiased: Bool = true) {
        self.isEOFilled = eoFill
        self.isAntialiased = antialiased
    }
}

public struct ForegroundStyle {
    public init() {}
}
