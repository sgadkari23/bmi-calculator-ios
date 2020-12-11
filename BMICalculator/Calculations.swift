//
//  Calculations.swift
//  BMICalculator
//
//  Created by Girish Dhoble on 12/9/20.
//

import Foundation
class Calculations: NSObject {
    var name :String
    var age: Int
    var gender: String
    var isMetric: Bool
    var weight:Double
    var height:Double
    var bmiCalculation:Double
    var uniqueId:String
    var dateOfCalculation: String
    
    init( name: String, age: Int, gender: String, isMetric: Bool, weight: Double, height: Double, bmiCalculation:Double, uniqueId:String, dateOfCalculation:String) {
            self.name = name
            self.age = age
            self.gender = gender
            self.isMetric = isMetric
            self.weight = weight
            self.height = height
            self.bmiCalculation = bmiCalculation
            self.uniqueId = uniqueId
            self.dateOfCalculation = dateOfCalculation
    }
    
    init(key: String, bmi: NSDictionary) {
        self.name = bmi["name"] as! String
        self.age = bmi["age"] as! Int
        self.gender = bmi["gender"] as! String
        self.isMetric = bmi["isMetric"] as! Bool
        self.bmiCalculation = bmi["bmiCalculation"] as! Double
        self.height = bmi["height"] as! Double
        self.weight = bmi["weight"] as! Double
        self.uniqueId = key
        self.dateOfCalculation = bmi["dateOfCalculation"] as! String
    }

    convenience override init() {
        self.init(name: "", age: 0, gender: "" , isMetric: true, weight: 0.0, height: 0.0, bmiCalculation:0.0, uniqueId:"", dateOfCalculation:"")
    }
}
