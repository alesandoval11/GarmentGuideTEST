//
//  PathFinding.swift
//  GarmentGuideTEST
//
//  Created by Ray Kim on 3/4/19.
//  Copyright © 2019 Alejandra Sandoval. All rights reserved.
//

import Foundation

struct Node: Codable {
    var id: Int
    var coordinates: [Int]
    var adjacent: [Int]
}

//Get Nodes and connections from txt file

func readFile() {
    if let path = Bundle.main.url(forResource: "beacons", withExtension: "json") {
        do {
            let data = try Data(contentsOf: path)
            let decoder = JSONDecoder()
            let point = try decoder.decode(Node.self, from: data)
            print(point.id)
            print(point.coordinates)
            print(point.adjacent)
        } catch {
            print("Error")
        }
    }
}
