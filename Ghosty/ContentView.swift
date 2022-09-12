//
//  ContentView.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/6/22.
//

import SwiftUI

struct ContentView: View {
    
    // if we are getting the information or not
    @State var isShowLoading = true
    
    @State var apiGhosts: Ghosts
    @State var apiEvidence: Evidences
    
    @State private var tabOn: Int = 1
    
    var body: some View {
        if(isShowLoading){
            LoadingView(isShowing: $isShowLoading, ghosts: $apiGhosts, evidences: $apiEvidence)
        } else {
            TabView (selection: $tabOn) {
                InvestigationView(ghosts: apiGhosts.ghosts)
                .tabItem({
                    Label("Investigation", systemImage: "magnifyingglass")
                }).tag(1)
                GhostListView(ghosts: apiGhosts)
                .tabItem({
                    Label("Journal", systemImage: "books.vertical")
                }).tag(2)
            }
        }
    }
}
