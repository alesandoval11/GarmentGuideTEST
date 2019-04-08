//
//  ViewController.swift
//  test_cpp_bridge
//
//  Created by Brian Munoz on 4/8/19.
//  Copyright © 2019 Brian Munoz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonPress(_ sender: Any) {
        print("Hello World");
        print("The integer from C++ is \(getIntFromCPP())")
    }
    
}

