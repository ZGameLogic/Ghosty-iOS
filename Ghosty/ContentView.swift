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
    @State var apiAspects: Aspects
    
    @State private var tabOn: Int = 1
    
    var body: some View {
        if(isShowLoading){
            LoadingView(isShowing: $isShowLoading, ghosts: $apiGhosts, evidences: $apiEvidence, aspects: $apiAspects)
        } else {
            TabView (selection: $tabOn) {
                InvestigationView(ghosts: apiGhosts.ghosts, evidences: apiEvidence.evidence)
                .tabItem({
                    Label("Investigation", systemImage: "magnifyingglass")
                }).tag(1)
                GhostListView(ghosts: apiGhosts)
                .tabItem({
                    Label("Journal", systemImage: "book.closed.fill")
                }).tag(2)
                AspectListView(aspects: apiAspects)
                .tabItem ({
                    Label("Aspects", systemImage: "books.vertical")
                }).tag(3)
            }
        }
    }
}
