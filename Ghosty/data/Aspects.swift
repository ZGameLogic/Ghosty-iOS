//
//  Aspects.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/15/22.
//

import Foundation


struct Aspects: Decodable {
    var aspects: [Aspect]
    
    func getTypes() -> [String] {
        var types = Set<String>()
        for aspect in aspects {
            types.insert(aspect.type)
        }
        print(types.count)
        return Array(types).sorted(by: {$0 < $1})
    }
    
    func getAspectsByType(type: String) -> [Aspect] {
        var list : [Aspect] = []
        for aspect in aspects {
            if(aspect.type == type){
                list.append(aspect)
            }
        }
        return list.sorted(by: {$0.name < $1.name})
    }
    
    func getAspects() -> [Aspect]{
        let sorted = aspects.sorted(by: {$0.name < $1.name})
        return sorted
    }
}

struct Aspect: Decodable, Identifiable {
    var id: Int
    var name : String
    var type : String
    var content : String
}
