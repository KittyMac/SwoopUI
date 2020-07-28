import Foundation
import Flynn

public class BitmapRenderer: Actor {

    private var root: YogaNode

    init(_ root: YogaNode) {
        self.root = root
    }

    lazy var beRender = Behavior(self) { [unowned self] (_: BehaviorArgs) in
        self.root.print()
    }

}
