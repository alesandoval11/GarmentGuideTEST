//
//  Zone.swift
//  GarmentGuideTEST
//
//  Created by Ray Kim on 4/15/19.
//  Copyright © 2019 Alejandra Sandoval. All rights reserved.
//

import Foundation


class Zone {
    let id: Int
    let extents: [Int]
    let nodes: [Node]
    var overlap: [Zone]
    init(id: Int, extents: [Int], nodes: [Node]) {
        self.id = id
        self.extents = extents
        self.nodes = nodes
        self.overlap = []
    }
}

/*----------------------------------
            Globals
-----------------------------------*/
var zoneDict: [Int: Zone] = [:]             //Holds all the zones


/*------------------------------------
 Generates zones from a JSON file
 - Parameters:
    fileName: The name of the file
    fileType: The type of file
 - Returns:
    None
 -------------------------------------*/
func createZones(fileName: String, fileType: String){
    
    if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let building = jsonResult["EABA"] as? [Any] {
                for zone in building as! [[String: AnyObject]] {
                    let id = zone["id"] as! Int
                    let extents = zone["extents"] as! [Int]
                    let zoneCoord = zone["nodes"] as! [[Int]]
                    var nodes: [Node] = []
                    for coord in zoneCoord {
                        nodes.append(nodeDict[coord]!)
                    }
                    zoneDict[id] = Zone(id:id, extents:extents, nodes:nodes)
                }
                for zone in building as! [[String: AnyObject]] {
                    let overlaps = zone["overlap"] as! [Int]
                    for ov in overlaps {
                        zoneDict[zone["id"] as! Int]!.overlap.append(zoneDict[ov]!)
                    }
                }
            }
        } catch {
            print("Error")
        }
    }
}


/*------------------------------------
 Finds nodes in zone(s) that are associated with user location.
 - Parameters:
    coord: current user location
 - Returns:
    nodes to check as possible starting points for a star.
 -------------------------------------*/
func findZone(coord: [Int]) -> Set<Node>{
    var temp:[Node] = []
    for zone in zoneDict.values {
        if (coord[0] >= zone.extents[0] &&
            coord[0] <= (zone.extents[0] + zone.extents[2]) &&
            coord[1] >= zone.extents[1] &&
            coord[1] <= zone.extents[1] + zone.extents[3]) {
            temp += zone.nodes
            
            //Check zone connections
            for overlap in zone.overlap {
                if (coord[0] >= overlap.extents[0] &&
                    coord[0] <= (overlap.extents[0] + overlap.extents[2]) &&
                    coord[1] >= overlap.extents[1] &&
                    coord[1] <= overlap.extents[1] + overlap.extents[3]) {
                    temp += overlap.nodes
                }
            }
            return Set(temp)
        }
    }
    return Set()
}



