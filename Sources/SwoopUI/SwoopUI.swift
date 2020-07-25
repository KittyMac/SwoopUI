import Foundation

@discardableResult
public func recurseView(_ parent: YogaNode, _ view: View) -> YogaNode {
    let node = view.node()
    for view in view.iterate() {
        recurseView(node, view)
    }
    parent.child(node)
    return node
}

public func SwoopUITest<Content>(_ size: CGSize, _ view: Content) where Content: View {
    
    let root = YogaNode()
    root.size(Pixel(size.width), Pixel(size.height))
    
    recurseView(root, view)
    
    root.layout()
    root.print()
}
