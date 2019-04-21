//
//  PathFinding.swift
//  GarmentGuideTEST
//
//  Created by Ray Kim on 3/4/19.
//  Copyright © 2019 Alejandra Sandoval. All rights reserved.
//

import Foundation
import CoreLocation

class Node: NSCopying {
    
    let coordinates: [Int]
    var parent: Node? = nil
    var neighbors: [Node]
    var h: Int
    var g: Int
    var f: Int           //f(n) = g(n) + h(n)
    
    init(coordinates: [Int], parent: Node? = nil, neighbors: [Node] = [], h: Int = 0, g: Int = 0, f: Int = 0) {
        self.coordinates = coordinates
        self.parent = parent
        self.neighbors = neighbors
        self.h = h
        self.g = g
        self.f = f
    }
    
    //"Deep Copy" for comparing paths and keeping their values
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Node(coordinates: coordinates, parent: parent, neighbors: neighbors, h:h, g:g, f:f)
        return copy
    }
}

//Used for sets
extension Node: Hashable {
    static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.coordinates == rhs.coordinates
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinates)
    }
}

//Used for priority Queue
extension Node: Comparable {
    static func < (lhs: Node, rhs: Node) -> Bool {
        return lhs.f < rhs.f
    }
}

/*----------------------------------
                Globals
 -----------------------------------*/
var nodeDict: [[Int]: Node] = [:]       //Holds all the nodes.
var zoneNodes: Set<Node> = []           //Holds all nodes in chosen zone
var visited: Set<Node> = []             //Visited nodes for a star


/*------------------------------------
 Generates nodes from a JSON file
 - Parameters:
    fileName: The name of the file
    fileType: The type of file
 - Returns:
    None
 -------------------------------------*/
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
            }
        } catch {
            print("Error")
        }
    }
}


/*------------------------------------
Calculate euclidean distance squared. No need for sqrt.
 - Parameters:
    start: starting coordinates
    end: ending coordinates
 - Returns:
    Euclidean distance squared
 -------------------------------------*/
func heuristic(start: [Int], end: [Int]) -> Int{
    return Int(pow(Double(start[1] - end[1]),2) + pow(Double(start[0] - end[0]),2))
}


/*------------------------------------
  Compute A Star Algorithm
 - Parameters:
    start: starting coordinates
    end: ending coordinates
 - Returns:
    path of nodes in reverse order
 -------------------------------------*/
func aStar(start: [Int], end:[Int]) -> [Node] {
    var frontier: PriorityQueue<Node> = PriorityQueue<Node>(ascending: true)
    //Clear values for each run
    for node in visited {
        node.f = 0
        node.h = 0
        node.g = 0
        node.parent = nil
    }
    visited = []
    nodeDict[start]!.h = heuristic(start: start, end: end)
    nodeDict[start]!.f = nodeDict[start]!.h
    frontier.push(nodeDict[start]!)

    while !frontier.isEmpty {
        var currentNode = frontier.pop()
        visited.insert(currentNode!)
        
        //Ignore non optimal paths that include nodes in the zone array
        if (zoneNodes.contains(currentNode!) && (currentNode != nodeDict[start])) {
                currentNode = Node(coordinates: [-1,-1])
        }
        
        //Found Goal
        if (currentNode!.coordinates == end) {
            return getPath(end: currentNode!)
        }
        
        //Compute costs of neighbors and add to visited & frontier
        if (currentNode!.coordinates != [-1,-1]) {
            for neighbor in currentNode!.neighbors {
                let newG = currentNode!.g + heuristic(start: currentNode!.coordinates, end: neighbor.coordinates)  //Old g value + distance from current to neighbor
                
                //If neighbor is not in closed list OR has been in closed list and new cost is less
                if (!visited.contains(neighbor) || neighbor.g > newG) {
                    neighbor.h = heuristic(start: neighbor.coordinates, end: end)
                    neighbor.g = newG
                    neighbor.f = newG + neighbor.h                //f = g + h
                    neighbor.parent = currentNode
                    visited.insert(neighbor)
                    frontier.push(neighbor)
                }
            }
        }
    }
    return [Node(coordinates: [-1,-1])]
}


/*------------------------------------
 Backtracks through nodes to generate path
 - Parameters:
    end: end node
 - Returns:
    path of nodes in reverse order
 -------------------------------------*/
func getPath(end: Node) -> [Node] {
    var path: [Node] = []
    var currentNode = end
    while (currentNode.parent != nil) {
        path.append(currentNode)
        currentNode = currentNode.parent!
    }
    path.append(currentNode)
    return path
}


/*------------------------------------
 Prints the most optimal path
 - Parameters:
    path: array of nodes ordered in reverse
 - Returns:
    prints each step of path along with values
 -------------------------------------*/
func printNodes(path: [Node]) {
    for node in path.reversed() {
        print("coord: ", node.coordinates)
        print("g: ", node.g)
        print("h: ", node.h)
        print("f: ", node.f)
    }
}


/*------------------------------------
 Calculates the angle necessary for the user to turn to be faced toward the desination.
 - Parameters:
    start: starting coordinates
    end: ending coordinates
    starAngle: the user's current orientation
 - Returns:
    correction angle
 -------------------------------------*/
/*func calculateAngle(start:[Int], end:[Int], startAngle:Double) -> Double{
    let northAngle = 45.0
    let userAngle = startAngle
    let xDist = abs(Double(start[0]-end[0]))
    let yDist = abs(Double(start[1]-end[1]))
    /*if (end[0] > start[0] && end[1] > start[1]) {           //Node in top right
        let node = atan(yDist/xDist) * 180 / Double.pi
       
    }
    else if (end[0] > start[0] && end[1] < start[1]) {      //Node in bottom right
        
    }
    else if (end[0] < start[0] && end[1] < start[1]) {      //Node in bottom left
        
    }
    else {                                                  //Node in top left
        
    }*/
}*/

/*------------------------------------
 Calls other functions to find and display optimal path.
 Handles starting locations at nodes or not at nodes.
 - Parameters:
    start: starting coordinates
    end: ending coordinates
 - Returns:
    prints each step of path along with values
 -------------------------------------*/
func findPath(start: [Int], end:[Int]) {
    if (nodeDict[start] != nil) {            //If user is located at existing node
        let path: [Node] = aStar(start: start, end:end)
        printNodes(path: path)
    }
    else {
        //Zone guidance function
        zoneNodes = findZone(coord: start)      //Could be more than one zone
        var optimalPath:[Node] = []
        for node in zoneNodes {
            let path = aStar(start: node.coordinates, end: end)
            if (path[0].coordinates != [-1,-1]) {
                if (optimalPath.isEmpty) {
                    optimalPath = path.map{$0.copy() as! Node}
                }
                else if (optimalPath[0].f > path[0].f) {
                    optimalPath = path.map{$0.copy() as! Node}
                }
            }
        }
        //let correctionAngle = calculateAngle(start: start, end: optimalPath[optimalPath.count-1].coordinates, startAngle: //orientation)
        print("----------------")
        //print("Angle to First Node: ", correctionAngle)
        printNodes(path: optimalPath)
    }
}


