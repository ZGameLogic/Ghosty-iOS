//
//  LoadingView.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/7/22.
//

import SwiftUI

private let PROGRESS_STEP = 0.25

struct LoadingView: View {
    
    @Binding var isShowing : Bool
    @State var progress = 0.0
    
    @Binding var ghosts : Ghosts
    @Binding var evidences : Evidences
    @Binding var aspects : Aspects
    
    @State var showError = false
    
    var body: some View {
        VStack {
            Text("Loading data from ghosty API")
            ProgressView("", value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .purple)).padding()
                .onAppear(perform: loadData)
                .scaleEffect(y: 4)
                .padding()
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
    }
    
    private func loadData(){
        loadGhosts()
        loadEvidence()
        loadAspects()
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
                                progress += PROGRESS_STEP
                            }
                            return
                        }
                    } else {
                        showError = true
                    }
                }.resume()
    }
    
    private func loadAspects(){
        guard let url = URL(string: "https://zgamelogic.com/api/ghosty/Aspects") else {
                  return
              }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data {
                        if let response = try? JSONDecoder().decode(Aspects.self, from: data) {
                            DispatchQueue.main.async {
                                self.aspects = response
                                progress += PROGRESS_STEP
                                progress += PROGRESS_STEP
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
                                progress += PROGRESS_STEP
                            }
                            return
                        }
                    } else {
                        showError = true
                    }
                }.resume()
    }
}
