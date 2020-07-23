import Foundation

public struct VStack<Content> : View where Content : View {
    @inlinable public init(@ViewBuilder content: () -> Content) {
        
    }
}
