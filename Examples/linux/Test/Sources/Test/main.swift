import SDL2
import SwoopUI

class SwoopUIDemo {
    let window: OpaquePointer?
    let renderer: OpaquePointer
    let texture: OpaquePointer
    
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
        
        texture = SDL_CreateTexture(renderer,
                                    SDL_PIXELFORMAT_RGBA8888.rawValue,
                                    Int32(SDL_TEXTUREACCESS_STATIC.rawValue),
                                    800, 600)
    }
    
    func events() {
        var event = SDL_Event()
        if SDL_PollEvent(&event) != 0 {
            if event.type == SDL_QUIT.rawValue {
                SDL_DestroyRenderer(renderer)
                SDL_DestroyWindow(window)
                SDL_Quit()
                exit(0)
            }
        }
    }
    
    func draw() {
        
        //SDL_UpdateTexture(texture, NULL, pixels, 640 * sizeof(Uint32))
        
        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255)
        SDL_RenderClear(renderer)
        SDL_RenderCopy(renderer, texture, nil, nil)
        SDL_RenderPresent(renderer)
    }
    
    func run() {
        while true {
            events()
            draw()
        }
    }
}



let demo = SwoopUIDemo()
demo.run()
