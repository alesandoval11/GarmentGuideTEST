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
    
    @IBOutlet weak var textField: UITextView!
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
        textField.text += "FIND: " + beaconInfo.description + "\n"
    }
    func didLoseBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        textField.text += "LOST: " + beaconInfo.description + "\n"
    }
    func didUpdateBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        textField.text += "UPDATE: " + beaconInfo.description + "\n"
    }
    func didObserveURLBeacon(beaconScanner: BeaconScanner, URL: NSURL, RSSI: Int) {
        textField.text += "RSSI: " + String(RSSI) + "\n"
    }
}
