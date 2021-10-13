//
//  Storyboarded.swift
//  SIMS
//
//  Created by Faysal on 13/10/21.
//

import UIKit

// MARK: ---------- PROTOCOL : Storyboarded ----------
protocol Storyboarded {
   static func instantiate() -> Self
}

// MARK: ---------- EXTENSION : Storyboarded ----------
extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboardName = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboardName.instantiateViewController(withIdentifier: className) as! Self
        return viewController
    }
}

