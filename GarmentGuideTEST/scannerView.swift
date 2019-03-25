//
//  beaconScanner.swift
//  GarmentGuideTEST
//
//  Created by Ray Kim on 3/20/19.
//  Copyright © 2019 Alejandra Sandoval. All rights reserved.
//

import Foundation
import UIKit

class scannerView: UIViewController, UITextFieldDelegate, BeaconScannerDelegate {
    
    @IBOutlet weak var textField: UITextField!
    var beaconScanner: BeaconScanner!
    @IBAction override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textField.text = "Test \n"
        self.beaconScanner = BeaconScanner()
        self.beaconScanner!.delegate = self
        self.beaconScanner!.startScanning()
        
    }
    
    func didFindBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        DispatchQueue.main.async {
        self.textField.text?.append("FIND: " + beaconInfo.description + "\n\n")
        }
    }
    func didLoseBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        DispatchQueue.main.async {
            self.textField.text?.append("LOST: " + beaconInfo.description + "\n\n")
        }
    }
    func didUpdateBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        DispatchQueue.main.async {
            self.textField.text?.append("UPDATE: " + beaconInfo.description + "\n\n")
        }
    }
    func didObserveURLBeacon(beaconScanner: BeaconScanner, URL: NSURL, RSSI: Int) {
        DispatchQueue.main.async {
            //self.textField.text?.append("RSSI: " + String(RSSI) + "\n\n")
        }
    }
}
