//
//  ContentView.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/6/22.
//

import SwiftUI

struct ContentView: View {
    @State private var tabOn: Int = 1
    
    var body: some View {
        TabView (selection: $tabOn) {
            InvestigationView()
            .tabItem({
                Label("Investigation", systemImage: "magnifyingglass")
            }).tag(1)
            GhostListView()
            .tabItem({
                Label("Journal", systemImage: "book.closed.fill")
            }).tag(2)
            AspectListView()
            .tabItem ({
                Label("Aspects", systemImage: "books.vertical")
            }).tag(3)
        }
    }
}
