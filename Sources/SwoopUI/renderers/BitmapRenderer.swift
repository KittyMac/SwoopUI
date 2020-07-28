import Foundation
import Flynn

public class BitmapRenderer: Actor {

    private var width: Int = 0
    private var height: Int = 0

    private var frontBuffer: Bitmap
    private var backBuffer: Bitmap

    private var root: YogaNode

    init(_ root: YogaNode) {
        self.root = root

        width = Int(root.getWidth())
        height = Int(root.getHeight())

        frontBuffer = Bitmap(width, height)
        backBuffer = Bitmap(width, height)
    }

    lazy var beSwap = Behavior(self) { [unowned self] (_: BehaviorArgs) in
        let temp = self.frontBuffer
        self.frontBuffer = self.backBuffer
        self.backBuffer = temp
    }

    lazy var beRender = Behavior(self) { [unowned self] (_: BehaviorArgs) in
        self.root.print()
    }

}
