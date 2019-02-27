//
//  ViewController.swift
//  GarmentGuideTEST
//
//  Created by Alejandra Sandoval on 2/26/19.
//  Copyright © 2019 Alejandra Sandoval. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var selectl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

 
    @IBAction func bdg1(_ sender: UIButton) {
          selectl.text = "EABA"
        self.performSegue(withIdentifier: "SegueView2", sender: self)
        print("EABA selected")
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

