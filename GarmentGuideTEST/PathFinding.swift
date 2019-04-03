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
    var neighbors: [Node]
    
    init(id: Int, coordinates: [Int]) {
        self.id = id
        self.coordinates = coordinates
        self.neighbors = []
    }
}
 var nodeDict: [[Int]: Node] = [:]  //Holds all the nodes.
/**
 --------------------------------
 Fix: Make Dictionary Global
 --------------------------------
 Generates nodes from a JSON file
 - Parameters:
    fileName: The name of the file
    fileType: The type of file
 - Returns: Dictionary of Nodes
 */
func createNodes(fileName: String, fileType: String){
   
    if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let building = jsonResult["EABA"] as? [Any] {
                for node in building as! [[String: AnyObject]] {
                    let id = node["id"] as! Int
                    let coordinates = node["coordinates"] as! [Int]
                    nodeDict.updateValue(Node(id: id,coordinates: coordinates), forKey: node["coordinates"] as! [Int])
                }
                for node in building as! [[String: AnyObject]] {
                    let neighbors = node["connections"] as! [[Int]]
                    for neighbor in neighbors {
                        nodeDict[node["coordinates"] as! [Int]]!.neighbors.append(nodeDict[neighbor]!)
                    }
                }
                dump(nodeDict)
            }
        } catch {
            // handle error
            print("Error")
        }
    }
}

func AStar(start: [Int], end:[Int]) {
    if (nodeDict[start] != nil) {            //If user is located at existing node
        //A star
    }
    else {
        //Zone guidance function
    }
}
