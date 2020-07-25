import Foundation

public struct Alignment {
    public var horizontal: HorizontalAlignment
    public var vertical: VerticalAlignment

    public init(horizontal: HorizontalAlignment, vertical: VerticalAlignment) {
        self.horizontal = horizontal
        self.vertical = vertical
    }

    public static var center: Alignment {
        return Alignment(horizontal: HorizontalAlignment.center, vertical: VerticalAlignment.center)
    }

    public static var leading: Alignment {
        return Alignment(horizontal: HorizontalAlignment.leading, vertical: VerticalAlignment.center)
    }

    public static var trailing: Alignment {
        return Alignment(horizontal: HorizontalAlignment.trailing, vertical: VerticalAlignment.center)
    }

    public static var top: Alignment {
        return Alignment(horizontal: HorizontalAlignment.center, vertical: VerticalAlignment.top)
    }

    public static var bottom: Alignment {
        return Alignment(horizontal: HorizontalAlignment.center, vertical: VerticalAlignment.bottom)
    }

    public static var topLeading: Alignment {
        return Alignment(horizontal: HorizontalAlignment.leading, vertical: VerticalAlignment.top)
    }

    public static var topTrailing: Alignment {
        return Alignment(horizontal: HorizontalAlignment.trailing, vertical: VerticalAlignment.top)
    }

    public static var bottomLeading: Alignment {
        return Alignment(horizontal: HorizontalAlignment.leading, vertical: VerticalAlignment.bottom)
    }

    public static var bottomTrailing: Alignment {
        return Alignment(horizontal: HorizontalAlignment.trailing, vertical: VerticalAlignment.bottom)
    }
}

public protocol AlignmentID {
    static func defaultValue(in context: ViewDimensions) -> CGFloat
}

struct AlignmentKey: Hashable, Comparable {
    private let bits: UInt
    internal static func < (lhs: AlignmentKey, rhs: AlignmentKey) -> Bool {
        return lhs.bits < rhs.bits
    }
}

public enum HorizontalAlignment {
    case leading
    case center
    case trailing
}

public enum VerticalAlignment {
    case top
    case center
    case bottom
    case firstTextBaseline
    case lastTextBaseline
}
