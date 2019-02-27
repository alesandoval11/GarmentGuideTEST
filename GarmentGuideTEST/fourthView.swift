//
//  fourthView.swift
//  GarmentGuideTEST
//
//  Created by Alejandra Sandoval on 2/26/19.
//  Copyright © 2019 Alejandra Sandoval. All rights reserved.
//

import UIKit

class fourthView: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
   
    @IBAction func backHome4(_ sender: UIButton) {
         self.performSegue(withIdentifier: "home4", sender: self)
    }
    
}
