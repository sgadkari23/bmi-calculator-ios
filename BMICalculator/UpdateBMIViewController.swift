//
//  UpdateBMIViewController.swift
//  BMICalculator
//  Name: Supriya Gadkari
//  Student Id: 301140872
//  BMI calculation update screen

import UIKit
import Firebase

class UpdateBMIViewController: UIViewController {

    @IBOutlet var weightLabelUnit: UILabel!
    @IBOutlet var UITextFieldWeight: UITextField!
    @IBOutlet var UIDatePickerDate: UIDatePicker!
    var ref: DatabaseReference!
    var bmiCalculation:Calculations!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set view title
        self.title = "Update Weight or Date"
        // get reference to firebase
        ref = Database.database().reference()
        
        // initialize the text with weight passed from table view screen
        UITextFieldWeight.text = String(bmiCalculation.weight)
        // set appropriate label for weight unit
        if(bmiCalculation.isMetric)
        {
            weightLabelUnit.text = "kg"
        }
        else {
            weightLabelUnit.text = "lbs"
        }
    
        // set datepicker on view load on updating todo task
        let formater = DateFormatter()
        formater.dateFormat = "MM/dd/yyyy"
        let date = formater.date(from: bmiCalculation.dateOfCalculation) ?? Date()
        UIDatePickerDate.setDate(date, animated: true)
    }

    // on update button pressed
    @IBAction func onUpdatePressed(_ sender: UIButton) {
        // confirmation popup
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to save the changes?", preferredStyle: .alert)
        //alter message on click of update button
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
            // convert date to string format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            self.bmiCalculation.dateOfCalculation = dateFormatter.string(from: self.UIDatePickerDate.date)
            self.bmiCalculation.weight = Double(self.UITextFieldWeight.text!)!
            
            // Recalculate bmi with updated weight
            if(self.bmiCalculation.isMetric == true){
                self.bmiCalculation.bmiCalculation =  self.bmiCalculation.weight*100*100/(self.bmiCalculation.height*self.bmiCalculation.height)
            }else{
                self.bmiCalculation.bmiCalculation =  self.bmiCalculation.weight*703/(self.bmiCalculation.height*self.bmiCalculation.height)
            }
            self.bmiCalculation.bmiCalculation = round( self.bmiCalculation.bmiCalculation  * 100) / 100
            
            // save data to firebase
            let key = self.bmiCalculation.uniqueId
            let dictionaryTodo = [ "weight"        : self.bmiCalculation.weight,
                                   "dateOfCalculation" : self.bmiCalculation.dateOfCalculation,
                                   "bmiCalculation" : self.bmiCalculation.bmiCalculation
            ] as [String : Any]
            
            self.ref.child("bmiCalculator").child(key).updateChildValues(dictionaryTodo)
            // go back to table view
            self.navigationController?.popViewController(animated: true)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}
