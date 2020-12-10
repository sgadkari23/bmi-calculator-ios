//
//  ViewController.swift
//  BMICalculator
//  Name: Supriya Gadkari
//  Student Id: 301140872
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var bmiCalculation:Calculations!
    @IBOutlet var calculationType: UISegmentedControl!
    var ref: DatabaseReference!
    
    @IBOutlet var userName: UITextField!
    @IBOutlet var userAge: UITextField!
    @IBOutlet var userGender: UITextField!
    @IBOutlet var userWeight: UITextField!
    @IBOutlet var userHeight: UITextField!
    @IBOutlet var bmiCalculationMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //var bmiCalculation = Calculations()
    @IBAction func Calculate(_ sender: Any) {
        
        bmiCalculation.name = userName.text!
        bmiCalculation.age = userAge.text!
        bmiCalculation.gender = userGender.text!
        bmiCalculation.height = Double(userHeight.text!)!
        bmiCalculation.weight = Double(userWeight.text!)!
        if(bmiCalculation.isMetric == true){
            bmiCalculation.finalBMICalculation =  bmiCalculation.weight*703/bmiCalculation.height*bmiCalculation.height
        }else{
            bmiCalculation.finalBMICalculation =  bmiCalculation.weight/bmiCalculation.height*bmiCalculation.height
        }
        
        switch bmiCalculation.finalBMICalculation  {
        case  0.0...16.0 :
            bmiCalculationMessage.text = "Severe Thin"
        case  16.0..<17.0:
            bmiCalculationMessage.text = "Moderate Thinness"
        case  17...18.5:
            bmiCalculationMessage.text = "Mild Thinness"
        case  18.5...25:
            bmiCalculationMessage.text = "Normal"
        case  25...30:
            bmiCalculationMessage.text = "Overweight"
        case  30...35:
            bmiCalculationMessage.text = "Obese Class I"
        case  35...40:
            bmiCalculationMessage.text = "Obese Class II"
        case  40...:
            bmiCalculationMessage.text = "Obese Class III"
        default:
            break
        }
        
        
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
        print(calculationType.selectedSegmentIndex)
        
        switch calculationType.selectedSegmentIndex
        {
        case 0: bmiCalculation.isMetric = true
        case 1: bmiCalculation.isMetric = false
        default:
            break;
        }
    }
}

