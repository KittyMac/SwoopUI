import Flynn

internal protocol Nodeable {
    func newNode() -> YogaNode
}

internal protocol Viewable {
    func render(_ bitmap: Bitmap, _ bounds: Rect)
}

/*
internal protocol Viewable: Actor {
    var beRender: Behavior { get }
}

internal extension Viewable {
    func safeViewableInit() {
        unsafeCoreAffinity = .onlyEfficiency
    }
}
*/
