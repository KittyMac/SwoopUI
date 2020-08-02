#if os(macOS) || os(iOS)

import Foundation

#if os(macOS)
import Cocoa
#else
import UIKit
#endif

class SwoopLayer: CALayer {

    var root: YogaNode = YogaNode()
    lazy var renderer: BitmapRenderer = BitmapRenderer(root)

    private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    private let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageByteOrderInfo.order32Little.rawValue | CGImageAlphaInfo.noneSkipLast.rawValue)

    init(rootView: View) {
        super.init()
        setRootView(rootView: rootView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setRootView(rootView: View) {
        root.size(100, 100).leftToRight()
        Swoop.loadView(into: root, rootView.body)
        root.layout()
    }

    override func layoutSublayers() {
        renderer.layout(Int(bounds.width) / 2, Int(bounds.height) / 2)

        setNeedsDisplay()
    }

    override func display() {
        root.render(renderer.renderBuffer)
        renderer.swap()

        let info = renderer.viewBuffer.info
        if let providerRef = CGDataProvider(dataInfo: nil,
                                            data: info.bytes32,
                                            size: info.bytesPerRow * info.height,
                                            releaseData: { (_, _, _) in }) {

            contents = CGImage(width: info.width,
                               height: info.height,
                               bitsPerComponent: 8,
                               bitsPerPixel: 8 * info.channels,
                               bytesPerRow: info.bytesPerRow,
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
