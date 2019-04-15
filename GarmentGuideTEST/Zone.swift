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
    let extents: [Int]              //Should most probably be a tuple.
    let nodes: [Node]
    init(id: Int, extents: [Int], nodes: [Node]) {
        self.id = id
        self.extents = extents
        self.nodes = nodes
    }
}

var zoneList: [Zone] = []

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

//Given zones with same x val, find same y val
func findZone(zoneRange:[Zone], coord: [Int]) -> Zone?{
    for zone in zoneRange {
        if (coord[0] >= zone.extents[0] &&
            coord[0] <= (zone.extents[0] + zone.extents[2]) &&
            coord[1] >= zone.extents[1] &&
            coord[1] <= zone.extents[1] + zone.extents[3]) {
            return zone
        }
    }
    return nil
}



