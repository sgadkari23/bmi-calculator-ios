//
//  Calculations.swift
//  BMICalculator
//
//  Created by Girish Dhoble on 12/9/20.
//

import Foundation
class Calculations: NSObject {
    var name :String
    var age: String
    var gender: String
    var isMetric: Bool
    var weight:Double
    var height:Double
    var finalBMICalculation:Double
    var uniqueId:String
    
    init( name: String, age: String, gender: String, isMetric: Bool, weight: Double, height: Double, finalBMICalculation:Double, uniqueId:String) {
            self.name = name
            self.age = age
            self.gender = gender
            self.isMetric = isMetric
            self.weight = weight
            self.height = height
            self.finalBMICalculation = finalBMICalculation
            self.uniqueId = uniqueId
    }

    convenience override init() {
        self.init(name: "", age: "", gender: "" , isMetric: true, weight: 0.0, height: 0.0, finalBMICalculation:0.0, uniqueId:"")
    }
}
