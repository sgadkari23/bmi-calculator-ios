//
//  ViewController.swift
//  BMICalculator
//  Name: Supriya Gadkari
//  Student Id: 301140872

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
    
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var heightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bmiCalculation = Calculations()
        ref = Database.database().reference()
        weightLabel.text = "kg"
        heightLabel.text = "cm"
    }
    
    // Reset button clicked - reset to default values
    @IBAction func resetCalculation(_ sender: UIButton) {
        userName.text = ""
        userAge.text =  ""
        userGender.text = ""
        userWeight.text = ""
        userHeight.text = ""
        bmiCalculationMessage.text = ""
        bmiCalculation = Calculations()
    }
    
    
    //var bmiCalculation = Calculations()
    @IBAction func calculateBMIOnButtonClicked(_ sender: Any) {
        // Get values from the text boxes
        bmiCalculation.name = userName.text!
        bmiCalculation.age = Int(userAge.text!)!
        bmiCalculation.gender = userGender.text!
        bmiCalculation.height = Double(userHeight.text!)!
        bmiCalculation.weight = Double(userWeight.text!)!
        
        // isMetric Set in segment
        if(bmiCalculation.isMetric == true){
            bmiCalculation.bmiCalculation =  bmiCalculation.weight*100*100/(bmiCalculation.height*bmiCalculation.height)
        }else{
            bmiCalculation.bmiCalculation =  bmiCalculation.weight*703/(bmiCalculation.height*bmiCalculation.height)
        }
        self.bmiCalculation.bmiCalculation = round( self.bmiCalculation.bmiCalculation  * 100) / 100
        
        
        // Calculate bmi range and get message
        switch bmiCalculation.bmiCalculation  {
            case  0.0...16.0 :
                bmiCalculationMessage.text = "BMI:\(bmiCalculation.bmiCalculation) \n Range: Severe Thin"
                
            case  16.0..<17.0:
                bmiCalculationMessage.text = "BMI:\(bmiCalculation.bmiCalculation) \n Range: Moderate Thinness"
                
            case  17...18.5:
                bmiCalculationMessage.text = "BMI:\(bmiCalculation.bmiCalculation) \n Range: Mild Thinness"
               
            case  18.5...25:
                bmiCalculationMessage.text = "BMI:\(bmiCalculation.bmiCalculation) \n Range: Normal"
               
            case  25...30:
                bmiCalculationMessage.text = "BMI:\(bmiCalculation.bmiCalculation) \n Range: Overweight"
              
            case  30...35:
                bmiCalculationMessage.text = "BMI:\(bmiCalculation.bmiCalculation) \n Range: Obese Class I"
               
            case  35...40:
                bmiCalculationMessage.text = "BMI:\(bmiCalculation.bmiCalculation) \n Range: Obese Class II"
               
            case  40...:
                bmiCalculationMessage.text = "BMI:\(bmiCalculation.bmiCalculation) \n Range: Obese Class III"
              
            default:
                break
        }
        
        // Get today's date
        let formater = DateFormatter()
        formater.dateFormat = "MM/dd/yyyy"
        let date = Date()
        let dateString = formater.string(from: date)
        bmiCalculation.dateOfCalculation = dateString
        
        // Generate key for new item in firebase
        let key = ref.child("bmiCalculator").childByAutoId().key
        bmiCalculation.uniqueId = key!
        
        let dictionaryTodo = [ "name"           : bmiCalculation.name,
                               "age"            : bmiCalculation.age ,
                               "gender"         : bmiCalculation.gender,
                               "height"         : bmiCalculation.height,
                               "weight"         : bmiCalculation.weight,
                               "isMetric"       : bmiCalculation.isMetric,
                               "bmiCalculation" : bmiCalculation.bmiCalculation,
                               "dateOfCalculation" : bmiCalculation.dateOfCalculation,
                               "uniqueID"       : bmiCalculation.uniqueId
        ] as [String : Any]
        
        // add to firebase
        ref.child("bmiCalculator").child(key ?? "k1").setValue(dictionaryTodo)
    
    }
    
    // on toggle between segments
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch calculationType.selectedSegmentIndex
        {
            case 0:
                bmiCalculation.isMetric = true
                weightLabel.text = "kg"
                heightLabel.text = "cm"
            case 1: bmiCalculation.isMetric = false
                weightLabel.text = "lbs"
                heightLabel.text = "in"
            default:
                break;
        }
    }
}

