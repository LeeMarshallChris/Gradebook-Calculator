//
//  SettingsVC.swift
//  Gradebook Calculator
//
//  Created by  on 5/6/24.
//

import UIKit

class SettingsVC: UIViewController {

    
    @IBOutlet weak var darkModeButton: UISwitch!
    
    let currentSetting = UserDefaults.standard.object(forKey: "darkMode")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if currentSetting as! Int == 0 {
            
        }
        
    }
    

    @IBAction func darkModeSettingButton(_ sender: Any) {
        if currentSetting as! Int == 0 {
            UserDefaults.standard.set(1, forKey: "darkMode")
        } else {
            UserDefaults.standard.set(0, forKey: "darkMode")
        }
    }
    

}
