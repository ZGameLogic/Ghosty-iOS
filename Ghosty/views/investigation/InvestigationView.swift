//
//  InvestigationView.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/11/22.
//

import SwiftUI

struct InvestigationView: View {
    
    @State var orientation = UIDevice.current.orientation
    @State var ghosts : [Ghost]
    
    var body: some View {
        if(orientation.isLandscape){
            Text("Hello in landscape")
        } else {
            Text("Hello in portrait")
        }
    }
}

struct InvestigationView_Previews: PreviewProvider {
    static var previews: some View {
        InvestigationView(ghosts: [Ghost(id: 1, evidence: ["Finger prints"], name: "Ben", description: "Spooky ghost")])
            .previewInterfaceOrientation(.portrait)
    }
}
