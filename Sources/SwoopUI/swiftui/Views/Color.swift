// swiftlint:disable identifier_name
// swiftlint:disable large_tuple
// swiftlint:disable file_length

import Foundation

#if arch(x86_64)
let BYTE_RED = 24
let BYTE_GREEN = 16
let BYTE_BLUE = 8
let BYTE_ALPHA = 0
#else
let BYTE_RED = 24
let BYTE_GREEN = 16
let BYTE_BLUE = 8
let BYTE_ALPHA = 0
#endif

public class AnyColorBox {
    var rgba: UInt32 = 0
}

extension AnyColorBox: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self).hashValue)
    }
}

extension AnyColorBox: Equatable {
    public static func == (lhs: AnyColorBox, rhs: AnyColorBox) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

public class SystemColorType: AnyColorBox {
    public enum SystemColor: String {
        case clear
        case black
        case white
        case gray
        case red
        case green
        case blue
        case orange
        case yellow
        case pink
        case purple
        case primary
        case secondary
        case accentColor
    }

    public let value: SystemColor

    internal init(value: SystemColorType.SystemColor) {
        self.value = value
    }

    public var description: String {
        return value.rawValue
    }
}

public class DisplayP3: AnyColorBox {
    public let red: Double
    public let green: Double
    public let blue: Double
    public let opacity: Double

    internal init(red: Double, green: Double, blue: Double, opacity: Double) {
        self.red = red
        self.green = green
        self.blue = blue
        self.opacity = opacity

        super.init()
        let r = (UInt32(red * 255) & 0xFF) << 24
        let g = (UInt32(green * 255) & 0xFF) << 16
        let b = (UInt32(blue * 255) & 0xFF) << 8
        let a = (UInt32(opacity * 255) & 0xFF) << 0
        rgba = r | g | b | a
    }
}

extension Double {
    fileprivate var hexString: String {
        return String(format: "%02X", Int((self * 255).rounded()))
    }
}

public class ResolvedColor: AnyColorBox {
    public let linearRed: Double
    public let linearGreen: Double
    public let linearBlue: Double
    public let opacity: Double

    internal init(linearRed: Double, linearGreen: Double, linearBlue: Double, opacity: Double) {
        self.linearRed = linearRed
        self.linearGreen = linearGreen
        self.linearBlue = linearBlue
        self.opacity = opacity

        super.init()
        let r = (UInt32(linearRed * 255) & 0xFF) << 24
        let g = (UInt32(linearGreen * 255) & 0xFF) << 16
        let b = (UInt32(linearBlue * 255) & 0xFF) << 8
        let a = (UInt32(opacity * 255) & 0xFF) << 0
        rgba = r | g | b | a
    }

    public var description: String {
        return "#\(linearRed.hexString)\(linearGreen.hexString)\(linearBlue.hexString)\(opacity.hexString)"
    }
}

public struct Color: View, Hashable, CustomStringConvertible {
    public let provider: AnyColorBox
    public let rgba32: UInt32

    public enum RGBColorSpace: Equatable {
        case sRGB
        case sRGBLinear
        case displayP3
    }

    public init(_ colorSpace: Color.RGBColorSpace = .sRGB,
                rgba32: UInt32) {
        let red = Double((rgba32 >> BYTE_RED) & 0xFF) / 255.0
        let green = Double((rgba32 >> BYTE_GREEN) & 0xFF) / 255.0
        let blue = Double((rgba32 >> BYTE_BLUE) & 0xFF) / 255.0
        let opacity = Double((rgba32 >> BYTE_ALPHA) & 0xFF) / 255.0

        print(red, green, blue, opacity)

        switch colorSpace {
        case .sRGB:
            self.provider = ResolvedColor(linearRed: red, linearGreen: green, linearBlue: blue, opacity: opacity)
        case .sRGBLinear:
            self.provider = ResolvedColor(linearRed: red, linearGreen: green, linearBlue: blue, opacity: opacity)
        case .displayP3:
            self.provider = DisplayP3(red: red, green: green, blue: blue, opacity: opacity)
        }

        self.rgba32 = rgba32
    }

    public init(_ colorSpace: Color.RGBColorSpace = .sRGB,
                red: Double,
                green: Double,
                blue: Double,
                opacity: Double = 1) {
        switch colorSpace {
        case .sRGB:
            self.provider = ResolvedColor(linearRed: red, linearGreen: green, linearBlue: blue, opacity: opacity)
        case .sRGBLinear:
            self.provider = ResolvedColor(linearRed: red, linearGreen: green, linearBlue: blue, opacity: opacity)
        case .displayP3:
            self.provider = DisplayP3(red: red, green: green, blue: blue, opacity: opacity)
        }

        rgba32 = provider.rgba
    }

