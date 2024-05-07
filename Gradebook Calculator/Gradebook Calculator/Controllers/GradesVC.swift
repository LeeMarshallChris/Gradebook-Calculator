//
//  GradesVC.swift
//  Gradebook Calculator
//
//  Created by  on 5/1/24.
//

import UIKit
import CoreData

class GradesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var chosenCourse : CurrentCourse?
    var assignments = [Assignment]()
    var queryString : String = ""
    
    @IBOutlet weak var courseTitleTextView: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calculateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userInterfaceStyle = traitCollection.userInterfaceStyle
        
        if userInterfaceStyle == .light {
            view.backgroundColor = UIColor.systemBlue
            courseTitleTextView.textColor = UIColor.white
            gradeLabel.textColor = UIColor.white
            calculateButton.tintColor = UIColor.yellow
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        courseTitleTextView.text = chosenCourse?.courseTitle
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        
        getData()
    }
    
    @objc func addButtonClicked() {
        var titleField = UITextField()
        var pointsGivenField = UITextField()
        var pointsTotalField = UITextField()
        
        let alert = UIAlertController(title: "Create new assignment", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default) {
            (UIAlertAction) in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let newAssignment = Assignments(context: context)
            newAssignment.assignmentTitle = titleField.text
            newAssignment.pointsGiven = Double(pointsGivenField.text!)!
            newAssignment.pointsTotal = Double(pointsTotalField.text!)!
            newAssignment.courseTitle = self.chosenCourse?.courseTitle
            
            let assignment = Assignment(assignmentTitle: titleField.text!, courseTitle: self.chosenCourse!.courseTitle, pointsGiven: Double(pointsGivenField.text!)!, pointsTotal: Double(pointsTotalField.text!)!)
            
            self.assignments.append(assignment)
            
            
            do {
                try context.save()
                print("success")
            } catch {
                print("error")
            }
            
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter assignment title"
            titleField = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter points given"
            pointsGivenField = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter point total"
            pointsTotalField = alertTextField
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    @objc func getData() {
        assignments.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Assignments")
        fetchRequest.predicate = NSPredicate(format: "courseTitle == %@", (chosenCourse?.courseTitle)!)
        
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    var assignment = Assignment(assignmentTitle: "", courseTitle: "", pointsGiven: 0.0, pointsTotal: 0.0)
                    if let assignmentTitle = result.value(forKey: "assignmentTitle") as? String {
                        assignment.assignmentTitle = assignmentTitle
                    }
                    
                    if let courseTitle = result.value(forKey: "courseTitle") as? String {
                        assignment.courseTitle = courseTitle
                    }
                    
                    if let pointsGiven = result.value(forKey: "pointsGiven") as? Double {
                        assignment.pointsGiven = pointsGiven
                    }
                    
                    if let pointsTotal = result.value(forKey: "pointsTotal") as? Double {
                        assignment.pointsTotal = pointsTotal
                    }
                    
                    assignments.append(assignment)
                    tableView.reloadData()
                    
                }
            }
        } catch {
            print("error")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let assignment = assignments[indexPath.row]
        
        let currentTitle: String = "\(assignment.assignmentTitle):"
        let currentGrades: String = "\(assignment.pointsGiven) / \(assignment.pointsTotal)"
        
        let assignmentString = fillWhiteSpace(assignmentName: currentTitle, grades: currentGrades)
        
        cell.textLabel?.text = assignmentString
        return cell
    }
    
    @IBAction func calculateButtonClicked(_ sender: Any) {
        var totalPointsGiven = 0.0
        var totalPointsTotal = 0.0
        
        if assignments.count > 0 {
            for assignment in assignments {
                totalPointsGiven += assignment.pointsGiven
                totalPointsTotal += assignment.pointsTotal
            }
            let finalGradePercentage = totalPointsGiven / totalPointsTotal * 100
            let displayString = String(format: "Calculated Grade: %.2f%%", finalGradePercentage)
            gradeLabel.text = String(displayString)
        }
        
    }
    
    func getChosenCourseTitle() -> String {
        return chosenCourse!.courseTitle
    }
    
    func fillWhiteSpace(assignmentName: String, grades: String) -> String {
        let givenStrings = assignmentName + grades
        let spaceTaken = givenStrings.count
        let neededWhiteSpace = 60 - spaceTaken
        
        var newWhiteSpace = ""
        
        for _ in 0..<neededWhiteSpace {
            newWhiteSpace += " "
        }
        
        let resultString = "\(assignmentName)\(newWhiteSpace)\(grades)"
        
        return resultString
    }
    
}
