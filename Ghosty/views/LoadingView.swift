//
//  LoadingView.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/7/22.
//

import SwiftUI

struct LoadingView: View {
    
    @State var isShowing : Bool
    @State var progress : Double
    
    var body: some View {
        ProgressView("Loading data from ghosty API", value: progress).padding()
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isShowing: true, progress: 0.25)
            .previewInterfaceOrientation(.portrait)
    }
}
