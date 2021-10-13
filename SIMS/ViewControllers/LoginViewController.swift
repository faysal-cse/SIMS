//
//  LoginViewController.swift
//  SIMS
//
//  Created by Faysal on 11/10/21.
//

import UIKit
import CoreData

protocol LoginDelegate {
    func loginCompleted()
}

class LoginViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var delegate: LoginDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initiateUI()
        
    }
    
    func initiateUI() {
        emailField.layer.borderColor = UIColor.white.cgColor
        emailField.layer.borderWidth = 0.5
        emailField.layer.cornerRadius = 5
        
        passwordField.layer.borderColor = UIColor.white.cgColor
        passwordField.layer.borderWidth = 0.5
        passwordField.layer.cornerRadius = 5
    }
    
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        if let email = self.emailField.text, let password = self.passwordField.text {
            if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false, password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
                if email.isValidEmail {
                    
                    DataManager.shared.login(email: email.trimmingCharacters(in: .whitespacesAndNewlines), password: password.trimmingCharacters(in: .whitespacesAndNewlines)) { [weak self] success in
                        if success {
                            DataStore.writeBool(value: true, key: PrefKey.LOGIN)
                            DataStore.writeBool(value: email == Constants.ADMIN_EMAIL, key: PrefKey.IS_ADMIN)
                            DataStore.writeString(value: email, key: PrefKey.USER_EMAIL)
                            self?.delegate?.loginCompleted()
                            self?.dismiss(animated: true, completion: nil)
                        } else{
                            self?.showAlert(title: "Error", message: "Please provide valid credentials")
                        }
                    }
                } else{
                    self.showAlert(title: "Error", message: "Please provide valid email")
                }
            } else {
                self.showAlert(title: "Error", message: "Please provide login credentials")
            }
        }
    }
    
}
