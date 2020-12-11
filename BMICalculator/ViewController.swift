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
        bmiCalculation = Calculations()
    }
    
    @IBAction func resetCalculation(_ sender: UIButton) {
        
        userName.text = ""
        userAge.text =  ""
        userGender.text = ""
        userWeight.text = ""
        userHeight.text = ""
        bmiCalculationMessage.text = ""
    }
    
    
    //var bmiCalculation = Calculations()
    @IBAction func calculateBMIOnButtonClicked(_ sender: Any) {
        //print(userName.text as Any)
        
        bmiCalculation.name = userName.text!
        bmiCalculation.age = userAge.text!
        bmiCalculation.gender = userGender.text!
        bmiCalculation.height = Double(userHeight.text!)!
        bmiCalculation.weight = Double(userWeight.text!)!
        print(bmiCalculation.height)
        print(bmiCalculation.weight)
        
        if(bmiCalculation.isMetric == true){
            bmiCalculation.finalBMICalculation =  bmiCalculation.weight*100*100/(bmiCalculation.height*bmiCalculation.height)
        }else{
            bmiCalculation.finalBMICalculation =  bmiCalculation.weight*703/(bmiCalculation.height*bmiCalculation.height)
        }
        print(bmiCalculation.finalBMICalculation)
        
        switch bmiCalculation.finalBMICalculation  {
        case  0.0...16.0 :
            bmiCalculationMessage.text = "Severe Thin"
            break
        case  16.0..<17.0:
            bmiCalculationMessage.text = "Moderate Thinness"
            break
        case  17...18.5:
            bmiCalculationMessage.text = "Mild Thinness"
            break
        case  18.5...25:
            bmiCalculationMessage.text = "Normal"
            break
        case  25...30:
            bmiCalculationMessage.text = "Overweight"
            break
        case  30...35:
            bmiCalculationMessage.text = "Obese Class I"
            break
        case  35...40:
            bmiCalculationMessage.text = "Obese Class II"
            break
        case  40...:
            bmiCalculationMessage.text = "Obese Class III"
            break
        default:
            break
        }
        
        let formater = DateFormatter()
        formater.dateFormat = "MM/dd/yyyy"
        
        let key = ref.child("BMICalculator").childByAutoId().key
        
        let dictionaryTodo = [ "name"           : bmiCalculation.name,
                               "age"            : bmiCalculation.age ,
                               "gender "        : bmiCalculation.gender,
                               "height"         : bmiCalculation.height,
                               "weight"         : bmiCalculation.weight,
                               "isMetric"       : bmiCalculation.isMetric,
                               "bmiCalculation" : bmiCalculation.finalBMICalculation,
                               "dateOfCalculation" :
                               "uniqueID"       : bmiCalculation.uniqueId
        ] as [String : Any]
        
        ref.child("BMICalculator").child(key ?? "k1").setValue(dictionaryTodo)
    
        print("data saved")
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
        print(calculationType.selectedSegmentIndex)
        print("bmiCalculation.isMetric \(bmiCalculation.isMetric)")
        switch calculationType.selectedSegmentIndex
        {
        case 0: bmiCalculation.isMetric = true
        case 1: bmiCalculation.isMetric = false
        default:
            break;
        }
    }
    
    
   
    
}

