import Foundation

private func newNode(from view: View) -> YogaNode {
    if let nodeable = view as? Nodeable {
        return nodeable.newNode()
    }
    return YogaNode()
}

@discardableResult
public func recurseView(_ parent: YogaNode, _ view: View) -> YogaNode {
    let node = newNode(from: view)

    for view in view.iterate() {
        recurseView(node, view)
    }
    parent.child(node)
    return node
}

public func swoopUITest<Content>(_ size: CGSize, _ view: Content) where Content: View {

    let root = YogaNode()
    root.size(Pixel(size.width), Pixel(size.height)).leftToRight()

    recurseView(root, view)

    root.layout()
    root.print()
}
