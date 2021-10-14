//
//  AddStudentViewController.swift
//  SIMS
//
//  Created by Faysal on 12/10/21.
//

import UIKit
import CoreData

class AddStudentViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var fathersNameField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var classField: UITextField!
    @IBOutlet weak var rollField: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var imageBtn: UIButton!
    
    var user: NSManagedObject? = nil
    var isUpdate = false
    var isImageUpdated = false
    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Student"

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeTapped))
        initData()
        showDatePicker()
    }
    
    func initData() {
        deleteBtn.isHidden = true
        addBtn.setTitle("Add student", for: .normal)
        if let userObj = user as? Students {
            deleteBtn.isHidden = false
            addBtn.setTitle("Update", for: .normal)
            self.navigationItem.title = userObj.name
            self.emailField.isEnabled = false
            self.isUpdate = true
            self.emailField.text = userObj.email
            self.nameField.text = userObj.name
            self.fathersNameField.text = userObj.fathername
            self.dobField.text = userObj.birthday
            self.classField.text = "\(userObj.student_class)"
            self.rollField.text = "\(userObj.roll)"
            
            if let imageData = userObj.profileImage, let profileImage = UIImage(data: imageData) {
                self.profileImage.image = profileImage
            } else {
                self.profileImage.image = UIImage.init(named: "user")
            }
        }
        deleteBtn.setTitle("Delete", for: .normal)
        imageBtn.setTitle("", for: .normal)
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        // add toolbar to textField
        dobField.inputAccessoryView = toolbar
        // add datepicker to textField
        dobField.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dobField.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc  func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    
    @IBAction func pickImageBtnAction(_ sender: UIButton) {
        ImagePickerManager().pickImage(self) { image in
            self.profileImage.image = image
            self.isImageUpdated = true
        }
    }
    
    @IBAction func addStudentBtnAction(_ sender: UIButton) {
        if let email = self.emailField.text, let password = self.passwordField.text, let confirmPassword = self.confirmPasswordField.text, let name = self.nameField.text, let fathersName = self.fathersNameField.text, let birthDay = self.dobField.text, let studentClass = self.classField.text, let roll = self.rollField.text {
            if email.isValidEmail, !name.trimmingCharacters(in: .whitespaces).isEmpty {
                if isUpdate {
                    
                    if let userObj = user as? Students {
                        userObj.name = name.trimmingCharacters(in: .whitespaces)
                        userObj.fathername = fathersName
                        userObj.birthday = birthDay
                        userObj.student_class = Int32(studentClass) ?? 0
                        userObj.roll = Int32(roll) ?? 0
                        if self.isImageUpdated {
                            userObj.profileImage = self.profileImage.image!.jpegData(compressionQuality: 1.0)
                        }
                        if !password.isEmpty, password == confirmPassword {
                            userObj.password = password
                        }
                        DataManager.shared.updateData(object: userObj)
                        self.showAlert(title: "", message: "Data updated")
                        self.dismiss(animated: true, completion: nil)
                    }
                } else{
                    if !password.isEmpty, password == confirmPassword {
                        DataManager.shared.isExist(email: email) { [weak self] success in
                            if !success {
                                DataManager.shared.saveData(email: email, password: password, name: name, fathersName: fathersName, birthDay: birthDay, studentClass: Int(studentClass) ?? 0, roll: Int(roll) ?? 0, profileImage: self?.profileImage.image) { success in
                                    self?.dismiss(animated: true, completion: nil)
                                }
                            } else {
                                self?.showAlert(title: "Error", message: "User Already exists")
                            }
                        }
                    } else {
                        self.showAlert(title: "Error", message: "Password not matched")
                    }
                   
                }
            } else{
                if !email.isValidEmail {
                    self.showAlert(title: "Error", message: "Email not valid")
                } else {
                    self.showAlert(title: "Error", message: "name cannot be empty")
                }
            }
        }
        
    }
    
    @objc func addTapped() {
        // Add operation
       // saveData()
       // self.dismiss(animated: true, completion: nil)
    }
    
    @objc func closeTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteBtnAction(_ sender: UIButton) {
        let alert = UIAlertController.init(title: "Delete", message: "Are you sure to delete this data?", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction.init(title: "Delete", style: .destructive, handler: { action in
            
            DataManager.shared.removeData(object: self.user!)
            self.dismiss(animated: true, completion: nil)

        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
