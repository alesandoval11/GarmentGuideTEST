//
//  secondView.swift
//  GarmentGuideTEST
//
//  Created by Alejandra Sandoval on 2/26/19.
//  Copyright © 2019 Alejandra Sandoval. All rights reserved.
//
import UIKit

class secondView: UIViewController {
    
 
    @IBAction func backHome2(_ sender: UIButton) {
        self.performSegue(withIdentifier: "home2", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
}

