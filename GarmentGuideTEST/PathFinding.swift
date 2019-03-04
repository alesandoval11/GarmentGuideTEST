//
//  PathFinding.swift
//  GarmentGuideTEST
//
//  Created by Ray Kim on 3/4/19.
//  Copyright © 2019 Alejandra Sandoval. All rights reserved.
//

import Foundation

class Node {
    var name: String
    var location: (Int,Int)
    var adjacent: [Node] = []
    var error: Int
    
    init(name: String, location: (Int, Int), adjacent: [Node], error: Int) {
        self.name = name
        self.location = location
        self.adjacent = adjacent
        self.error = error
    }
    
}
