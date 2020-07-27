import Flynn

internal protocol Nodeable: View {
    func newNode() -> YogaNode
}

internal protocol Viewable: Actor {
    var beRender: Behavior { get }
}

internal extension Viewable {
    func safeViewableInit() {
        unsafeCoreAffinity = .onlyEfficiency
    }
}
