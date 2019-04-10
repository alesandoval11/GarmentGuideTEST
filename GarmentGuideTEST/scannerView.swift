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
                self.textField.text?.append(b.name + "\t" + String(b.RSSI) + " dB\n\tMean:\n\t")
                self.textField.text?.append(String(b.meanRSSI) + " dB\n\tStd Dev:\n\t" + String(b.stdRSSI) + " dB\n")
                self.textField.text?.append(String(b.distance) + " m\n")
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
                if availableBeacons[i].id == beaconInfo.beaconID.description {
                    availableBeacons.remove(at: i)
                    break
                }
            }
        }
        printTable()
    }
    func didUpdateBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        DispatchQueue.main.async {
            if beaconInfo.RSSI != 127 {
                for i in 0...(availableBeacons.count - 1) {
                    if availableBeacons[i].id == beaconInfo.beaconID.description {
                        availableBeacons[i].RSSI = beaconInfo.RSSI
                        if availableBeacons[i].recRSSI.count == recRSSIsize {
                            var sum =  availableBeacons[i].recRSSI.reduce(0,+)
                            var sumStd = 0
                            availableBeacons[i].meanRSSI = sum/recRSSIsize
                            for j in 0...(recRSSIsize - 1) {
                                sumStd += Int(pow((Double(availableBeacons[i].recRSSI[j] - availableBeacons[i].meanRSSI)), 2))
                            }
                            sumStd /= (recRSSIsize - 1)
                            availableBeacons[i].stdRSSI = sqrt(Double(sumStd))
                            
                            sum = 0
                            var k = 0
                            for j in 0...(recRSSIsize - 1) {
                                if (availableBeacons[i].recRSSI[j] < availableBeacons[i].meanRSSI + 2 * Int(availableBeacons[i].stdRSSI)) || (availableBeacons[i].recRSSI[j] > availableBeacons[i].meanRSSI - 2 * Int(availableBeacons[i].stdRSSI)) {
                                    sum += availableBeacons[i].recRSSI[j]
                                    k += 1
                                }
                            }
                            if k != 0 {
                                availableBeacons[i].meanRSSI = sum/k
                                availableBeacons[i].recRSSI.removeAll()
                                availableBeacons[i].distance = pow(10,Double((RSSIm - availableBeacons[i].meanRSSI))/Double((10*pathLoss)))
                            }
                        }
                        availableBeacons[i].recRSSI.append(beaconInfo.RSSI)
                    }
                }
            }
        }
        printTable()
    }
    func didObserveURLBeacon(beaconScanner: BeaconScanner, URL: NSURL, RSSI: Int) {}
}

var beaconNames =   ["f7826da6bc5b71e0893e716e687a6a41": "Beacon1", //kt5lbu | -47
                     "f7826da6bc5b71e0893e6d5271344342": "Beacon2", //ktirna | -49
                     "f7826da6bc5b71e0893e4159776a586c": "Beacon3", //ktt3md | -52
                     "f7826da6bc5b71e0893e37796e48706b": "Beacon4"] //ktdqmh | -52

var availableBeacons = [ParsedBeacon]()
let recRSSIsize = 10
let pathLoss = 2
let RSSIm = -50         //Transmission Power: 3:-77 | 6:-69 | 7:-59

class ParsedBeacon {
    let name: String
    let id: String
    var RSSI: Int
    var recRSSI = [Int]()
    var meanRSSI: Int
    var stdRSSI: Double
    var distance: Double
    
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
        
        if (bInfo.RSSI != 127)
        {
            self.recRSSI.append(bInfo.RSSI)
        }
        self.meanRSSI = 0
        self.stdRSSI = 0
        self.distance = -1
    }
}
