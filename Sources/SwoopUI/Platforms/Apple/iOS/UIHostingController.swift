#if os(iOS)

import Foundation
import UIKit

@available(iOS 13.0, *)
public class UIHostingMetalView: UIView {
    override public class var layerClass: AnyClass { return SwoopMetalLayer.self }

    public init(_ rootView: View) {
        super.init(frame: CGRect.zero)
        if let layer = layer as? SwoopMetalLayer {
            layer.setRootView(rootView: rootView)
        }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class UIHostingView: UIView {
    override public class var layerClass: AnyClass { return SwoopLayer.self }

    public init(_ rootView: View) {
        super.init(frame: CGRect.zero)
        if let layer = layer as? SwoopLayer {
            layer.setRootView(rootView: rootView)
        }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class UIHostingController: UIViewController {
    public init(rootView: View) {
        super.init(nibName: nil, bundle: nil)

        if #available(iOS 13.0, *) {
            view = UIHostingMetalView(rootView)
        } else {
            view = UIHostingView(rootView)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#endif
