//
//  LoadingView.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/7/22.
//

import SwiftUI

struct LoadingView: View {
    
    @Binding var isShowing : Bool
    @State var progress = 0.0
    @Binding var ghosts : Ghosts
    @Binding var evidences : Evidences
    
    @State var showError = false
    
    var body: some View {
        ProgressView("Loading data from ghosty API", value: progress)
            .progressViewStyle(LinearProgressViewStyle(tint: .purple)).padding()
            .onAppear(perform: loadData)
            .onChange(of: progress, perform: { old in
                if(progress >= 1.0){
                    isShowing = false
                }
            })
            .alert("Unable to connect to GhostyAPI",
                isPresented: $showError,
                actions: {
                    Button("Okay", action: {})
                    Button("Try again", action: {
                        showError = false
                        loadData()
                    })
                },
                message: {
                    Text("Make sure you are connected to the internet")
            })
    }
    
    private func loadData(){
        loadGhosts()
        loadEvidence()
    }
    
    private func loadEvidence(){
        guard let url = URL(string: "https://zgamelogic.com/api/ghosty/Evidence") else {
                  return
              }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data {
                        if let response = try? JSONDecoder().decode(Evidences.self, from: data) {
                            DispatchQueue.main.async {
                                self.evidences = response
                                progress += 0.5
                                print(evidences.evidence)
                            }
                            return
                        }
                    } else {
                        showError = true
                    }
                }.resume()
    }
    
    private func loadGhosts(){
        guard let url = URL(string: "https://zgamelogic.com/api/ghosty/Ghosts2") else {
                  return
              }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data {
                        if let response = try? JSONDecoder().decode(Ghosts.self, from: data) {
                            DispatchQueue.main.async {
                                self.ghosts = response
                                progress += 0.5
                            }
                            return
                        }
                    } else {
                        showError = true
                    }
                }.resume()
    }
}
