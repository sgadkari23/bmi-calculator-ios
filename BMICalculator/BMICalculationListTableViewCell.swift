//
//  BMICalculationListTableViewCell.swift
//  BMICalculator
//
//  Created by 
//

import UIKit
import Firebase

class BMITableViewCell: UITableViewCell {

    @IBOutlet var weigthLabel: UILabel!
    @IBOutlet var bmiCalculationResultLabel: UILabel!
    @IBOutlet var dateOfBMICalculationLabel: UILabel!
}


class BMICalculationListTableViewCell: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var ref: DatabaseReference!
    var allBMICalculations = [Calculations]()
    var bmiCalculation:Calculations!
    var taskCount:Int!
    
    @IBOutlet var BMIListing: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.taskCount = 0
        BMIListing.delegate = self
        BMIListing.dataSource = self
        self.BMIListing.rowHeight = 100.0
        self.title = "BMI Calculation History"
        getDataFromFirebase()
    }
    
    func getDataFromFirebase(){
        ref.child("bmiCalculator").observe(DataEventType.value, with: { (snapshot) in
            // reset all data
            self.allBMICalculations = [Calculations]()
            self.taskCount = 0
            
            if let postDict = snapshot.value as? Dictionary<String, AnyObject> {
                for item in postDict {
                    let myBMICalculation = Calculations(key: item.key, bmi: item.value as! NSDictionary)
                    self.allBMICalculations.append(myBMICalculation)
                }
                self.taskCount = Int(postDict.count)
            }
            
            // Reload table view
            self.BMIListing.reloadData()
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BMICalculationListing", for: indexPath) as! BMITableViewCell
        bmiCalculation = allBMICalculations[indexPath.row]
        
        cell.weigthLabel?.text = String(bmiCalculation.weight)
        cell.dateOfBMICalculationLabel?.text = bmiCalculation.dateOfCalculation
        cell.bmiCalculationResultLabel?.text = String(bmiCalculation.bmiCalculation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subMenuVC = storyboard?.instantiateViewController(identifier: "view") as? UpdateBMIViewController
        let bmiCalculation = allBMICalculations[indexPath.row]
        subMenuVC?.bmiCalculation = bmiCalculation
        self.navigationController?.pushViewController(subMenuVC!, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Delete on swipe
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        // delete todo task when swiped right to left
        let delete = UIContextualAction(style: .destructive, title: "Delete"){(action,view,nil) in
            let bmiCalculation = self.allBMICalculations[indexPath.row]
            self.ref.child("bmiCalculator").child(bmiCalculation.uniqueId).removeValue()
            if(self.taskCount == 1) {
                self.navigationController?.popToRootViewController(animated: true)
            }
            else
            {
                self.getDataFromFirebase()
            }
        }
        delete.backgroundColor=UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}
