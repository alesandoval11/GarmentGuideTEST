//
//  PathFinding.swift
//  GarmentGuideTEST
//
//  Created by Ray Kim on 3/4/19.
//  Copyright © 2019 Alejandra Sandoval. All rights reserved.
//

import Foundation

class Node: Decodable {
    let id: Int
    let coordinates: [Int]
    let connections: [Connection]
    var visited: Bool
    
    init(id: Int, coordinates: [Int], connections: [Connection]) {
        self.id = id
        self.coordinates = coordinates
        self.connections = connections
        self.visited = false
    }
}

class Connection: Decodable {
    let to: Node
    let weight: Int
    
    init(to: Node, weight: Int) {
        self.to = to
        self.weight = weight
    }
}
