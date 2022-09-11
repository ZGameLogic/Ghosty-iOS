//
//  LoadingView.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/7/22.
//

import SwiftUI

struct LoadingView: View {
    
    @Binding var isShowing : Bool
    @Binding var progress : Double
    @Binding var ghosts : Ghosts
    
    @State var showError = false
    
    var body: some View {
        ProgressView("Loading data from ghosty API", value: progress)
            .progressViewStyle(LinearProgressViewStyle(tint: .purple)).padding()
            .onAppear(perform: loadData)
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
        guard let url = URL(string: "https://zgamelogic.com/api/ghosty/Ghosts") else {
                  return
              }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data {
                        if let response = try? JSONDecoder().decode(Ghosts.self, from: data) {
                            DispatchQueue.main.async {
                                self.ghosts = response
                                progress = 1.0
                                isShowing = false
                            }
                            return
                        }
                    } else {
                        showError = true
                    }
                }.resume()
    }
}
