//
//  AspectDetailView.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/15/22.
//

import SwiftUI

struct AspectDetailView: View {
    
    @State var aspect: Aspect
    
    var body: some View {
        ScrollView {
            VStack {
                Text(aspect.name).font(.title).padding()
                Text(aspect.type).font(.subheadline)
                Spacer()
                Text(aspect.content).padding()
                Spacer()
            }
        }
    }
}

struct AspectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AspectDetailView(aspect: Aspect(id: 1, name: "Couch", type: "Thing", content: "What a neat place to sit"))
    }
}
