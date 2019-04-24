//
//  secondView.swift
//  GarmentGuideTEST
//
//  Created by Alejandra Sandoval on 2/26/19.
//  Copyright © 2019 Alejandra Sandoval. All rights reserved.
//
import UIKit


class secondView: UIViewController {
    
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
        print("Button for \(firstLabelButton) pressed")
        destination = [2422,1520]
        self.performSegue(withIdentifier: "toScanner", sender: self)

    }
    @IBAction func secondButtonAct(_ sender: Any) {
        print("Button for \(secondLabelButton) pressed")
        destination = [2629,244]
        self.performSegue(withIdentifier: "toScanner", sender: self)

    }
    @IBAction func thirdButtonAct(_ sender: Any) {
        print("Button for \(thirdLabelButton) pressed")
        destination = [2430,2409]
        self.performSegue(withIdentifier: "toScanner", sender: self)

    }
    @IBAction func fourthButtonAct(_ sender: Any) {
        print("Button for \(fourthLabelButton) pressed")
        destination = [1424,2220]
        self.performSegue(withIdentifier: "toScanner", sender: self)

    }
    @IBAction func fifthButtonAct(_ sender: Any) {
        print("Button for \(fifthLabelButton) pressed")
        destination = [1701,2220]
        self.performSegue(withIdentifier: "toScanner", sender: self)

    }
    @IBAction func sixthButtonAct(_ sender: Any) {
        print("Button for \(sixthLabelButton) pressed")
        destination = [1300,1993]
        self.performSegue(withIdentifier: "toScanner", sender: self)
        
    }
    @IBAction func seventhButtonAct(_ sender: Any) {
        print("Button for \(seventhLabelButton) pressed")
        destination = [1130,1993]
        self.performSegue(withIdentifier: "toScanner", sender: self)
        
    }
    @IBAction func eigthButtonAct(_ sender: Any) {
        print("Button for \(eigthLabelButton) pressed")
        destination = [1392,1576]
        self.performSegue(withIdentifier: "toScanner", sender: self)
        
    }
}

