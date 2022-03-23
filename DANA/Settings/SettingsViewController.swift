//
//  SettingsViewController.swift
//  DANA
//
//  Created by Littman Library on 3/17/22.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var modeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func switchMode(_ sender: Any) {
        
        if self.traitCollection.userInterfaceStyle == .dark{
            view.window?.overrideUserInterfaceStyle = .light
            NotificationCenter.default.post(name: Notification.Name("ModeSwiched"), object: nil)
        }else{
            view.window?.overrideUserInterfaceStyle = .dark
            NotificationCenter.default.post(name: Notification.Name("ModeSwiched"), object: nil)
        }
    }
}
