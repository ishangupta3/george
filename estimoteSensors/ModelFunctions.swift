//
//  ModelFunctions.swift
//  estimoteSensors
//
//  Created by ishgupta on 8/3/17.
//  Copyright © 2017 ishgupta. All rights reserved.
//

import Foundation




func  sendDataCheck(timeCounter: Int) -> Bool {
    
    if timeCounter == 3   {
        
     return true
        
        }
    
    
    return false
    
}



func sendAverageCheck(averageCounter: Int) -> Bool {
    
    
    let average = averageCounter / 3
    
    if average >=  -78 {
        
        return true
        
    }
    
    return false
    
    
    
}




func incrementOneFunction(timeIncrementParameter: Int) -> Int {
    
      let  timeIncrementParameter = timeIncrementParameter + 1
        
        return timeIncrementParameter
    
    
    
}
