//
//  ViewController.swift
//  GarmentGuideTEST
//
//  Created by Alejandra Sandoval on 2/26/19.
//  Copyright © 2019 Alejandra Sandoval. All rights reserved.
//

import UIKit

<<<<<<< HEAD
=======
//Undirected graph
class ViewController: UIViewController {
>>>>>>> Node-Graph

class ViewController: UIViewController {

    @IBOutlet weak var SelectBuildingLabel: UILabel!
    @IBOutlet weak var EABA: UIButton!
    @IBOutlet weak var EABB: UIButton!
    @IBOutlet weak var EABC: UIButton!
    @IBOutlet weak var selectl: UILabel!
  
    var varButtons: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // JSON File to be loaded, creates
        if let path = Bundle.main.path(forResource: "test", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let eaba = jsonResult["eaba"] as? [Any] {
                    // do stuff
                    for beaconName in eaba as! [Dictionary<String, AnyObject>] { // or [[String:AnyObject]]
                        let Name = beaconName["name"] as! String
                        // do something with personName and personID
                        let Coor : NSArray = beaconName["coordinates"] as! NSArray
                        //Step 1: Create Array with names for buttons in Next View
                        varButtons.append(Name)
                       // print(Name)
                        print(Coor)
                        
                    }
                    
                    
                }
                //Step 2: Pass down array to next View
                
            }catch {
                // handle error
                print("Error!")
            }
            
        }
        //print(varButtons)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

 
    @IBAction func bdg1(_ sender: UIButton) {
        selectl.text = "EABA"
        self.performSegue(withIdentifier: "SegueView2", sender: self)
        print("EABA selected")
        
        
    
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //Loads values for secondView//ButtonsInfo
        if segue.destination is secondView
        {
            let vc = segue.destination as? secondView
            vc?.firstLabelButton = varButtons[0]
            vc?.secondLabelButton = varButtons[1]
            vc?.thirdLabelButton = varButtons[2]
            vc?.fourthLabelButton = varButtons[3]
            vc?.fifthLabelButton = varButtons[4]
            print(varButtons)
        
        }
    }
    
    @IBAction func bdg2(_ sender: UIButton) {
        selectl.text = "EABB"
        self.performSegue(withIdentifier: "SegueView3", sender: self)
        print("EABB selected")

    }

    @IBAction func bdg3(_ sender: UIButton) {
        selectl.text = "EABC"
        self.performSegue(withIdentifier: "SegueView4", sender: self)
        print("EABC selected")
        
    }
   
}

