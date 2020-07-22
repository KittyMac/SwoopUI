import Foundation

public struct HStack<Content> : View where Content : View {
    @inlinable public init(@ViewBuilder content: () -> Content) {
        
    }
}
