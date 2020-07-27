extension HStack: Nodeable {
    func newNode() -> YogaNode {
        let node = YogaNode()
        node.fill().columns().itemsStart()

        switch alignment {
        case .center: node.justifyCenter()
        case .top: node.justifyStart()
        case .bottom: node.justifyEnd()
        default: fatalError()
        }

        return node
    }
}
