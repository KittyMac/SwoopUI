import SDL2
import SwoopUI

class SwoopUIDemo {
    let window: OpaquePointer?
    let renderer: OpaquePointer
    var texture: OpaquePointer?
    
    var view = BitmapHostingView()
    
    init() {
        if SDL_Init(SDL_INIT_VIDEO) < 0 {
            fatalError("Failed to init SDL")
        }
        
        window = SDL_CreateWindow("SwoopUI Test", 0, 0, 800, 600,
                                  SDL_WINDOW_SHOWN.rawValue |
                                    SDL_WINDOW_RESIZABLE.rawValue |
                                    SDL_WINDOW_ALLOW_HIGHDPI.rawValue)
        
        if window == nil {
            fatalError("Failed to create window")
        }
        
        renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED.rawValue)
    }
    
    func setRootView(rootView: View) {
        view.setRootView(rootView: rootView)
    }
    
    func quit() {
        SDL_DestroyRenderer(renderer)
        SDL_DestroyWindow(window)
        SDL_Quit()
        exit(0)
    }
    
    func events() {
        var event = SDL_Event()
        if SDL_PollEvent(&event) != 0 {
            if event.type == SDL_QUIT.rawValue {
                quit()
            }
            if event.type == SDL_WINDOWEVENT.rawValue {
                if event.window.windowID == SDL_GetWindowID(window)  {
                    switch UInt32(event.window.event)  {
                    case SDL_WINDOWEVENT_SIZE_CHANGED.rawValue:
                        view.layout(Int(event.window.data1), Int(event.window.data2))
                    case SDL_WINDOWEVENT_CLOSE.rawValue:
                        quit()
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func draw() {
        
        if view.display() {
            let info = view.bitmapInfo
            texture = SDL_CreateTexture(renderer,
                                        SDL_PIXELFORMAT_RGBA8888.rawValue,
                                        Int32(SDL_TEXTUREACCESS_STATIC.rawValue),
                                        Int32(info.width), Int32(info.height))
            SDL_UpdateTexture(texture, nil, info.bytes32, Int32(info.bytesPerRow))
            
            SDL_RenderCopy(renderer, texture, nil, nil)
            SDL_RenderPresent(renderer)
            
            SDL_DestroyTexture(texture)
        }
    }
    
    func run() {
        while true {
            let timeStart = SDL_GetTicks()
            
            events()
            draw()
            
            // limit to 30 fps
            let timeTaken = Int(SDL_GetTicks() - timeStart)
            if timeTaken < 33 {
                SDL_Delay(UInt32(33 - timeTaken))
            }
        }
    }
}



let demo = SwoopUIDemo()

struct ContentView: View {
    var body: View {
        VStack {
            HStack {
                Color.red
                Color.green
                Color.blue
                Color.yellow
            }
            HStack {
                Color.yellow
                Color.red
                Color.green
                Color.blue
            }
            HStack {
                Color.blue
                Color.yellow
                Color.red
                Color.green
            }
            HStack {
                Color.green
                Color.blue
                Color.yellow
                Color.red
            }
        }
    }
}

let contentView = ContentView()
demo.setRootView(rootView: contentView)

demo.run()
