//
//  Utilities.swift
//  GarmentGuideTEST
//
//  Created by Ray Kim on 3/25/19.
//  Copyright © 2019 Alejandra Sandoval. All rights reserved.
//

import Foundation

var JSONinfo = 0

func readJSON(fileName: String, fileType: String){
    if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let building = jsonResult["EABA"] as? [Any] {
                for node in building as! [Dictionary<String, AnyObject>] { // or [[String:AnyObject]]
                    let id = node["id"] as! Int
                    let label = node["label"] as! String
                    let type = node["type"] as! String
                    let coordinates = node["coordinates"] as! NSArray
                    let connections = node["connections"] as! NSArray
                    print(id)
                    print(label)
                    print(type)
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
