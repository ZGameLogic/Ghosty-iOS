//
//  GhostDetailView.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/11/22.
//

import SwiftUI

struct GhostDetailView: View {
    
    @State var ghost: Ghost
    
    var body: some View {
        ScrollView {
            VStack {
                Text(ghost.name).font(.title).padding()
                Spacer()
                HStack {
                    ForEach(ghost.evidence, id: \.self) { e in
                        Text(e)
                            .padding()
                            .minimumScaleFactor(0.01)
                            .lineLimit(2)
                    }
                }
                Spacer()
                Text(ghost.description).padding()
            }
        }
    }
}

struct GhostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GhostDetailView(ghost: Ghost(id: 1, evidence:[ "Dots", "EMP level 5", "Ghost Writing"], name: "Banshee", description: "This is a very long description for a ghost becuase they have those things in this game."))
    }
}
