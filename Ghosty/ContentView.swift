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
    
    var body: some View {
        LoadingView(isShowing: isShowLoading, progress: loadingProgress)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isShowLoading: true)
    }
}
