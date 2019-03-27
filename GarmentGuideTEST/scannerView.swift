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
        textField.text = ""
        self.beaconScanner = BeaconScanner()
        self.beaconScanner!.delegate = self
        self.beaconScanner!.startScanning()
        
    }
    
    func printTable() {
        DispatchQueue.main.async {
            self.textField.text? = ""
            
            for b in availableBeacons{
                self.textField.text?.append(b.name + "\t" + String(b.RSSI) + " dB" + "\n")
            }
            
            if availableBeacons.count == 0 {
                let n = stats.count
                let max = stats.max()!
                let min = stats.min()!
                let sum = stats.reduce(0,+)
                var mean = sum/n
                let countedSet = NSCountedSet(array: stats)
                let mostFrequent: Int = countedSet.max { countedSet.count(for: $0) < countedSet.count(for: $1) } as! Int
                stats.removeAll(keepingCapacity: false)
                DispatchQueue.main.async {
                    self.textField.text? = ""
                    self.textField!.text?.append("Max:\t" + String(max) + " dB\nMin:   \t" + String(min) + " dB\nMean:\t")
                    self.textField.text?.append(String(mean) + " dB\nMode:\t" + String(mostFrequent) + " dB\nN:      \t" + String(n))
                }
                
            }
        }
    }
    
    func didFindBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        availableBeacons.append(ParsedBeacon(bInfo: beaconInfo))
        printTable()
    }
    func didLoseBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        DispatchQueue.main.async {
            for i in 0...(availableBeacons.count - 1){
                if availableBeacons[i].id == beaconInfo.beaconID.description{
                    availableBeacons.remove(at: i)
                    break
                }
            }
        }
        printTable()
    }
    func didUpdateBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        if beaconInfo.RSSI != 127 {
            for i in 0...(availableBeacons.count - 1){
                if availableBeacons[i].id == beaconInfo.beaconID.description{
                    availableBeacons[i].RSSI = beaconInfo.RSSI
                    stats.append(Int(availableBeacons[i].RSSI)) // debug
                }
            }
        }
        printTable()
    }
    func didObserveURLBeacon(beaconScanner: BeaconScanner, URL: NSURL, RSSI: Int) {}
    
    /*
    func didFindBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
     
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
 */
}

var beaconNames =   ["f7826da6bc5b71e0893e716e687a6a41": "Beacon1",
                     "f7826da6bc5b71e0893e6d5271344342": "Beacon2",
                     "f7826da6bc5b71e0893e4159776a586c": "Beacon3",
                     "f7826da6bc5b71e0893e37796e48706b": "Beacon4"]

var availableBeacons = [ParsedBeacon]()
var stats = [Int]() // debug

class ParsedBeacon {
    let name: String
    let id: String
    var RSSI: Int
    
    init (bInfo: BeaconInfo){
        self.id = bInfo.beaconID.description
        self.RSSI = bInfo.RSSI
        if beaconNames[bInfo.beaconID.description] != nil
        {
            self.name = beaconNames[bInfo.beaconID.description]!
        }
        else
        {
            self.name = "Unknown"
        }
    }
}
