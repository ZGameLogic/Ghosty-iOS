//
//  GhostListView.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/11/22.
//

import SwiftUI

struct GhostListView: View {
    
    @State var ghosts: Ghosts = Ghosts(ghosts: [])
    @State var isLoadingGhosts = true
    @State var showError = false
    
    @State var searched = ""
    
    var body: some View {
        NavigationView {
            if(isLoadingGhosts){
                ProgressView()
            } else {
                List {
                    ForEach (ghosts.ghosts.sorted {
                        $0.name < $1.name
                    }) { ghost in
                        if(ghost.name.contains(searched) || searched == ""){
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
                    }
                }.searchable(text: $searched)
                .navigationTitle("Ghosts")
            }
        }
            .onAppear(perform: {
                if(isLoadingGhosts){
                    loadGhosts()
                }
            })
            .alert("Unable to connect to GhostyAPI",
                     isPresented: $showError,
                     actions: {
                  Button("Okay", action: {})
                  Button("Try again", action: {
                      showError = false
                      loadGhosts()
                  })
              },
                     message: {
                  Text("Make sure you are connected to the internet")
              })
    }
    
    private func loadGhosts(){
        guard let url = URL(string: "https://zgamelogic.com:2006/ghosty/Ghosts2") else {
                  return
              }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data {
                        if let response = try? JSONDecoder().decode(Ghosts.self, from: data) {
                            DispatchQueue.main.async {
                                self.ghosts = response
                                isLoadingGhosts = false
                            }
                            return
                        }
                    } else {
                        showError = true
                    }
                }.resume()
    }
}

struct GhostListView_Previews: PreviewProvider {
    static var previews: some View {
        GhostListView(ghosts: Ghosts(ghosts: [
            Ghost(id: 1, evidence: ["DOTS", "Fingerprints", "EMF 5"], name: "Reba Ghost", description: "This is a spooky ghost who is very attractive"),
            Ghost(id: 2, evidence: ["Freezing", "Writing", "DOTS"], name: "Ben Ghost", description: "THis is a nerd ghost who is a nerd")]))
    }
}