    public init(_ colorSpace: Color.RGBColorSpace = .sRGB, white: Double, opacity: Double = 1) {
        switch colorSpace {
        case .sRGB:
            self.provider = ResolvedColor(linearRed: white, linearGreen: white, linearBlue: white, opacity: opacity)
        case .sRGBLinear:
            self.provider = ResolvedColor(linearRed: white, linearGreen: white, linearBlue: white, opacity: opacity)
        case .displayP3:
            self.provider = DisplayP3(red: white, green: white, blue: white, opacity: opacity)
        }

        rgba32 = provider.rgba
    }

    public init(hue: Double, saturation: Double, brightness: Double, opacity: Double = 1) {
        let rgb = Color.hsbToRGB(hue: hue, saturation: saturation, brightness: brightness)
        self.provider = ResolvedColor(linearRed: rgb.red,
                                      linearGreen: rgb.green,
                                      linearBlue: rgb.blue,
                                      opacity: opacity)

        rgba32 = provider.rgba
    }

    fileprivate init(_ systemColor: SystemColorType.SystemColor) {
        self.provider = SystemColorType(value: systemColor)

        rgba32 = provider.rgba
    }

    public var description: String {
        return "\(provider)"
    }
}

extension Color {
    public static let primary: Color = Color(rgba32: 0x000000FF)
    public static let secondary: Color = Color(rgba32: 0x000000FF)
    public static let accentColor: Color = Color(rgba32: 0x000000FF)

