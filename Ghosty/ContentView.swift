//
//  ContentView.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/6/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var isShowLoading = true
    @State var loadingProgress = 0.0
    @State var results: Ghosts
    
    var body: some View {
        if(isShowLoading){
            LoadingView(isShowing: $isShowLoading, progress: $loadingProgress, ghosts: $results)
        } else {
            List {
                ForEach (results.ghosts.sorted {
                    $0.name < $1.name
                }) { ghost in
                    Text(ghost.name)
                }
            }
        }
    }
}
