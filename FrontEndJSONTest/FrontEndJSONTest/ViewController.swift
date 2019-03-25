//
//  ViewController.swift
//  FrontEndJSONTest
//
//  Created by Brian Munoz on 3/18/19.
//  Copyright © 2019 Brian Munoz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func buttonPressedEABA(_ sender: UIButton) {
        //print("hello world");
        if let path = Bundle.main.path(forResource: "test", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let eaba = jsonResult["eaba"] as? [Any] {
                    // do stuff
                    for beaconName in eaba as! [Dictionary<String, AnyObject>] { // or [[String:AnyObject]]
                        let Name = beaconName["name"] as! String
                        // do something with personName and personID
                        print(Name);
                    }
                }
            } catch {
                // handle error
            }
        }
    }
    
}

