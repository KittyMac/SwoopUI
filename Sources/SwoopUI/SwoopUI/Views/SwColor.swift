import Flynn

extension Color: Nodeable {
    public func newNode() -> YogaNode {
        let node = YogaNode()
        node.fill().grow().shrink()
            .view(SwColor(self))
        return node
    }
}

class SwColor: Viewable {
    private var color: Color

    init(_ color: Color) {
        self.color = color
    }

    func render(_ bitmap: Bitmap, _ bounds: Rect) {
        bitmap.fill(color, bounds)
    }
}

/*
class SwColor: Actor, Viewable {
    private var color: Color

    init(_ color: Color) {
        self.color = color
        super.init()
        safeViewableInit()
    }

    lazy var beRender = Behavior(self) { [unowned self] (args: BehaviorArgs) in
        // flynnlint:parameter String - string to print
        let value: String = args[x:0]
        print(value)
    }

}
*/
