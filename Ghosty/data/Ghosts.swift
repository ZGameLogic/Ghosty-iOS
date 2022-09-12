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
}

struct Ghosts: Decodable {
    var ghosts : [Ghost]
}

