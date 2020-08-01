#if os(macOS)

import Foundation
import Cocoa

class SwoopLayer: CALayer {
    
    let root: YogaNode
    let renderer: BitmapRenderer

    private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    private let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageByteOrderInfo.order32Little.rawValue | CGImageAlphaInfo.noneSkipLast.rawValue)
    
    init(rootView: View) {
        root = YogaNode()
        root.size(100, 100).leftToRight()

        Swoop.loadView(into: root, rootView.body)
        root.layout()

        renderer = BitmapRenderer(root)
        
        super.init()
    }
    
    override init() {
        fatalError()
    }
    
    override init(layer: Any) {
        fatalError()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSublayers() {
        renderer.layout(Int(bounds.width) / 2, Int(bounds.height) / 2)
    }
    
    override func display() {
        root.render(renderer.renderBuffer)
        renderer.swap()
        
        let info = renderer.viewBuffer.info
        if let providerRef = CGDataProvider(dataInfo: nil,
                                            data: info.bytes32,
                                            size: info.rowBytes * info.height,
                                            releaseData: { (_, _, _) in }) {
            
            contents = CGImage(width: info.width,
                               height: info.height,
                               bitsPerComponent: 8,
                               bitsPerPixel: 8 * info.channels,
                               bytesPerRow: info.rowBytes,
                               space: rgbColorSpace,
                               bitmapInfo: bitmapInfo,
                               provider: providerRef,
                               decode: nil,
                               shouldInterpolate: false,
                               intent: .defaultIntent)
            
        }
    }
}

#endif
