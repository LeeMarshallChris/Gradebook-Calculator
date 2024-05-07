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
    var currentPointsGiven : Double = 0.0
    var currentPointsTotal : Double = 0.0
    
    @IBOutlet weak var courseTitleTextView: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pointsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userInterfaceStyle = traitCollection.userInterfaceStyle
        
        if userInterfaceStyle == .light {
            view.backgroundColor = UIColor.systemBlue
            self.navigationController!.navigationBar.tintColor = UIColor.yellow
            courseTitleTextView.textColor = UIColor.white
            gradeLabel.textColor = UIColor.yellow
            pointsLabel.textColor = UIColor.yellow
        } else if userInterfaceStyle == .dark {
            view.backgroundColor = UIColor.systemGray6
            self.navigationController!.navigationBar.tintColor = UIColor.systemBlue
            tableView.backgroundColor = UIColor.systemGray4
            gradeLabel.textColor = UIColor.systemBlue
            pointsLabel.textColor = UIColor.systemBlue
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        courseTitleTextView.text = chosenCourse?.courseTitle
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        
        getData()
        
        if assignments.count > 0 {
            setCalculations()
        }
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
            self.currentPointsGiven += newAssignment.pointsGiven
            self.currentPointsTotal += newAssignment.pointsTotal
            
            
            do {
                try context.save()
                print("success")
            } catch {
                print("error")
            }
            
            self.tableView.reloadData()
            self.setCalculations()
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
                        currentPointsGiven += pointsGiven
                    }
                    
                    if let pointsTotal = result.value(forKey: "pointsTotal") as? Double {
                        assignment.pointsTotal = pointsTotal
                        currentPointsTotal += pointsTotal
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
        cell.textLabel?.text = assignment.assignmentTitle
        if traitCollection.userInterfaceStyle == .light {
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
        } else if traitCollection.userInterfaceStyle == .dark {
            cell.backgroundColor = UIColor.systemGray
            cell.textLabel?.textColor = UIColor.white
        }
        return cell
    }
    
    func getChosenCourseTitle() -> String {
        return chosenCourse!.courseTitle
    }
    
    func setCalculations() {
        let result: Double = currentPointsGiven / currentPointsTotal * 100
        let displayString = String(format: "Calculated Grade: %.2f%%", result)
        pointsLabel.text = "\(currentPointsGiven) / \(currentPointsTotal)"
        gradeLabel.text = displayString
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let userInterfaceStyle = traitCollection.userInterfaceStyle
        
        if userInterfaceStyle == .light {
            view.backgroundColor = UIColor.systemBlue
            self.navigationController!.navigationBar.tintColor = UIColor.yellow
            tableView.backgroundColor = .white
            courseTitleTextView.textColor = .white
            pointsLabel.textColor = .yellow
            gradeLabel.textColor = .yellow
        } else if userInterfaceStyle == .dark {
            view.backgroundColor = UIColor.systemGray6
            tableView.backgroundColor = UIColor.systemGray4
            self.navigationController!.navigationBar.tintColor = UIColor.systemBlue
            gradeLabel.textColor = UIColor.systemBlue
            pointsLabel.textColor = UIColor.systemBlue
        }
        
        tableView.reloadData()
    }
    
}
