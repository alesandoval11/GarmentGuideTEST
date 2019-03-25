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
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let EABA = jsonResult["EABA"] as? [Any] {
                // do stuff
                for beaconName in EABA as! [Dictionary<String, AnyObject>] { // or [[String:AnyObject]]
                    let label = beaconName["label"] as! String
                    // do something with personName and personID
                    print(label);
                }
            }
        } catch {
            // handle error
            print("Error")
        }
    }
}
