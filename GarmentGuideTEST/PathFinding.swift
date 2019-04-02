//
//  PathFinding.swift
//  GarmentGuideTEST
//
//  Created by Ray Kim on 3/4/19.
//  Copyright © 2019 Alejandra Sandoval. All rights reserved.
//

import Foundation

class Node {
    let id: Int
    let coordinates: [Int]
    let connections: [Connection]
    
    init(id: Int, coordinates: [Int], connections: [Connection]) {
        self.id = id
        self.coordinates = coordinates
        self.connections = connections
    }
}

class Connection {
    let to: Node
    let weight: Int
    
    init(to: Node) {
        self.to = to
        self.weight = 0
    }
}

func readJSON(fileName: String, fileType: String){
    if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let building = jsonResult["EABA"] as? [Any] {
                for node in building as! [Dictionary<String, AnyObject>] { // or [[String:AnyObject]]
                    let id = node["id"] as! Int
                    let label = node["label"] as! String
                    let coordinates = node["coordinates"] as! [Int]
                    let connections = node["connections"] as! [Int]
                    print(id)
                    print(label)
                    print(coordinates)
                    print(connections)
                }
            }
        } catch {
            // handle error
            print("Error")
        }
    }
}
