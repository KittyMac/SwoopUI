#if os(macOS)

import Foundation
import Cocoa

public class NSHostingView: NSView {
    let rootView: View?

    public override func makeBackingLayer() -> CALayer {
        if let rootView = rootView {
            if #available(OSX 10.11, *) {
                return SwoopMetalLayer(rootView: rootView)
            } else {
                return SwoopLayer(rootView: rootView)
            }
        }
        return CALayer()
    }

    public init<T: View>(rootView: T) {
        self.rootView = rootView
        super.init(frame: CGRect.zero)
        self.wantsLayer = true
        self.layerContentsRedrawPolicy = .duringViewResize
        self.layerContentsPlacement = .scaleAxesIndependently
    }

    required init?(coder aDecoder: NSCoder) {
        self.rootView = nil
        super.init(coder: aDecoder)
    }
}

#endif
