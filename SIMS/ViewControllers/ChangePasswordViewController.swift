//
//  ChangePasswordViewController.swift
//  SIMS
//
//  Created by Faysal on 11/10/21.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var oldPasswoed: UITextField!
    @IBOutlet weak var newPasswoed: UITextField!
    @IBOutlet weak var confirmPasswoed: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Change password"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    @IBAction func changeBtnAction(_ sender: UIButton) {
        if let currentUser = DataManager.shared.loggedInUser, let oldPassword = self.oldPasswoed.text, let newPasswoed = self.newPasswoed.text, let confirmPasswoed = self.confirmPasswoed.text, newPasswoed.isEmpty == false, confirmPasswoed.isEmpty == false {
            if currentUser.password == oldPassword {
                if newPasswoed == confirmPasswoed {
                    currentUser.password = newPasswoed
                    DataManager.shared.updateData(object: currentUser)
                    DataStore.writeBool(value: false, key: PrefKey.LOGIN)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.showAlert(title: "Error", message: "Password not matched")
                }
            } else {
                self.showAlert(title: "Error", message: "Old Password not matched")
            }
        } else {
            self.showAlert(title: "Error", message: "Put all necessary information")
        }
    }
    
    
}
