//
//  Ghosts.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/7/22.
//

import Foundation


struct Ghost: Decodable {
    var evidence : String
    var name : String
    var description: String
    
    func getEvidence() -> [String] {
        return evidence.components(separatedBy: " ")
    }
}

struct Ghosts: Decodable {
    var ghosts : [Ghost]
}

