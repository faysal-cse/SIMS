//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit

enum LeftMenu: Int {
    case home = 0
    case myAccount
    case categories
    case myOrder
    case shoppingCart
    case myFavorite
    case login
}

protocol LeftMenuProtocol : class {
    func changeViewController(position:Int)
}


class LeftViewController : UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var items = ["Home","Change password","Logout"]
    let images = ["student","student","student"]
    
    var mainVC: UIViewController!
    var profileVC : UIViewController!
    var changePasswordVC : UIViewController!
    var mainViewController: UIViewController!
    
    var imageHeaderView: ImageHeaderView!
    
    var viewControllers: [UIViewController] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "main") as! ViewController
        self.mainVC = UINavigationController(rootViewController: mainVC)
        
        let changePasswordVC = ChangePasswordViewController.instantiate()
        self.changePasswordVC = UINavigationController(rootViewController: changePasswordVC)
        
        let profileVC = ProfileViewController.instantiate()
        self.profileVC = UINavigationController(rootViewController: profileVC)
        updateData()
        tableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      //  self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
        self.view.layoutIfNeeded()
    }
    
    func updateData() {
        self.viewControllers = [self.mainVC, self.changePasswordVC]
        
        if !DataStore.readBool(key: PrefKey.IS_ADMIN) {
            self.viewControllers = [self.profileVC, self.changePasswordVC]
        }
    }
    
    func changeViewController(position: Int) {
        self.slideMenuController()?.closeLeft()
        if position == self.viewControllers.count {
            
            if let mainViewController = self.mainViewController as? ViewController {
                mainViewController.showLogoutDialog()
            }
        }else{
            self.slideMenuController()?.changeMainViewController(self.viewControllers[position], close: true, position: position)
//            let changePasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
//            self.navigationController?.pushViewController(changePasswordVC, animated: true)
        }
        
        self.slideMenuController()?.delegate?.itemClicked?(index: position)
    }
    
//    func showLogoutDialog() {
//        let alert = UIAlertController.init(title: "Logout", message: "Are you sure to logout?", preferredStyle: .alert)
//        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
//        alert.addAction(UIAlertAction.init(title: "Logout", style: .default, handler: { ActionHandler in
//            DataStore.writeBool(value: false, key: PrefKey.LOGIN)
//            //self.showLoginView()
//            if let mainViewController = self.mainViewController as? ViewController {
//                mainViewController.showLoginView(controller: mainViewController)
//            }
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
    
//    func changeVC() {
//        if DataStore.readBool(key: PrefKey.IS_REGISTERED) {
//            let profileJson = JSON.init(parseJSON: DataStore.readString(key: PrefKey.PROFILE_INFO))
//            let profileObj = Profile(json: profileJson)
//
//            if !profileObj.isVerified || !profileObj.isCompletedProfile {
//                self.slideMenuController()?.changeMainViewController(self.profileVC, close: true, position: 4)
//            } else{
//                self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true, position: 0)
//            }
//        }
//    }
    
//    @objc func headerTapped(_ sender: Any) {
//        self.slideMenuController()?.closeLeft()
//        self.slideMenuController()?.delegate?.itemClicked?(index: 2)
//    }
}

extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
         self.changeViewController(position: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let title = cell.viewWithTag(1) as! UILabel
        let imageView = cell.viewWithTag(2) as! UIImageView
        
        let model = images[indexPath.row]
        title.text = items[indexPath.row]
        title.textColor = .black
        imageView.image = UIImage.init(named: model)!
       
        return cell
    }
    
}
