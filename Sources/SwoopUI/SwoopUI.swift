import Foundation

struct Swoop {
    static private func newNode(from view: View) -> YogaNode? {
        if let nodeable = view as? Nodeable {
            return nodeable.newNode()
        }
        return nil
    }

    @discardableResult
    static public func loadView(into parent: YogaNode, _ view: View) -> YogaNode {

        // Not all SwiftUI structs result in a view in the hierarchy. If this
        // is one which doesn't then we still need to process the children
        if let node = newNode(from: view) {
            for view in view.iterate() {
                loadView(into: node, view)
            }
            parent.child(node)
            return node
        }

        for view in view.iterate() {
            loadView(into: parent, view)
        }

        return parent
    }

}

public func swoopUITest(_ size: Size, _ view: View) {

    let root = YogaNode()
    root.size(Pixel(size.width), Pixel(size.height)).leftToRight()

    Swoop.loadView(into: root, view)

    root.layout()

    root.print()

    let renderer = BitmapRenderer(root)
    root.render(renderer.renderBuffer)
    print(renderer.renderBuffer.ascii())

    let raw = renderer.renderBuffer.rawRGBA()
    try? raw.write(to: URL(fileURLWithPath: "/tmp/bitmap_\(size.width)_\(size.height)_4.raw"))

}
