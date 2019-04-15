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

class Zone {
    let id: Int
    let extents: [Int]              //Should most probably be a tuple.
    let nodes: [Node]
    init(id: Int, extents: [Int], nodes: [Node]) {
        self.id = id
        self.extents = extents
        self.nodes = nodes
    }
}

var nodeDict: [[Int]: Node] = [:]  //Holds all the nodes.
var zoneList: [Zone] = []
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

func createZones(fileName: String, fileType: String){
    
    if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let building = jsonResult["EABA"] as? [Any] {
                zoneList.removeAll()
                for zone in building as! [[String: AnyObject]] {
                    let id = zone["id"] as! Int
                    let extents = zone["extents"] as! [Int]
                    let zoneCoord = zone["nodes"] as! [[Int]]
                    var nodes: [Node] = []
                    for coord in zoneCoord {
                        nodes.append(nodeDict[coord]!)
                    }
                    zoneList.append(Zone(id:id, extents:extents, nodes:nodes))
                }
                zoneList.sort(by: {$0.extents[0]+$0.extents[2] < $1.extents[0]+$1.extents[2]})      //sort by xmin + xmax
            }
        } catch {
            // handle error
            print("Error")
        }
    }
}

//Binary search
//NEEDS TO BE WRITTEN BETTER
//Returns index of first match
func binarySearch(sortedzones: [Zone], location: [Int]) -> Int{
    var l = 0
    var r = sortedzones.count - 1
    var m = 0
    while(l <= r) {
        m = (l + r) / 2
        if (zoneList[m].extents[0] + zoneList[m].extents[2]  < location[0]) {
            l = m + 1
            if (l == sortedzones.count && location[0] <= zoneList[m].extents[0]) {
                return m
            }
        }
        else if (zoneList[m].extents[0] + zoneList[m].extents[2]  > location[0]) {
            r = m - 1
            if (r == -1 && location[0] >= zoneList[m].extents[0]) {
                return m
            }
        }
        else {
            return m
        }
    }
    return m
}

//Gets range of zones in suitable area
func zoneRange(sortedzones: [Zone], index: Int) ->[Zone]{
    let value = sortedzones[index].extents[0] + sortedzones[index].extents[2]
    var countLower = 0
    var countUpper = 0
    var range: [Int] = []
    
    //Upper
    if(index != sortedzones.count-1) {
        for i in index...sortedzones.count-1 {
            if(sortedzones[i].extents[0] + sortedzones[i].extents[2] == value) {
                countUpper += 1
            }
            else {
                break
            }
        }
    }
    
    if(index != 0) {
    //Lower
        for i in (0...index-1).reversed() {
            if(sortedzones[i].extents[0] + sortedzones[i].extents[2] == value) {
                countLower += 1
            }
            else {
                break
            }
        }
    }
    if (countUpper > 0 && countLower > 0) {
        range = [index-countLower,index+countUpper]
    }
    else if (countUpper > 0 && countLower == 0) {
        range = [index,index+countUpper]
    }
    else if (countLower > 0 && countUpper == 0) {
        range = [index-countLower,index]
    }
    else {
        range = [index,index]
    }
    return Array(sortedzones[range[0]...range[1]])
}

//Given zones with same x val, find same y val
func findZone(zoneRange:[Zone], coord: [Int]) -> Zone?{
    for zone in zoneRange {
        if (coord[0] >= zone.extents[0] && coord[0] <= zone.extents[0] + zone.extents[2] && coord[1] >= zone.extents[1] && coord[1] <= zone.extents[1] + zone.extents[3]) {
            return zone
        }
    }
    return nil
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
        let index = binarySearch(sortedzones: zoneList, location: start)
        let zoneArr: [Zone] = zoneRange(sortedzones: zoneList, index: index)
        let zone = findZone(zoneRange: zoneArr, coord: start)
        for coord in zone!.nodes {
            print("----------------")
            printNodes(path: aStar(start: coord.coordinates, end: end))
        }
    }
}


