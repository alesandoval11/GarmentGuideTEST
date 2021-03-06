//
//  beaconScanner.swift
//  GarmentGuideTEST
//
//  Created by Ray Kim on 3/20/19.
//  Copyright © 2019 Alejandra Sandoval. All rights reserved.
//
import Foundation
import UIKit

class scannerView: UIViewController, BeaconScannerDelegate {
    
    var beaconScanner: BeaconScanner!
    @IBAction override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createNodes(fileName: "beacon1", fileType:"json")
        createZones(fileName:"zone", fileType:"json")
        //send START ROUTE packet
        self.beaconScanner = BeaconScanner()
        self.beaconScanner!.delegate = self
        self.beaconScanner!.startScanning()
        
    }
    
    func trilaterate(){
        availableBeacons.sort(by: {$0.distance < $1.distance})
        if (availableBeacons[0].distance != Double.infinity && availableBeacons[1].distance != Double.infinity && availableBeacons[2].distance != Double.infinity) {
            let loc: (Double, Double) = trilateration(point1: availableBeacons[0].loc, point2: availableBeacons[1].loc, point3: availableBeacons[2].loc, r1: availableBeacons[0].distance, r2: availableBeacons[1].distance, r3: availableBeacons[2].distance)
            print (loc)
            if (!loc.0.isNaN && !loc.1.isNaN) {
                findPath(start: [Int(loc.0),Int(loc.1)], end: [destination[0],destination[1]])
                if (abs(loc.0 - Double(destination[0])) < err && abs(loc.1 - Double(destination[1])) < err) {
                    self.beaconScanner.stopScanning()
                    //finished alert
                    let alert = UIAlertController(title: "Routing Complete!", message: "You have arrived at your destination.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    //send END ROUTE packet
                    //exit
                    
                }
            }
        }
    }
    
    func didFindBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        availableBeacons.append(ParsedBeacon(bInfo: beaconInfo))
    }
    func didLoseBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        for i in 0...(availableBeacons.count - 1){
            if availableBeacons[i].id == beaconInfo.beaconID.description {
                availableBeacons.remove(at: i)
                break
            }
        }
    }
    func didUpdateBeacon(beaconScanner: BeaconScanner, beaconInfo: BeaconInfo) {
        if beaconInfo.RSSI != 127 && beaconInfo.RSSI >= -75{
            for i in 0...(availableBeacons.count - 1) {
                if availableBeacons[i].id == beaconInfo.beaconID.description {
                    availableBeacons[i].RSSI = beaconInfo.RSSI
                    
                    if availableBeacons[i].recRSSI.count == recRSSIsize {
                        if (availableBeacons[i].repI == 10) {
                            availableBeacons[i].repI = 0 // reset replace index
                            availableBeacons[i].repHalf = 1 - availableBeacons[i].repHalf // switch sides
                            
                            // calculate statistics
                            var sum =  availableBeacons[i].recRSSI.reduce(0,+)
                            var sumStd = 0.0
                            availableBeacons[i].meanRSSI = sum/recRSSIsize
                            for j in 0...(recRSSIsize - 1) {
                                sumStd += pow((Double(availableBeacons[i].recRSSI[j] - availableBeacons[i].meanRSSI)), 2)
                            }
                            sumStd /= Double(recRSSIsize)
                            if sumStd == 0.0 {
                            }
                            availableBeacons[i].stdRSSI = sqrt(Double(sumStd))
                            
                            sum = 0
                            var k = 0
                            for j in 0...(recRSSIsize - 1) {
                                if (availableBeacons[i].recRSSI[j] <= availableBeacons[i].meanRSSI + Int(1.5 * availableBeacons[i].stdRSSI)) && (availableBeacons[i].recRSSI[j] >= availableBeacons[i].meanRSSI - Int(1.5 * availableBeacons[i].stdRSSI)) {
                                    sum += availableBeacons[i].recRSSI[j]
                                    k += 1
                                }
                            }
                            if k != 0 {
                                availableBeacons[i].meanRSSI = sum/k
                                availableBeacons[i].distance = pow(10,Double((RSSIm - availableBeacons[i].meanRSSI))/Double((10*pathLoss)))
                            }
                            trilaterate()
                        }
                        else { //
                            if availableBeacons[i].repHalf == 0 {
                                availableBeacons[i].recRSSI[availableBeacons[i].repI] = beaconInfo.RSSI
                            }
                            else {// repHalf == 1
                                availableBeacons[i].recRSSI[availableBeacons[i].repI + 10] = beaconInfo.RSSI
                            }
                            availableBeacons[i].repI += 1
                        }
                    }
                    else{
                        availableBeacons[i].recRSSI.append(beaconInfo.RSSI)
                    }
                    break
                    
                    
                }
            }
        }
    }
    func didObserveURLBeacon(beaconScanner: BeaconScanner, URL: NSURL, RSSI: Int) {}
}

