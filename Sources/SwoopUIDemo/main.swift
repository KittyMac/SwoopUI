import Foundation

import SwoopUI
import Flynn

var body: some View {
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

let img = SwoopUITest(CGSize(width: 600, height: 800), body)
