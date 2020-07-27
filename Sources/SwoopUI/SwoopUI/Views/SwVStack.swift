extension VStack: Nodeable {
    func newNode() -> YogaNode {
        let node = YogaNode()
        node.fill().rows().itemsStart()

        switch alignment {
        case .center: node.justifyCenter()
        case .leading: node.justifyStart()
        case .trailing: node.justifyEnd()
        }

        return node
    }
}
