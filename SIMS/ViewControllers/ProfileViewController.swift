//
//  ProfileViewController.swift
//  SIMS
//
//  Created by Faysal on 12/10/21.
//

import UIKit
import CoreData
import SlideMenuControllerSwift


class ProfileViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var fathersNameField: UITextField!
    @IBOutlet weak var dobField: UITextField!
    @IBOutlet weak var classField: UITextField!
    @IBOutlet weak var rollField: UITextField!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    var user: NSManagedObject!
    var isImageUpdated = false
    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        loadData()
        showDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !DataStore.readBool(key: PrefKey.IS_ADMIN) {
            self.setNavigationBarItem()
            DataManager.shared.getCurrentUserData(email: DataStore.readString(key: PrefKey.USER_EMAIL))
            self.user = DataManager.shared.loggedInUser
            self.loadData()
            self.deleteBtn.isHidden = true
        }
        
    }
    
    func loadData() {
        if let userObj = user as? Students {
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
    
    @IBAction func updateBtnAction(_ sender: UIButton) {
        if let name = self.nameField.text, let fathersName = self.fathersNameField.text, let birthDay = self.dobField.text, let studentClass = self.classField.text, let roll = self.rollField.text {
            if let userObj = user as? Students {
                userObj.name = name
                userObj.fathername = fathersName
                userObj.birthday = birthDay
                userObj.student_class = Int32(studentClass) ?? 0
                userObj.roll = Int32(roll) ?? 0
                if self.isImageUpdated {
                    userObj.profileImage = self.profileImage.image!.jpegData(compressionQuality: 1.0)
                }
                DataManager.shared.updateData(object: userObj)
                self.showAlert(title: "", message: "Data updated")
            }
        }
    }
    
    @IBAction func deleteBtnAction(_ sender: UIButton) {
        let alert = UIAlertController.init(title: "Delete", message: "Are you sure to delete this data?", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction.init(title: "Delete", style: .destructive, handler: { action in
            DataManager.shared.removeData(object: self.user)
            self.navigationController?.popViewController(animated: true)

        }))
        self.present(alert, animated: true, completion: nil)
    }

}
