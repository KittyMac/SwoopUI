import Flynn

public protocol Viewable: Actor {
    var beRender: Behavior { get }
}

public extension Viewable {
    func safeViewableInit() {
        unsafeCoreAffinity = .onlyEfficiency
    }
}
