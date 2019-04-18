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
    var h: Int
    var cost: Int           //f(n) = g(n) + h(n)
    
    init(coordinates: [Int]) {
        self.coordinates = coordinates
        self.parent = nil
        self.neighbors = []
        self.h = 0
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
var zoneNodes: [Node] = []          //Holds all nodes in chosen zone

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
        //var temp = currentNode.parent!
        currentNode = currentNode.parent!
        /*currentNode.parent = nil
        currentNode.cost = 0
        currentNode.h = 0
        currentNode = temp*/
    }
    path.append(currentNode)
    for node in visited {
        node.cost = 0
        node.h = 0
        node.parent = nil
    }
    /*currentNode.parent = nil
    currentNode.cost = 0
    currentNode.h = 0*/
    return path
}

var visited: Set<Node> = []
func aStar(start: [Int], end:[Int]) -> [Node] {
    var frontier: PriorityQueue<Node> = PriorityQueue<Node>(ascending: true)
    //var visited: Set<Node> = []
    visited = []
    nodeDict[start]!.h = heuristic(start: start, end: end)
    frontier.push(nodeDict[start]!)
    
    while !frontier.isEmpty {
        let currentNode = frontier.pop()
        visited.insert(currentNode!)
        for node in zoneNodes {
            if (node == currentNode && (currentNode != nodeDict[start])) {      //Not optimal node
                return [Node(coordinates: [-1,-1])]                             //Set as currentNode
            }
        }
        //Found Goal
        if (currentNode!.coordinates == end) {
            return getPath(end: currentNode!)
        }
        
        
        //If coord != [-1,-1]
        for neighbor in currentNode!.neighbors {
            let newCost = currentNode!.cost + heuristic(start: currentNode!.coordinates, end: neighbor.coordinates)  //Cost from current to neighbor + current cost
            
            //If neighbor is not in closed list OR has been in closed list and new cost is less
            if (!visited.contains(neighbor) || neighbor.cost > newCost) {
                neighbor.h = heuristic(start: neighbor.coordinates, end: end)
                neighbor.cost = newCost
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
        let zone = findZone(zoneRange: zoneList, coord: start)      //Could be more than one zone
        for coord in zone!.nodes {
            print("----------------")
            printNodes(path: aStar(start: coord.coordinates, end: end))
        }
    }
}


