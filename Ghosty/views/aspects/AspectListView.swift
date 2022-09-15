//
//  AspectListView.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/15/22.
//

import SwiftUI

struct AspectListView: View {
    
    @State var aspects: Aspects
    
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
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
