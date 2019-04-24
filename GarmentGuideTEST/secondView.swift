//
//  secondView.swift
//  GarmentGuideTEST
//
//  Created by Alejandra Sandoval on 2/26/19.
//  Copyright © 2019 Alejandra Sandoval. All rights reserved.
//
import UIKit


class secondView: UIViewController {
    var labelInt = 0
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is option1
        {
            let vc = segue.destination as? option1
            
            
            switch labelInt {
            case 1:
                vc?.dLabel = varButtons[0]
                
                
                
                break
            case 2:
                vc?.dLabel = varButtons[1]
                
                break
            case 3:
                vc?.dLabel = varButtons[2]
                break
            case 4:
                vc?.dLabel = varButtons[3]
                break
            case 5:
                vc?.dLabel = varButtons[4]
                
                break
            case 6:
                vc?.dLabel = varButtons[5]
                break
            case 7:
                vc?.dLabel = varButtons[6]
                
                break
            case 8:
                vc?.dLabel = varButtons[7]
                break
            default:
                vc?.dLabel = "Hello World"
                break
            }
        }
    }
    var firstLabelButton:String = ""
    var secondLabelButton:String = ""
    var thirdLabelButton:String = ""
    var fourthLabelButton:String = ""
    var fifthLabelButton:String = ""
    var sixthLabelButton:String = ""
    var seventhLabelButton:String = ""
    var eigthLabelButton:String = ""
    
    @IBOutlet weak var firstLabel: UIButton!
    @IBOutlet weak var secondLabel: UIButton!
    @IBOutlet weak var thirdLabel: UIButton!
    @IBOutlet weak var fourthLabel: UIButton!
    @IBOutlet weak var fifthLabel: UIButton!
    @IBOutlet weak var sixthLabel: UIButton!
    @IBOutlet weak var seventhLabel: UIButton!
    @IBOutlet weak var eigthLabel: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Changes the labels of the buttons to whatever was sent from the JSON
        firstLabel.setTitle( firstLabelButton , for: .normal )
        secondLabel.setTitle( secondLabelButton , for: .normal )
        thirdLabel.setTitle( thirdLabelButton , for: .normal )
        fourthLabel.setTitle( fourthLabelButton , for: .normal )
        fifthLabel.setTitle( fifthLabelButton , for: .normal )
         sixthLabel.setTitle( sixthLabelButton , for: .normal )
         seventhLabel.setTitle( seventhLabelButton , for: .normal )
         eigthLabel.setTitle( eigthLabelButton , for: .normal )
    }
    

   
    @IBAction func backHome2(_ sender: UIButton) {
       
        self.performSegue(withIdentifier: "home2", sender: self)
    }
    
    //Action of Buttons
    @IBAction func firstButtonAct(_ sender: Any) {
        labelInt = 1
        print("Button for \(firstLabelButton) pressed")
        destination = [2422,1520]
        self.performSegue(withIdentifier: "toScanner", sender: self)

    }
    @IBAction func secondButtonAct(_ sender: Any) {
        labelInt = 2
        print("Button for \(secondLabelButton) pressed")
        destination = [2629,244]
        self.performSegue(withIdentifier: "toScanner", sender: self)

    }
    @IBAction func thirdButtonAct(_ sender: Any) {
        labelInt = 3
        print("Button for \(thirdLabelButton) pressed")
        destination = [2430,2409]
        self.performSegue(withIdentifier: "toScanner", sender: self)

    }
    @IBAction func fourthButtonAct(_ sender: Any) {
        labelInt = 4
        print("Button for \(fourthLabelButton) pressed")
        destination = [1424,2220]
        self.performSegue(withIdentifier: "toScanner", sender: self)

    }
    @IBAction func fifthButtonAct(_ sender: Any) {
        labelInt = 5
        print("Button for \(fifthLabelButton) pressed")
        destination = [1701,2220]
        self.performSegue(withIdentifier: "toScanner", sender: self)

    }
    @IBAction func sixthButtonAct(_ sender: Any) {
        labelInt = 6
        print("Button for \(sixthLabelButton) pressed")
        destination = [1300,1993]
        self.performSegue(withIdentifier: "toScanner", sender: self)
        
    }
    @IBAction func seventhButtonAct(_ sender: Any) {
        labelInt = 7
        print("Button for \(seventhLabelButton) pressed")
        destination = [1130,1993]
        self.performSegue(withIdentifier: "toScanner", sender: self)
        
    }
    @IBAction func eigthButtonAct(_ sender: Any) {
        labelInt = 8
        print("Button for \(eigthLabelButton) pressed")
        destination = [1392,1576]
        self.performSegue(withIdentifier: "toScanner", sender: self)
        
    }
}

