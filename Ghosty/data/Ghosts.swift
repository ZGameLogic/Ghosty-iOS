//
//  Ghosts.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/7/22.
//

import Foundation


struct Ghost: Identifiable, Decodable {
    var id: Int
    var evidence : [String]
    var name : String
    var description: String
    
    func isValid(currentEvidence: [String]) -> Bool {
        Set(currentEvidence).isSubset(of: Set(evidence))
    }
    
    func remainingEvidence(currentEvidence: [String]) -> [String]{
        var total = evidence
        total.removeAll(where: {currentEvidence.contains($0)})
        return total
    }
}

struct Ghosts: Decodable {
    var ghosts : [Ghost]
}