    public static let clear = Color(rgba32: 0x00000000)
    public static let white = Color(rgba32: 0xFFFFFFFF)
    public static let silver = Color(rgba32: 0xC0C0C0FF)
    public static let gray = Color(rgba32: 0x8E8E93FF)
    public static let black = Color(rgba32: 0x000000FF)
    public static let red = Color(rgba32: 0xED5138FF)
    public static let maroon = Color(rgba32: 0x800000FF)
    public static let yellow = Color(rgba32: 0xf6ce34FF)
    public static let olive = Color(rgba32: 0x808000FF)
    public static let lime = Color(rgba32: 0x00FF00FF)
    public static let green = Color(rgba32: 0x5ac94eFF)
    public static let aqua = Color(rgba32: 0x00FFFFFF)
    public static let teal = Color(rgba32: 0x008080FF)
    public static let blue = Color(rgba32: 0x3f78faFF)
    public static let navy = Color(rgba32: 0x000080FF)
    public static let fuchsia = Color(rgba32: 0xFF00FFFF)
    public static let purple = Color(rgba32: 0xa858daFF)
    public static let aliceBlue = Color(rgba32: 0xf0f8ffFF)
    public static let antiqueWhite = Color(rgba32: 0xfaebd7FF)
    public static let aquamarine = Color(rgba32: 0x7fffd4FF)
    public static let azure = Color(rgba32: 0xf0ffffFF)
    public static let beige = Color(rgba32: 0xf5f5dcFF)
    public static let bisque = Color(rgba32: 0xffe4c4FF)
    public static let blanchedAlmond = Color(rgba32: 0xffebcdFF)
    public static let blueViolet = Color(rgba32: 0x8a2be2FF)
    public static let brown = Color(rgba32: 0xa52a2aFF)
    public static let burlywood = Color(rgba32: 0xdeb887FF)
    public static let cadetBlue = Color(rgba32: 0x5f9ea0FF)
    public static let chartreuse = Color(rgba32: 0x7fff00FF)
    public static let chocolate = Color(rgba32: 0xd2691eFF)
    public static let coral = Color(rgba32: 0xff7f50FF)
    public static let cornflowerBlue = Color(rgba32: 0x6495edFF)
    public static let cornsilk = Color(rgba32: 0xfff8dcFF)
    public static let crimson = Color(rgba32: 0xdc143cFF)
    public static let cyan = Color(rgba32: 0x00ffffFF)
    public static let darkBlue = Color(rgba32: 0x00008bFF)
    public static let darkCyan = Color(rgba32: 0x008b8bFF)
    public static let darkGoldenrod = Color(rgba32: 0xb8860bFF)
    public static let darkGray = Color(rgba32: 0xa9a9a9FF)
    public static let darkGreen = Color(rgba32: 0x006400FF)
    public static let darkKhaki = Color(rgba32: 0xbdb76bFF)
    public static let darkMagenta = Color(rgba32: 0x8b008bFF)
    public static let darkOliveGreen = Color(rgba32: 0x556b2fFF)
    public static let darkOrange = Color(rgba32: 0xff8c00FF)
    public static let darkOrchid = Color(rgba32: 0x9932ccFF)
    public static let darkRed = Color(rgba32: 0x8b0000FF)
    public static let darkSalmon = Color(rgba32: 0xe9967aFF)
    public static let darkSeaGreen = Color(rgba32: 0x8fbc8fFF)
    public static let darkSlateBlue = Color(rgba32: 0x483d8bFF)
    public static let darkSlateGray = Color(rgba32: 0x2f4f4fFF)
    public static let darkTurquoise = Color(rgba32: 0x00ced1FF)
    public static let darkViolet = Color(rgba32: 0x9400d3FF)
    public static let deepPink = Color(rgba32: 0xff1493FF)
    public static let deepSkyBlue = Color(rgba32: 0x00bfffFF)
    public static let dimGray = Color(rgba32: 0x696969FF)
    public static let dodgerBlue = Color(rgba32: 0x1e90ffFF)
    public static let firebrick = Color(rgba32: 0xb22222FF)
    public static let floralWhite = Color(rgba32: 0xfffaf0FF)
    public static let forestGreen = Color(rgba32: 0x228b22FF)
    public static let gainsboro = Color(rgba32: 0xdcdcdcFF)
    public static let ghostWhite = Color(rgba32: 0xf8f8ffFF)
    public static let gold = Color(rgba32: 0xffd700FF)
    public static let goldenrod = Color(rgba32: 0xdaa520FF)
    public static let greenYellow = Color(rgba32: 0xadff2fFF)
    public static let honeydew = Color(rgba32: 0xf0fff0FF)
    public static let hotPink = Color(rgba32: 0xff69b4FF)
    public static let indianRed = Color(rgba32: 0xcd5c5cFF)
    public static let indigo = Color(rgba32: 0x4b0082FF)
    public static let ivory = Color(rgba32: 0xfffff0FF)
    public static let khaki = Color(rgba32: 0xf0e68cFF)
    public static let lavender = Color(rgba32: 0xe6e6faFF)
    public static let lavenderBlush = Color(rgba32: 0xfff0f5FF)
    public static let lawnGreen = Color(rgba32: 0x7cfc00FF)
    public static let lemonChiffon = Color(rgba32: 0xfffacdFF)
    public static let lightBlue = Color(rgba32: 0xadd8e6FF)
    public static let lightCoral = Color(rgba32: 0xf08080FF)
    public static let lightCyan = Color(rgba32: 0xe0ffffFF)
    public static let lightGoldenrodYellow = Color(rgba32: 0xfafad2FF)
    public static let lightGray = Color(rgba32: 0xd3d3d3FF)
    public static let lightGreen = Color(rgba32: 0x90ee90FF)
    public static let lightPink = Color(rgba32: 0xffb6c1FF)
    public static let lightSalmon = Color(rgba32: 0xffa07aFF)
    public static let lightSeaGreen = Color(rgba32: 0x20b2aaFF)
    public static let lightSkyBlue = Color(rgba32: 0x87cefaFF)
    public static let lightSlateGray = Color(rgba32: 0x778899FF)
    public static let lightSteelBlue = Color(rgba32: 0xb0c4deFF)
    public static let lightYellow = Color(rgba32: 0xffffe0FF)
    public static let limeGreen = Color(rgba32: 0x32cd32FF)
    public static let linen = Color(rgba32: 0xfaf0e6FF)
    public static let mediumAquamarine = Color(rgba32: 0x66cdaaFF)
    public static let mediumBlue = Color(rgba32: 0x0000cdFF)
    public static let mediumOrchid = Color(rgba32: 0xba55d3FF)
    public static let mediumPurple = Color(rgba32: 0x9370dbFF)
    public static let mediumSeaGreen = Color(rgba32: 0x3cb371FF)
    public static let mediumSlateBlue = Color(rgba32: 0x7b68eeFF)
    public static let mediumSpringGreen = Color(rgba32: 0x00fa9aFF)
    public static let mediumTurquoise = Color(rgba32: 0x48d1ccFF)
    public static let mediumVioletRed = Color(rgba32: 0xc71585FF)
    public static let midnightBlue = Color(rgba32: 0x191970FF)
    public static let mintCream = Color(rgba32: 0xf5fffaFF)
    public static let mistyRose = Color(rgba32: 0xffe4e1FF)
    public static let moccasin = Color(rgba32: 0xffe4b5FF)
    public static let navajoWhite = Color(rgba32: 0xffdeadFF)
    public static let oldLace = Color(rgba32: 0xfdf5e6FF)
    public static let oliveDrab = Color(rgba32: 0x6b8e23FF)
    public static let orange = Color(rgba32: 0xf19b29FF)
    public static let orangeRed = Color(rgba32: 0xff4500FF)
    public static let orchid = Color(rgba32: 0xda70d6FF)
    public static let paleGoldenrod = Color(rgba32: 0xeee8aaFF)
    public static let paleGreen = Color(rgba32: 0x98fb98FF)
    public static let paleTurquoise = Color(rgba32: 0xafeeeeFF)
    public static let paleVioletRed = Color(rgba32: 0xdb7093FF)
    public static let papayaWhip = Color(rgba32: 0xffefd5FF)
    public static let peachPuff = Color(rgba32: 0xffdab9FF)
    public static let peru = Color(rgba32: 0xcd853fFF)
    public static let pink = Color(rgba32: 0xed4958FF)
    public static let plum = Color(rgba32: 0xdda0ddFF)
    public static let powderBlue = Color(rgba32: 0xb0e0e6FF)
    public static let rebeccaPurple = Color(rgba32: 0x663399FF)
    public static let rosyBrown = Color(rgba32: 0xbc8f8fFF)
    public static let royalBlue = Color(rgba32: 0x4169e1FF)
    public static let saddleBrown = Color(rgba32: 0x8b4513FF)
    public static let salmon = Color(rgba32: 0xfa8072FF)
    public static let sandyBrown = Color(rgba32: 0xf4a460FF)
    public static let seaGreen = Color(rgba32: 0x2e8b57FF)
    public static let seashell = Color(rgba32: 0xfff5eeFF)
    public static let sienna = Color(rgba32: 0xa0522dFF)
    public static let skyBlue = Color(rgba32: 0x87ceebFF)
    public static let slateBlue = Color(rgba32: 0x6a5acdFF)
    public static let slateGray = Color(rgba32: 0x708090FF)
    public static let snow = Color(rgba32: 0xfffafaFF)
    public static let springGreen = Color(rgba32: 0x00ff7fFF)
    public static let steelBlue = Color(rgba32: 0x4682b4FF)
    public static let tan = Color(rgba32: 0xd2b48cFF)
    public static let thistle = Color(rgba32: 0xd8bfd8FF)
    public static let tomato = Color(rgba32: 0xff6347FF)
    public static let turquoise = Color(rgba32: 0x40e0d0FF)
    public static let violet = Color(rgba32: 0xee82eeFF)
    public static let wheat = Color(rgba32: 0xf5deb3FF)
    public static let whiteSmoke = Color(rgba32: 0xf5f5f5FF)
    public static let yellowGreen = Color(rgba32: 0x9acd32FF)
}

// TODO: TBD
/*
extension View {
    public func foregroundColor(_ color: Color?) -> some View {
        return environment(\.foregroundColor, color)
    }
}
 */

enum ForegroundColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color? { return nil }
}

