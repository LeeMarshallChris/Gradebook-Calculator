//
//  ViewController.swift
//  Gradebook Calculator
//
//  Created by  on 4/30/24.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var courses = [CurrentCourse]()
    var selectedCourse : CurrentCourse?
    
    
    @IBOutlet weak var testLabel: UILabel!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courses.removeAll(keepingCapacity: false)

        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        getData()
    }
    
    @objc func addButtonClicked() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create new course", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default) { (UIAlertAction) in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
                    
            let newCourse = SchoolCourse(context: context)
            newCourse.courseTitle = textField.text
            
            let course = CurrentCourse(courseTitle: textField.text ?? "noCourseName")
            self.courses.append(course)
                
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
            alertTextField.placeholder = "Enter course title"
            textField = alertTextField
        }
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func getData() {
        courses.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SchoolCourse")
        fetchRequest.returnsObjectsAsFaults = false
        
        

        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    var course = CurrentCourse(courseTitle: "")
                    if let courseTitle = result.value(forKey: "courseTitle") as? String {
                        course.courseTitle = courseTitle
                        
                    }
                    
                    courses.append(course)
                    
                    
                    self.tableView.reloadData()
                }
            }
            

        } catch {
            print("error")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let course = courses[indexPath.row]
        cell.textLabel?.text = course.courseTitle
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGradesVC" {
            let destinationVC = segue.destination as! GradesVC
            destinationVC.chosenCourse = selectedCourse!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCourse = courses[indexPath.row]
        performSegue(withIdentifier: "toGradesVC", sender: nil)
    }
    

}

