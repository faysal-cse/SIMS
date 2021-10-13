//
//  ViewController.swift
//  SIMS
//
//  Created by Faysal on 11/10/21.
//

import UIKit
import SlideMenuControllerSwift
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var allUsers: [NSManagedObject] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoginView(controller: self)
        self.setNavigationBarItem()
        self.navigationItem.title = "All Users"
        self.tableView.allowsMultipleSelectionDuringEditing = false
        loadData()
        
    }
    
    func loadData(){
        allUsers.removeAll()
        DataManager.shared.getAlldata { success, data in
            if success {
                self.allUsers = data
                self.tableView.reloadData()
            }
        }
        
    }
    
    @objc func addTapped() {
        let addStudentVC = AddStudentViewController.instantiate()
        // addStudentVC.modalPresentationStyle = .fullScreen
        let nvc = UINavigationController(rootViewController: addStudentVC)
        nvc.modalPresentationStyle = .fullScreen
        self.present(nvc, animated: true, completion: nil)
    }
    
    func showLoginView(controller: UIViewController){
       
        if !DataStore.readBool(key: PrefKey.LOGIN) {
            let loginVC = LoginViewController.instantiate()
            loginVC.modalPresentationStyle = .fullScreen
            loginVC.delegate = self
            getTopViewController()?.present(loginVC, animated: true, completion: nil)
        } else{
            if let leftController = self.slideMenuController()?.leftViewController as? LeftViewController {
                leftController.changeViewController(position: 0)
            }
            DataManager.shared.getCurrentUserData(email: DataStore.readString(key: PrefKey.USER_EMAIL))
        }
        
    }
    
    func itemSelected(index: Int) {
        if index == 1 {
            let changeVC = ChangePasswordViewController.instantiate()
            self.navigationController?.pushViewController(changeVC, animated: true)
        } else if index == 2 {
          //  showLogoutDialog()
        }
    }
    
    func showLogoutDialog() {
        
        let alert = UIAlertController.init(title: "Logout", message: "Are you sure to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction.init(title: "Logout", style: .default, handler: { ActionHandler in
            DataStore.writeBool(value: false, key: PrefKey.LOGIN)
            if let leftController = self.slideMenuController()?.leftViewController as? LeftViewController {
                leftController.changeViewController(position: 0)
            }
            self.showLoginView(controller: self)
        }))
        getTopViewController()?.present(alert, animated: true, completion: nil)
        
       
    }
    
    func getTopViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        // topController should now be your topmost view controller
            //topController.present(alert, animated: true, completion: nil)
        }
        return self
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allUsers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserCell
        
        if let userObj = self.allUsers[indexPath.row] as? Students {
            if let imageData = userObj.profileImage, let profileImage = UIImage(data: imageData) {
                cell.profileImageView.image = profileImage
            } else {
                cell.profileImageView.image = UIImage.init(named: "user")
            }
            
            cell.nameLbl.text = userObj.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let addStudentVC = AddStudentViewController.instantiate()
         addStudentVC.modalPresentationStyle = .fullScreen
        addStudentVC.user = allUsers[indexPath.row]
        let nvc = UINavigationController(rootViewController: addStudentVC)
        nvc.modalPresentationStyle = .fullScreen
        self.present(nvc, animated: true, completion: nil)
    }
    
    // this method handles row deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.deleteData(user: allUsers[indexPath.row])
            
            // delete the table view row
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    
    func deleteData(user: NSManagedObject) {
        let alert = UIAlertController.init(title: "Delete", message: "Are you sure to delete this data?", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction.init(title: "Delete", style: .destructive, handler: { action in
            DataManager.shared.removeData(object: user)
            self.loadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


extension ViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
    }
    
    func leftDidOpen() {
    }
    
    func leftWillClose() {
    }
    
    func leftDidClose() {
    }
    
    func rightWillOpen() {
    }
    
    func rightDidOpen() {
    }
    
    func rightWillClose() {
    }
    
    func rightDidClose() {
    }
    
    func itemClicked(index:Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            self.itemSelected(index: index)
        }
        
    }
    
}

extension ViewController: LoginDelegate {
    func loginCompleted() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let leftController = self.getTopViewController()?.slideMenuController()?.leftViewController as? LeftViewController {
                leftController.updateData()
                leftController.changeViewController(position: 0)
            }
        }
        
    }
}


class UserCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    
}
