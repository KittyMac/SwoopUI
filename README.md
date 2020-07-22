SwoopUI is a fully concurrent, run anywhere, highly experimental drop in replacement for Swift UI.

### Goals

1. **Independance**  
    SwoopUI should have as few platform dependencies as possible. It should not use any graphical APIs like Metal/Vulkan/OpenGL (it should work on platforms without a GPU). Anyone should be able to use SwoopUI anywhere, whether that's on a Raspberry Pi or on an iPhone.
2. **Full Concurrency**  
    As of the time of this writing, most platforms capable of running Swift have more than a single core. SwoopUI uses [Flynn](https://github.com/KittyMac/flynn), the Actor-Model framework for Swift, to make concurrent programming easy and safe. It is our belief that highly concurrent code provide both higher performance and less power consumption.
3. **SwiftUI Equivalent**  
    As much as is possible, SwoopUI should be hot-swappable with SwiftUI syntactically.