//
//  ViewController.swift
//  GarmentGuideTEST
//
//  Created by Alejandra Sandoval on 2/26/19.
//  Copyright © 2019 Alejandra Sandoval. All rights reserved.
//

import UIKit
import CoreLocation

var orientation: Double = 0
class ViewController: UIViewController, CLLocationManagerDelegate {


    @IBOutlet weak var selectl: UILabel!
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        orientation = newHeading.trueHeading
        //print("Phone Orientation", orientation)
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

