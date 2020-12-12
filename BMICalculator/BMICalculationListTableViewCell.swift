//
//  BMICalculator
//  Name: Supriya Gadkari
//  Student Id: 301140872
//  Date:12/11/2020
//  BMI Calculation listing

import UIKit
import Firebase

class BMITableViewCell: UITableViewCell {

    @IBOutlet var weigthLabel: UILabel!
    @IBOutlet var bmiCalculationResultLabel: UILabel!
    @IBOutlet var dateOfBMICalculationLabel: UILabel!
    @IBOutlet var weightUnitLabel: UILabel!
}


class BMICalculationListTableViewCell: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var ref: DatabaseReference!
    var allBMICalculations = [Calculations]()
    var bmiCalculation:Calculations!
    var taskCount:Int!
    
    @IBOutlet var BMIListing: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get reference to firebase
        ref = Database.database().reference()
        // initial task count is 0
        self.taskCount = 0
        BMIListing.delegate = self
        BMIListing.dataSource = self
        self.BMIListing.rowHeight = 100.0
        // set screen title
        self.title = "BMI Calculation History"
        // get data from firebase to populate the table
        getDataFromFirebase()
    }
    
    func getDataFromFirebase(){
        // call firebase to get data
        ref.child("bmiCalculator").observe(DataEventType.value, with: { (snapshot) in
            // initialize array
            self.allBMICalculations = [Calculations]()
            self.taskCount = 0
            // parse firebase object
            if let postDict = snapshot.value as? Dictionary<String, AnyObject> {
                for item in postDict {
                    let myBMICalculation = Calculations(key: item.key, bmi: item.value as! NSDictionary)
                    self.allBMICalculations.append(myBMICalculation)
                }
                // set the number of rows for table
                self.taskCount = Int(postDict.count)
            }
            
            // Reload table view
            self.BMIListing.reloadData()
        })
    }
    
    // row count of table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskCount
    }
    
    // populate each row of the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BMICalculationListing", for: indexPath) as! BMITableViewCell
        
        // get row number and data
        bmiCalculation = allBMICalculations[indexPath.row]
        
        cell.weigthLabel?.text = String(bmiCalculation.weight)
        // set weight unit
        if(bmiCalculation.isMetric) {
            cell.weightUnitLabel?.text = "kg"
        }
        else {
            cell.weightUnitLabel?.text = "lbs"
        }
        // display the row ui text labels
        cell.dateOfBMICalculationLabel?.text = bmiCalculation.dateOfCalculation
        cell.bmiCalculationResultLabel?.text = String(bmiCalculation.bmiCalculation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subMenuVC = storyboard?.instantiateViewController(identifier: "view") as? UpdateBMIViewController
        let bmiCalculation = allBMICalculations[indexPath.row]
        subMenuVC?.bmiCalculation = bmiCalculation
        // call update page
        self.navigationController?.pushViewController(subMenuVC!, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Delete on swipe
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        // delete todo task when swiped right to left
        let delete = UIContextualAction(style: .destructive, title: "Delete"){(action,view,nil) in
            let bmiCalculation = self.allBMICalculations[indexPath.row]
            // delete item from firebase
            self.ref.child("bmiCalculator").child(bmiCalculation.uniqueId).removeValue()
            if(self.taskCount == 1) {
                self.navigationController?.popToRootViewController(animated: true)
            }
            else
            {
                self.getDataFromFirebase()
            }
        }
        // background color of 'delete' swipe
        delete.backgroundColor=UIColor.init(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}
