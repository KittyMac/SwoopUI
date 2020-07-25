import Foundation

public extension HStack {
    func node() -> YogaNode {
        let node = YogaNode()
        node.name("HStack")
        return node
    }
}
