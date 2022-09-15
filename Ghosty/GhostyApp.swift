//
//  GhostyApp.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/6/22.
//

import SwiftUI

@main
struct GhostyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(apiGhosts: Ghosts(ghosts: []), apiEvidence: Evidences(evidence: []), apiAspects: Aspects(aspects: []))
        }
    }
}
