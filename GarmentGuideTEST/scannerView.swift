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
        //DispatchQueue.main.async {
            for i in 0...(availableBeacons.count - 1){
                if availableBeacons[i].id == beaconInfo.beaconID.description {
                    availableBeacons.remove(at: i)
                    break
                }
            }
        //}
        printTable()
    }
    func didUpdateBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
      //  DispatchQueue.main.async {
            if beaconInfo.RSSI != 127 && beaconInfo.RSSI >= -90{
                for i in 0...(availableBeacons.count - 1) {
                    if availableBeacons[i].id == beaconInfo.beaconID.description {
                        availableBeacons[i].RSSI = beaconInfo.RSSI
                        if availableBeacons[i].recRSSI.count == recRSSIsize {
                            var sum =  availableBeacons[i].recRSSI.reduce(0,+)
                            var sumStd = 0.0
                            availableBeacons[i].meanRSSI = sum/recRSSIsize
                            for j in 0...(recRSSIsize - 1) {
                                sumStd += pow((Double(availableBeacons[i].recRSSI[j] - availableBeacons[i].meanRSSI)), 2)
                            }
                            sumStd /= Double(recRSSIsize)
                            if sumStd == 0.0 {
                                print("sumStd == 0")
                            }
                            availableBeacons[i].stdRSSI = sqrt(Double(sumStd))
                            
                            sum = 0
                            var k = 0
                            for j in 0...(recRSSIsize - 1) {
                                if (availableBeacons[i].recRSSI[j] <= availableBeacons[i].meanRSSI + Int(1 * availableBeacons[i].stdRSSI)) && (availableBeacons[i].recRSSI[j] >= availableBeacons[i].meanRSSI - Int(1 * availableBeacons[i].stdRSSI)) {
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
                        break
                    }
                }
            }
       // }
        printTable()
    }
    func didObserveURLBeacon(beaconScanner: BeaconScanner, URL: NSURL, RSSI: Int) {}
}

var beaconNames =   [
    "f7826da6bc5b71e0893e716e687a6a41": "Beacon1", //kt5lbu | -47
    "f7826da6bc5b71e0893e6d5271344342": "Beacon2", //ktirna | -49
    "f7826da6bc5b71e0893e4159776a586c": "Beacon3", //ktt3md | -52
    "f7826da6bc5b71e0893e37796e48706b": "Beacon4", //ktdqmh | -52
    "f7826da6bc5b71e0893e4462626b7941": "Beacon5", //kttXhOR
    "f7826da6bc5b71e0893e75536b477358": "Beacon6", //ktGPkl
    "f7826da6bc5b71e0893e37464d7a6b55": "Beacon7", //ktR0kL
    "f7826da6bc5b71e0893e754467325767": "Beacon8", //ktfLGV *outofrange
    "f7826da6bc5b71e0893e6a5a484d6275": "Beacon9", //ktKaD3
    "f7826da6bc5b71e0893e645466473973": "Beacon10", //kt4a1M
    "f7826da6bc5b71e0893e656e30484e66": "Beacon11", //kt3i37
    "f7826da6bc5b71e0893e68746f487439": "Beacon12", //kt1akb
    "f7826da6bc5b71e0893e52794d4d724d": "Beacon13", //kt2jxG
    "f7826da6bc5b71e0893e507663455335": "Beacon14", //ktrbWT
    "f7826da6bc5b71e0893e5a3474695246": "Beacon15", //ktgyji
    "f7826da6bc5b71e0893e725349586e56": "Beacon16", //mt2RJW
    "f7826da6bc5b71e0893e45385a756f4b": "Beacon17", //mteqpI
    "f7826da6bc5b71e0893e4e4f61747876": "Beacon18", //mtyV05
    "f7826da6bc5b71e0893e784148616a38": "Beacon19", //mttetJ
    "f7826da6bc5b71e0893e6e4779515537": "Beacon20", //mtUUEw
    "f7826da6bc5b71e0893e617733454b6c": "Beacon21", //mtdlaW
    "f7826da6bc5b71e0893e416e41375578": "Beacon22", //mtBS7c
    "f7826da6bc5b71e0893e507875446d43": "Beacon23", //mtZPoV
    "f7826da6bc5b71e0893e4f396d376864": "Beacon24", //mth2ir
    "f7826da6bc5b71e0893e6d69514e7a76": "Beacon25", //mty8KQ
    "f7826da6bc5b71e0893e49586b426a38": "Beacon26", //mtyNt3
    "f7826da6bc5b71e0893e516c4e6f4531": "Beacon27", //mtDaBQ
    "f7826da6bc5b71e0893e64594b44346b": "Beacon28", //mtAu10
    "f7826da6bc5b71e0893e6c566d504459": "Beacon29", //mtv1Ns
    "f7826da6bc5b71e0893e4f5238783842": "Beacon30" //mtmhoU
    ]

var availableBeacons = [ParsedBeacon]()
let recRSSIsize = 20
let pathLoss = 1.4 //Rise:2.75     //2-3
let RSSIm = -48         //Transmission Power: 3:-77 | 6:-69 | 7:-59

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
