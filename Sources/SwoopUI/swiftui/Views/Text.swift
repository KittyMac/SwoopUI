import Foundation
#if canImport(CoreGraphics)
import CoreGraphics
#endif

public class AnyTextStorage<Storage: StringProtocol> {
    public var storage: Storage

    internal init(storage: Storage) {
        self.storage = storage
    }
}

public class AnyTextModifier {
    init() {
    }
}

public struct Text: View, Equatable {
    public typealias Body = Never
    public var storage: Storage
    public var modifiers: [Text.Modifier] = [Modifier]()

    public enum Storage: Equatable {
        public static func == (lhs: Text.Storage, rhs: Text.Storage) -> Bool {
            switch (lhs, rhs) {
            case (.verbatim(let contentA), .verbatim(let contentB)):
                return contentA == contentB
            case (.anyTextStorage(let contentA), .anyTextStorage(let contentB)):
                return contentA.storage == contentB.storage
            default:
                return false
            }
        }

        case verbatim(String)
        case anyTextStorage(AnyTextStorage<String>)
    }

    public enum Modifier: Equatable {
        case color(Color?)
        case font(Font?)
        // case italic
        // case weight(Font.Weight?)
        // case kerning(CGFloat)
        // case tracking(CGFloat)
        // case baseline(CGFloat)
        // case rounded
        // case anyTextModifier(AnyTextModifier)
        public static func == (lhs: Text.Modifier, rhs: Text.Modifier) -> Bool {
            switch (lhs, rhs) {
            case (.color(let colorA), .color(let colorB)):
                return colorA == colorB
            case (.font(let fontA), .font(let fontB)):
                return fontA == fontB
            default:
                return false
            }
        }
    }

    public init(verbatim content: String) {
        self.storage = .verbatim(content)
    }

    public init<S>(_ content: S) where S: StringProtocol {
        self.storage = .anyTextStorage(AnyTextStorage<String>(storage: String(content)))
    }

    public init(_ key: LocalizedStringKey,
                tableName: String? = nil,
                bundle: Bundle? = nil,
                comment: StaticString? = nil) {
        self.storage = .anyTextStorage(AnyTextStorage<String>(storage: key.key))
    }

    private init(verbatim content: String, modifiers: [Modifier] = []) {
        self.storage = .verbatim(content)
        self.modifiers = modifiers
    }

    public static func == (lhs: Text, rhs: Text) -> Bool {
        return lhs.storage == rhs.storage && lhs.modifiers == rhs.modifiers
    }
}

extension Text {
    public func foregroundColor(_ color: Color?) -> Text {
        textWithModifier(Text.Modifier.color(color))
    }

    public func font(_ font: Font?) -> Text {
        textWithModifier(Text.Modifier.font(font))
    }

    private func textWithModifier(_ modifier: Modifier) -> Text {
        let modifiers = self.modifiers + [modifier]
        switch storage {
        case .verbatim(let content):
            return Text(verbatim: content, modifiers: modifiers)
        case .anyTextStorage(let content):
            return Text(verbatim: content.storage, modifiers: modifiers)
        }
    }
}

extension Text {

}
