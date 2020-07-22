import Foundation

public struct Color : CustomStringConvertible {
    internal var red: Float
    internal var green: Float
    internal var blue: Float
    internal var alpha: Float
    
    internal init(float red: Float, _ green: Float, _ blue: Float, _ alpha: Float) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    internal init(uint8 red: UInt8, _ green: UInt8, _ blue: UInt8, _ alpha: UInt8) {
        self.red = Float(red) / 255.0
        self.green = Float(green) / 255.0
        self.blue = Float(blue) / 255.0
        self.alpha = Float(alpha) / 255.0
    }
    
    internal init(_ value: UInt32) {
        self.red = Float((value >> 24) & 0xFF) / 255.0
        self.green = Float((value >> 16) & 0xFF) / 255.0
        self.blue = Float((value >> 8) & 0xFF) / 255.0
        self.alpha = Float((value >> 0) & 0xFF) / 255.0
    }

    
    public var description: String {
        return "TDB: description of Color"
    }
}

extension Color {
    public static let clear = Color(0x00000000)
    public static let white = Color(0xFFFFFFFF)
    public static let silver = Color(0xC0C0C0FF)
    public static let gray = Color(0x808080FF)
    public static let black = Color(0x000000FF)
    public static let red = Color(0xFF0000FF)
    public static let maroon = Color(0x800000FF)
    public static let yellow = Color(0xFFFF00FF)
    public static let olive = Color(0x808000FF)
    public static let lime = Color(0x00FF00FF)
    public static let green = Color(0x008000FF)
    public static let aqua = Color(0x00FFFFFF)
    public static let teal = Color(0x008080FF)
    public static let blue = Color(0x0000FFFF)
    public static let navy = Color(0x000080FF)
    public static let fuchsia = Color(0xFF00FFFF)
    public static let purple = Color(0x800080FF)
    public static let aliceBlue = Color(0xf0f8ffFF)
    public static let antiqueWhite = Color(0xfaebd7FF)
    public static let aquamarine = Color(0x7fffd4FF)
    public static let azure = Color(0xf0ffffFF)
    public static let beige = Color(0xf5f5dcFF)
    public static let bisque = Color(0xffe4c4FF)
    public static let blanchedAlmond = Color(0xffebcdFF)
    public static let blueViolet = Color(0x8a2be2FF)
    public static let brown = Color(0xa52a2aFF)
    public static let burlywood = Color(0xdeb887FF)
    public static let cadetBlue = Color(0x5f9ea0FF)
    public static let chartreuse = Color(0x7fff00FF)
    public static let chocolate = Color(0xd2691eFF)
    public static let coral = Color(0xff7f50FF)
    public static let cornflowerBlue = Color(0x6495edFF)
    public static let cornsilk = Color(0xfff8dcFF)
    public static let crimson = Color(0xdc143cFF)
    public static let cyan = Color(0x00ffffFF)
    public static let darkBlue = Color(0x00008bFF)
    public static let darkCyan = Color(0x008b8bFF)
    public static let darkGoldenrod = Color(0xb8860bFF)
    public static let darkGray = Color(0xa9a9a9FF)
    public static let darkGreen = Color(0x006400FF)
    public static let darkKhaki = Color(0xbdb76bFF)
    public static let darkMagenta = Color(0x8b008bFF)
    public static let darkOliveGreen = Color(0x556b2fFF)
    public static let darkOrange = Color(0xff8c00FF)
    public static let darkOrchid = Color(0x9932ccFF)
    public static let darkRed = Color(0x8b0000FF)
    public static let darkSalmon = Color(0xe9967aFF)
    public static let darkSeaGreen = Color(0x8fbc8fFF)
    public static let darkSlateBlue = Color(0x483d8bFF)
    public static let darkSlateGray = Color(0x2f4f4fFF)
    public static let darkTurquoise = Color(0x00ced1FF)
    public static let darkViolet = Color(0x9400d3FF)
    public static let deepPink = Color(0xff1493FF)
    public static let deepSkyBlue = Color(0x00bfffFF)
    public static let dimGray = Color(0x696969FF)
    public static let dodgerBlue = Color(0x1e90ffFF)
    public static let firebrick = Color(0xb22222FF)
    public static let floralWhite = Color(0xfffaf0FF)
    public static let forestGreen = Color(0x228b22FF)
    public static let gainsboro = Color(0xdcdcdcFF)
    public static let ghostWhite = Color(0xf8f8ffFF)
    public static let gold = Color(0xffd700FF)
    public static let goldenrod = Color(0xdaa520FF)
    public static let greenYellow = Color(0xadff2fFF)
    public static let honeydew = Color(0xf0fff0FF)
    public static let hotPink = Color(0xff69b4FF)
    public static let indianRed = Color(0xcd5c5cFF)
    public static let indigo = Color(0x4b0082FF)
    public static let ivory = Color(0xfffff0FF)
    public static let khaki = Color(0xf0e68cFF)
    public static let lavender = Color(0xe6e6faFF)
    public static let lavenderBlush = Color(0xfff0f5FF)
    public static let lawnGreen = Color(0x7cfc00FF)
    public static let lemonChiffon = Color(0xfffacdFF)
    public static let lightBlue = Color(0xadd8e6FF)
    public static let lightCoral = Color(0xf08080FF)
    public static let lightCyan = Color(0xe0ffffFF)
    public static let lightGoldenrodYellow = Color(0xfafad2FF)
    public static let lightGray = Color(0xd3d3d3FF)
    public static let lightGreen = Color(0x90ee90FF)
    public static let lightPink = Color(0xffb6c1FF)
    public static let lightSalmon = Color(0xffa07aFF)
    public static let lightSeaGreen = Color(0x20b2aaFF)
    public static let lightSkyBlue = Color(0x87cefaFF)
    public static let lightSlateGray = Color(0x778899FF)
    public static let lightSteelBlue = Color(0xb0c4deFF)
    public static let lightYellow = Color(0xffffe0FF)
    public static let limeGreen = Color(0x32cd32FF)
    public static let linen = Color(0xfaf0e6FF)
    public static let mediumAquamarine = Color(0x66cdaaFF)
    public static let mediumBlue = Color(0x0000cdFF)
    public static let mediumOrchid = Color(0xba55d3FF)
    public static let mediumPurple = Color(0x9370dbFF)
    public static let mediumSeaGreen = Color(0x3cb371FF)
    public static let mediumSlateBlue = Color(0x7b68eeFF)
    public static let mediumSpringGreen = Color(0x00fa9aFF)
    public static let mediumTurquoise = Color(0x48d1ccFF)
    public static let mediumVioletRed = Color(0xc71585FF)
    public static let midnightBlue = Color(0x191970FF)
    public static let mintCream = Color(0xf5fffaFF)
    public static let mistyRose = Color(0xffe4e1FF)
    public static let moccasin = Color(0xffe4b5FF)
    public static let navajoWhite = Color(0xffdeadFF)
    public static let oldLace = Color(0xfdf5e6FF)
    public static let oliveDrab = Color(0x6b8e23FF)
    public static let orange = Color(0xffa500FF)
    public static let orangeRed = Color(0xff4500FF)
    public static let orchid = Color(0xda70d6FF)
    public static let paleGoldenrod = Color(0xeee8aaFF)
    public static let paleGreen = Color(0x98fb98FF)
    public static let paleTurquoise = Color(0xafeeeeFF)
    public static let paleVioletRed = Color(0xdb7093FF)
    public static let papayaWhip = Color(0xffefd5FF)
    public static let peachPuff = Color(0xffdab9FF)
    public static let peru = Color(0xcd853fFF)
    public static let pink = Color(0xffc0cbFF)
    public static let plum = Color(0xdda0ddFF)
    public static let powderBlue = Color(0xb0e0e6FF)
    public static let rebeccaPurple = Color(0x663399FF)
    public static let rosyBrown = Color(0xbc8f8fFF)
    public static let royalBlue = Color(0x4169e1FF)
    public static let saddleBrown = Color(0x8b4513FF)
    public static let salmon = Color(0xfa8072FF)
    public static let sandyBrown = Color(0xf4a460FF)
    public static let seaGreen = Color(0x2e8b57FF)
    public static let seashell = Color(0xfff5eeFF)
    public static let sienna = Color(0xa0522dFF)
    public static let skyBlue = Color(0x87ceebFF)
    public static let slateBlue = Color(0x6a5acdFF)
    public static let slateGray = Color(0x708090FF)
    public static let snow = Color(0xfffafaFF)
    public static let springGreen = Color(0x00ff7fFF)
    public static let steelBlue = Color(0x4682b4FF)
    public static let tan = Color(0xd2b48cFF)
    public static let thistle = Color(0xd8bfd8FF)
    public static let tomato = Color(0xff6347FF)
    public static let turquoise = Color(0x40e0d0FF)
    public static let violet = Color(0xee82eeFF)
    public static let wheat = Color(0xf5deb3FF)
    public static let whiteSmoke = Color(0xf5f5f5FF)
    public static let yellowGreen = Color(0x9acd32FF)
}

extension Color : View {
    
}

