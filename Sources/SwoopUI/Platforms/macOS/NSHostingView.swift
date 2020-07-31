#if os(macOS)

import Foundation
import Cocoa

public class NSHostingView: NSView {

    let root: YogaNode
    let renderer: BitmapRenderer

    private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    private let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageByteOrderInfo.order32Little.rawValue | CGImageAlphaInfo.noneSkipLast.rawValue)

    public init<T: View>(rootView: T) {

        root = YogaNode()
        root.size(100, 100).leftToRight()

        Swoop.loadView(into: root, rootView.body)
        root.layout()

        renderer = BitmapRenderer(root)

        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        root = YogaNode()
        renderer = BitmapRenderer(root)
        super.init(coder: aDecoder)
    }

    override public func layout() {
        super.layout()
        renderer.layout(Int(frame.width), Int(frame.height))

        render()
    }

    private func render() {
        root.render(renderer.renderBuffer)
        renderer.swap()

        let info = renderer.viewBuffer.info

        if let providerRef = CGDataProvider(dataInfo: nil, data: info.bytes, size: info.rowBytes * info.height, releaseData: { (_, _, _) in }) {
            self.layer?.contents = CGImage(width: info.width,
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
