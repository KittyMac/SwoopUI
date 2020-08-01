#if os(macOS)

import Foundation
import Cocoa

public class NSHostingView: NSView {
    let rootView: View?
    
    public override func makeBackingLayer() -> CALayer {
        if let rootView = rootView {
            return SwoopLayer(rootView: rootView)
        }
        return CALayer()
    }

    public init<T: View>(rootView: T) {
        self.rootView = rootView
        super.init(frame: CGRect.zero)
        self.wantsLayer = true
        self.layerContentsRedrawPolicy = .duringViewResize
        self.layerContentsPlacement = .topLeft
    }

    required init?(coder aDecoder: NSCoder) {
        self.rootView = nil
        super.init(coder: aDecoder)
    }
}

#endif
