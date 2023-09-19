//
//  AspectListView.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/15/22.
//

import SwiftUI

struct AspectListView: View {
    
    @State var aspects: Aspects = Aspects(aspects: [])
    @State var showError = false
    @State var isLoadingAspects = true
    
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
            if(isLoadingAspects){
                ProgressView()
            } else {
                List {
                    ForEach(aspects.getTypes(), id: \.self) { type in
                        Section(type){
                            ForEach(aspects.getAspectsByType(type: type)){ aspect in
                                if(searchText == "" || aspect.name.contains(searchText)){
                                    NavigationLink (destination: {
                                        AspectDetailView(aspect: aspect)
                                    }, label: {
                                        Text(aspect.name)
                                    })
                                }
                            }
                        }
                    }
                }
                .searchable(text: $searchText)
                .navigationTitle("Aspects")
            }
        }.onAppear(perform: {
            if(isLoadingAspects){
                loadAspects()
            }
        })
    }
    
    private func loadAspects(){
        guard let url = URL(string: "https://zgamelogic.com:2006/ghosty/Aspects") else {
            return
          }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data {
                        if let response = try? JSONDecoder().decode(Aspects.self, from: data) {
                            DispatchQueue.main.async {
                                self.aspects = response
                                isLoadingAspects = false
                            }
                            return
                        }
                    } else {
                        showError = true
                    }
                }.resume()
    }
    
}

struct AspectListView_Previews: PreviewProvider {
    static var previews: some View {
        AspectListView(aspects: Aspects(aspects: [
            Aspect(id: 1, name: "Couch", type: "Misc", content: "Oh dang couches are neat to sit on"),
            Aspect(id: 2, name: "Table", type: "Tool", content: "You eat on tables")
        ]))
    }
}
