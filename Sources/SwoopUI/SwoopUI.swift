import Foundation

private func newNode(from view: View) -> YogaNode? {
    if let nodeable = view as? Nodeable {
        return nodeable.newNode()
    }
    return nil
}

@discardableResult
public func recurseView(_ parent: YogaNode, _ view: View) -> YogaNode {

    // Not all SwiftUI structs result in a view in the hierarchy. If this
    // is one which doesn't then we still need to process the children
    if let node = newNode(from: view) {
        for view in view.iterate() {
            recurseView(node, view)
        }
        parent.child(node)
        return node
    }

    for view in view.iterate() {
        recurseView(parent, view)
    }

    return parent
}

public func swoopUITest<Content>(_ size: Size, _ view: Content) where Content: View {

    let root = YogaNode()
    root.size(Pixel(size.width), Pixel(size.height)).leftToRight()

    recurseView(root, view)

    root.layout()

    root.print()

    let renderer = BitmapRenderer(root)
    root.render(renderer.buffer)
    print(renderer.buffer.ascii())

    let raw = renderer.buffer.raw()
    try? raw.write(to: URL(fileURLWithPath: "/tmp/bitmap_\(size.width)_\(size.height)_4.raw"))

}
