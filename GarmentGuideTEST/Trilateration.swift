//
//  Trilateration.swift
//  GarmentGuideTEST
//
//  Modified by Alejandro Inclan on 3/4/19.
//  Created by Tharindu Ketipearachchi on 1/17/18.
//  Copyright © 2018 Tharindu Ketipearachchi. All rights reserved.
//
import UIKit


func normValue(point: (Double,Double)) -> Double {
    var norm:Double?
    norm = pow(pow(point.0, 2) + pow(point.1, 2) , 0.5)
    return norm!
}
    
func trilateration(point1: (Double,Double), point2: (Double,Double), point3: (Double,Double), r1: Double, r2:Double, r3: Double) -> (Double,Double) {
    
    //Unit vector in a direction from point1 to point 2
    let p1p2:Double = pow(pow(point2.0 - point1.0 , 2.0) + pow(point2.1 - point1.1, 2.0), 0.5)
    
    let ex = ((point2.0 - point1.0) / p1p2, (point2.1 - point1.1) / p1p2)
    
    let aux = (point3.0 - point1.0, point3.1 - point1.1)
    
    //Signed magnitude of the x component
    let i: Double = ((ex.0) * (aux.0)) + ((ex.1) * aux.1)
    
    //The unit vector in the y direction.
    let aux2 = (point3.0 - point1.0 - (i * (ex.0)), point3.1 - point1.1 - (i * (ex.1)))
    
    let ey = ((aux2.0) / normValue(point: aux2), (aux2.1) / normValue(point: aux2))
    
    //The signed magnitude of the y component
    let j:Double = ((ey.0) * (aux.0)) + ((ey.1) * (aux.1))
    
    //Coordinates
    let x:Double = (pow(r1, 2) - pow(r2, 2) + pow(p1p2, 2)) / (2 * p1p2)
    let y:Double = ((pow(r1, 2) - pow(r3, 2) + pow(i, 2) + pow(j, 2))/(2 * j)) - (i * x/j)
    
    //Result coordinates
    let finalX:Double = point1.0 + x * ex.0 + y * (ey.0)
    let finalY:Double = point1.1 + x * ex.1 + y * (ey.1)
    
    let location = (finalX, finalY)
    
    return location
}
