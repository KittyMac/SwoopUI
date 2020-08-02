import Foundation
import Flynn

public class BitmapRenderer {

    private var width: Int = 0
    private var height: Int = 0

    private var frontBuffer: Bitmap
    private var backBuffer: Bitmap

    private var root: YogaNode

    public var renderBuffer: Bitmap {
        return backBuffer
    }

    public var viewBuffer: Bitmap {
        return frontBuffer
    }

    init(_ root: YogaNode) {
        self.root = root
        
        if root.getWidth().isNaN {
            width = 10
            height = 10

            frontBuffer = Bitmap(10, 10)
            backBuffer = Bitmap(10, 10)
        } else {
            width = Int(root.getWidth())
            height = Int(root.getHeight())

            frontBuffer = Bitmap(width, height)
            backBuffer = Bitmap(width, height)
        }
    }

    func swap() {
        let temp = self.frontBuffer
        self.frontBuffer = self.backBuffer
        self.backBuffer = temp
    }

    func layout(_ newWidth: Int, _ newHeight: Int) {
        if width != newWidth || height != newHeight {
            width = newWidth
            height = newHeight
            root.size(Pixel(width), Pixel(height))
            frontBuffer.resize(width, height)
            backBuffer.resize(width, height)
        }
        root.layout()
    }

    /*
    lazy var beSwap = Behavior(self) { [unowned self] (_: BehaviorArgs) in
        let temp = self.frontBuffer
        self.frontBuffer = self.backBuffer
        self.backBuffer = temp
    }

    lazy var beRender = Behavior(self) { [unowned self] (_: BehaviorArgs) in
        self.root.print()
    }*/

}