var beaconNames =   [
    "f7826da6bc5b71e0893e716e687a6a41": ("Beacon1",(2629.0,255.0)), //kt5lbu | -47
    "f7826da6bc5b71e0893e6d5271344342": ("Beacon2",(2863.0,583.0)), //ktirna | -49
    "f7826da6bc5b71e0893e4159776a586c": ("Beacon3",(2884.0,803.0)), //ktt3md | -52
    "f7826da6bc5b71e0893e37796e48706b": ("Beacon4",(2863.0,1250.0)), //ktdqmh | -52
    "f7826da6bc5b71e0893e4462626b7941": ("Beacon5",(2663.0,1575.0)), //kttXhOR
    "f7826da6bc5b71e0893e75536b477358": ("Beacon6",(2395.0,1249.0)), //ktGPkl
    "f7826da6bc5b71e0893e37464d7a6b55": ("Beacon7",(2395.0,916.0)), //ktR0kL
    "f7826da6bc5b71e0893e754467325767": ("Beacon8",(0.0,0.0)), //ktfLGV *outofrange
    "f7826da6bc5b71e0893e6a5a484d6275": ("Beacon9",(2395.0,583.0)), //ktKaD3
    "f7826da6bc5b71e0893e645466473973": ("Beacon10",(2361.0,1715.0)), //kt4a1M
    "f7826da6bc5b71e0893e656e30484e66": ("Beacon11",(2725.0,1718.0)), //kt3i37
    "f7826da6bc5b71e0893e68746f487439": ("Beacon12",(2551.0,1589.0)), //kt1akb
    "f7826da6bc5b71e0893e52794d4d724d": ("Beacon13",(1748.0,2039.0)), //kt2jxG
    "f7826da6bc5b71e0893e507663455335": ("Beacon14",(1377.0,2052.0)), //ktrbWT
    "f7826da6bc5b71e0893e5a3474695246": ("Beacon15",(1564.0,1865.0)), //ktgyji
    "f7826da6bc5b71e0893e725349586e56": ("Beacon16",(1513.0,2439.0)), //mt2RJW
    "f7826da6bc5b71e0893e45385a756f4b": ("Beacon17",(2477.0,2406.0)), //mteqpI
    "f7826da6bc5b71e0893e4e4f61747876": ("Beacon18",(2367.0,2198.0)), //mtyV05
    "f7826da6bc5b71e0893e784148616a38": ("Beacon19",(1565.0,1712.0)), //mttetJ
    "f7826da6bc5b71e0893e6e4779515537": ("Beacon20",(1276.0,1749.0)), //mtUUEw
    "f7826da6bc5b71e0893e617733454b6c": ("Beacon21",(1297.0,1742.0)), //mtdlaW
    "f7826da6bc5b71e0893e416e41375578": ("Beacon22",(1446.0,1844.0)), //mtBS7c
    "f7826da6bc5b71e0893e507875446d43": ("Beacon23",(2536.0,2073.0)), //mtZPoV
    "f7826da6bc5b71e0893e4f396d376864": ("Beacon24",(2485.0,1928.0)), //mth2ir
    "f7826da6bc5b71e0893e6d69514e7a76": ("Beacon25",(2212.0,1992.0)), //mty8KQ
    "f7826da6bc5b71e0893e49586b426a38": ("Beacon26",(1966.0,1865.0)), //mtyNt3
    "f7826da6bc5b71e0893e516c4e6f4531": ("Beacon27",(1846.0,1992.0)), //mtDaBQ
    "f7826da6bc5b71e0893e64594b44346b": ("Beacon28",(1227.0,1992.0)), //mtAu10
    "f7826da6bc5b71e0893e6c566d504459": ("Beacon29",(1343.0,1865.0)), //mtv1Ns
    "f7826da6bc5b71e0893e4f5238783842": ("Beacon30",(1116.0,1865.0)) //mtmhoU
]

var availableBeacons = [ParsedBeacon]()
let recRSSIsize = 20
let pathLoss = 1.4 //Rise:2.75     //2-3
let RSSIm = -48         //Transmission Power: 3:-77 | 6:-69 | 7:-59
var destination: [Int] = [2422,1520]
let err = 63.0          //1 meter
class ParsedBeacon {
    let name: String
    let id: String
    let loc: (Double, Double)
    var RSSI: Int
    var recRSSI = [Int]()
    var meanRSSI: Int
    var stdRSSI: Double
    var distance: Double
    var repHalf: Int
    var repI: Int
    
    init (bInfo: BeaconInfo){
        self.id = bInfo.beaconID.description
        self.RSSI = bInfo.RSSI
        if beaconNames[bInfo.beaconID.description] != nil
        {
            self.name = (beaconNames[bInfo.beaconID.description]?.0 ?? "Unknown")!
            self.loc = (beaconNames[bInfo.beaconID.description]?.1 ?? (0,0))!
        }
        else
        {
            self.name = "Unknown"
            self.loc = (0,0)
            
        }
        
        if (bInfo.RSSI != 127)
        {
            self.recRSSI.append(bInfo.RSSI)
        }
        self.meanRSSI = 0
        self.stdRSSI = 0
        self.repHalf = 1
        self.repI = 10
        self.distance = Double.infinity
    }
}
