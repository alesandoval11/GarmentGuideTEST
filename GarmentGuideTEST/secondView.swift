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
   
 

    @IBOutlet weak var firstLabel: UIButton!
    @IBOutlet weak var secondLabel: UIButton!
    @IBOutlet weak var thirdLabel: UIButton!
    @IBOutlet weak var fourthLabel: UIButton!
    @IBOutlet weak var fifthLabel: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Changes the labels of the buttons to whatever was sent from the JSON
        firstLabel.setTitle( firstLabelButton , for: .normal )
        secondLabel.setTitle( secondLabelButton , for: .normal )
        thirdLabel.setTitle( thirdLabelButton , for: .normal )
        fourthLabel.setTitle( fourthLabelButton , for: .normal )
        fifthLabel.setTitle( fifthLabelButton , for: .normal )
    }
    

   
    @IBAction func backHome2(_ sender: UIButton) {
        self.performSegue(withIdentifier: "home2", sender: self)
    }
    
    //Action of Buttons
    @IBAction func firstButtonAct(_ sender: Any) {
        print("Button for \(firstLabelButton) pressed")
    }
    @IBAction func secondButtonAct(_ sender: UIButton) {
       print("Button for \(secondLabelButton) pressed")
    }
    @IBAction func thirdButtonAct(_ sender: UIButton) {
        print("Button for \(thirdLabelButton) pressed")
    }
    @IBAction func fourthButtonAct(_ sender: UIButton) {
            print("Button for \(fourthLabelButton) pressed")
    }
    @IBAction func fifthButtonAct(_ sender: Any) {
         print("Button for \(fifthLabelButton) pressed")
    }
}

