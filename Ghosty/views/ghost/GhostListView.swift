//
//  GhostListView.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/11/22.
//

import SwiftUI

struct GhostListView: View {
    
    @State var ghosts: Ghosts
    
    var body: some View {
        NavigationView {
            List {
                ForEach (ghosts.ghosts.sorted {
                    $0.name < $1.name
                }) { ghost in
                    NavigationLink {
                        GhostDetailView(ghost: ghost)
                    } label: {
                        VStack {
                            HStack {
                                Text(ghost.name).font(.headline)
                                Spacer()
                            }
                            HStack{
                                ForEach(ghost.evidence.sorted {
                                    $0 < $1
                                }, id: \.self) { e in
                                    Text(e).font(.caption).italic()
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }.navigationTitle("Ghosts")
        }
    }
}

struct GhostListView_Previews: PreviewProvider {
    static var previews: some View {
        GhostListView(ghosts: Ghosts(ghosts: [
            Ghost(id: 1, evidence: ["DOTS", "Fingerprints", "EMF 5"], name: "Reba Ghost", description: "This is a spooky ghost who is very attractive"),
            Ghost(id: 2, evidence: ["Freezing", "Writing", "DOTS"], name: "Ben Ghost", description: "THis is a nerd ghost who is a nerd")]))
    }
}
