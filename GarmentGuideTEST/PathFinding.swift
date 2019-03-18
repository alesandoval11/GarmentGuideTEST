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

//Get Nodes and connections from txt file

func readFile(fileName: String) -> Any?
{
    var json: Any?
    if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
        do {
            let fileUrl = URL(fileURLWithPath: path)
            // Getting data from JSON file using the file URL
            let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
            json = try? JSONSerialization.jsonObject(with: data)
        } catch {
            // Handle error here
        }
    }
    return json
}
