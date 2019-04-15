//
//  PathFinding.swift
//  GarmentGuideTEST
//
//  Created by Ray Kim on 3/4/19.
//  Copyright © 2019 Alejandra Sandoval. All rights reserved.
//

import Foundation

class Node {
    let coordinates: [Int]
    var parent: Node?
    var neighbors: [Node]
    var g: Int
    var h: Int
    var cost: Int           //f(n) = g(n) + h(n)
    
    init(coordinates: [Int]) {
        self.coordinates = coordinates
        self.parent = nil
        self.neighbors = []
        self.g = Int.max
        self.h = Int.max
        self.cost = 0
    }
    
}

//Necessary for Hashable protocol which is used for sets
extension Node: Hashable {
    static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.coordinates == rhs.coordinates
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinates)
    }
}

extension Node: Comparable {
    static func < (lhs: Node, rhs: Node) -> Bool {
        return lhs.cost < rhs.cost
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
                    let coordinates = node["coordinates"] as! [Int]
                    nodeDict.updateValue(Node(coordinates: coordinates), forKey: node["coordinates"] as! [Int])
                }
                for node in building as! [[String: AnyObject]] {
                    let neighbors = node["connections"] as! [[Int]]
                    for neighbor in neighbors {
                        nodeDict[node["coordinates"] as! [Int]]!.neighbors.append(nodeDict[neighbor]!)
                    }
                }
                //dump(nodeDict)
            }
        } catch {
            // handle error
            print("Error")
        }
    }
}


//Euclidean distance squared (No need for sqrt as we don't need actual distance)
func heuristic(start: [Int], end: [Int]) -> Int{
    return Int(pow(Double(start[1] - end[1]),2) + pow(Double(start[0] - end[0]),2))
}

//Backtracking function
func getPath(end: Node) -> [Node] {
    var path: [Node] = []       //Path stored in reverse order
    var currentNode = end
    while (currentNode.parent != nil) {
        path.append(currentNode)
        currentNode = currentNode.parent!
    }
    path.append(currentNode)
    return path
}


func aStar(start: [Int], end:[Int]) -> [Node] {
    var frontier: PriorityQueue<Node> = PriorityQueue<Node>(ascending: true)
    var visited: Set<Node> = []
    nodeDict[start]!.g = 0
    nodeDict[start]!.h = heuristic(start: start, end: end)
    frontier.push(nodeDict[start]!)
    
    while !frontier.isEmpty {
        let currentNode = frontier.pop()
        visited.insert(currentNode!)
        
        //Found Goal
        if (currentNode!.coordinates == end) {
            return getPath(end: currentNode!)
        }
        
        for neighbor in currentNode!.neighbors {
            let newG = currentNode!.g + heuristic(start: currentNode!.coordinates, end: neighbor.coordinates)  //Cost from current to neighbor + current cost
            
            //If neighbor is in closed list
            if (visited.contains(neighbor)) {
                continue
            }
           
            //If neighbor is not in closed list OR has been in closed list and new cost is less
            if (!visited.contains(neighbor) || neighbor.g > newG) {
                if (neighbor.h == Int.max) {
                    neighbor.h = heuristic(start: neighbor.coordinates, end: end)   //Cost from neighbor to goal.
                }
                neighbor.g = newG
                neighbor.cost = neighbor.g + neighbor.h
                neighbor.parent = currentNode
                visited.insert(neighbor)
                frontier.push(neighbor)
            }
        }
    }
    return [Node(coordinates: [-1,-1])]         //For testing... need to fix
}

func printNodes(path: [Node]) {
    for node in path.reversed() {
        print(node.coordinates)
    }
}

func findPath(start: [Int], end:[Int]) {
    if (nodeDict[start] != nil) {            //If user is located at existing node
        let path: [Node] = aStar(start: start, end:end)
        printNodes(path: path)
    }
    else {
        //Zone guidance function
        //let index = binarySearch(sortedzones: zoneList, location: start)
        //let zoneArr: [Zone] = zoneRange(sortedzones: zoneList, index: index)
        let zone = findZone(zoneRange: zoneList, coord: start)
        for coord in zone!.nodes {
            print("----------------")
            print(coord.coordinates)
            //printNodes(path: aStar(start: coord.coordinates, end: end))
        }
    }
}


