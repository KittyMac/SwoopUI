//
//  ContentView.swift
//  Test
//
//  Created by Rocco Bowling on 8/1/20.
//  Copyright © 2020 Rocco Bowling. All rights reserved.
//

import SwoopUI

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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
