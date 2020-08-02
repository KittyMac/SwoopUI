import Foundation

public class BitmapHostingView {
    var rootView: View?
    var root: YogaNode = YogaNode()
    lazy var renderer: BitmapRenderer = BitmapRenderer(root)
    
    var needsDisplay = true

    public init(rootView: View) {
        setRootView(rootView: rootView)
    }
    
    public init() {
        
    }
    
    public func setRootView(rootView: View) {
        root.size(100, 100).leftToRight()
        Swoop.loadView(into: root, rootView.body)
        root.layout()
    }
    
    public func layout(_ width: Int, _ height: Int) {
        renderer.layout(width, height)
        needsDisplay = true
    }
    
    public func setNeedsDisplay() {
        needsDisplay = true
    }
    
    public func display() -> Bool {
        if needsDisplay {
            needsDisplay = false
            root.render(renderer.renderBuffer)
            renderer.swap()
            return true
        }
        return false
    }
    
    public var bitmapInfo: Bitmap.BitmapInfo {
        return renderer.viewBuffer.info
    }
    
}