extension EnvironmentValues {
    public var foregroundColor: Color? {
        set { self[ForegroundColorEnvironmentKey.self] = newValue }
        get { self[ForegroundColorEnvironmentKey.self] }
    }
}

extension Color {
    internal static func hsbToRGB(hue: Double,
                                  saturation: Double,
                                  brightness: Double) -> (red: Double, green: Double, blue: Double) {
        // Based on:
        // http://mjijackson.com/2008/02/rgb-to-hsl-and-rgb-to-hsv-color-model-conversion-algorithms-in-javascript

        var red: Double = 0
        var green: Double = 0
        var blue: Double = 0

        let i = floor(hue * 6)
        let f = hue * 6 - i
        let p = brightness * (1 - saturation)
        let q = brightness * (1 - f * saturation)
        let t = brightness * (1 - (1 - f) * saturation)

        switch i.truncatingRemainder(dividingBy: 6) {
        case 0:
            red = brightness
            green = t
            blue = p
        case 1:
            red = q
            green = brightness
            blue = p
        case 2:
            red = p
            green = brightness
            blue = t
        case 3:
            red = p
            green = q
            blue = brightness
        case 4:
            red = t
            green = p
            blue = brightness
        case 5:
            red = brightness
            green = p
            blue = q
        default:
            break
        }

        return (red, green, blue)
    }
}

public enum ColorScheme: CaseIterable {
    case light
    case dark
}

// TODO: TBD
/*
extension View {
    public func colorScheme(_ colorScheme: ColorScheme) -> some View {
        return environment(\.colorScheme, colorScheme)
    }
}
 */

enum ColorSchemeEnvironmentKey: EnvironmentKey {
    static var defaultValue: ColorScheme { return ColorScheme.dark }
}

extension EnvironmentValues {
    public var colorScheme: ColorScheme {
        set { self[ColorSchemeEnvironmentKey.self] = newValue }
        get { self[ColorSchemeEnvironmentKey.self] }
    }
}
