import Foundation

public struct Image: Equatable {
    public var provider: AnyImageProviderBox
    public static func == (lhs: Image, rhs: Image) -> Bool {
        return ObjectIdentifier(lhs.provider) == ObjectIdentifier(rhs.provider)
    }

    public init(provider: AnyImageProviderBox) {
        self.provider = provider
    }
}

extension Image {

}

open class AnyImageProviderBox {
    public init() {
    }
}

extension Image {
    public init(_ name: String, bundle: Foundation.Bundle? = nil) {
        fatalError()
    }
    public init(_ name: String, bundle: Foundation.Bundle? = nil, label: Text) {
        fatalError()
    }
    public init(decorative name: String, bundle: Foundation.Bundle? = nil) {
        fatalError()
    }
    public init(systemName: String) {
        fatalError()
    }
}
