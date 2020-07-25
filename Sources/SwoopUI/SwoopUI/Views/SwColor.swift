import Flynn

class SwColor: Actor, Viewable {

    lazy var beRender = Behavior(self) { [unowned self] (args: BehaviorArgs) in
        // flynnlint:parameter String - string to print
        let value: String = args[x:0]
        print(value)
    }

    private var color: Color

    init(_ color: Color) {
        self.color = color
        super.init()
        safeViewableInit()
    }
}
