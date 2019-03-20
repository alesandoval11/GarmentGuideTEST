//
//  PathFinding.swift
//  GarmentGuideTEST
//
//  Created by Ray Kim on 3/4/19.
//  Copyright © 2019 Alejandra Sandoval. All rights reserved.
//

import Foundation

//Need to rename variables because of confusion
struct Graph: Decodable {
    var node: [Node]
}

struct Node: Decodable {
    var id: Int
    var coordinates: [Int]
    var adjacent: [Int]
}

//JSON Decoder
func readFile() {
    if let path = Bundle.main.url(forResource: "beacons", withExtension: "json") {
        do {
            let data = try Data(contentsOf: path)
            let decoder = JSONDecoder()
            let point = try decoder.decode(Graph.self, from: data)
            print(point.node[0].id)
            print(point.node[1].coordinates)
            print(point.node[2].adjacent)
        } catch {
            print("Error")
        }
    }
}
