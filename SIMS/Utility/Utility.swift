//
//  Utility.swift
//  SIMS
//
//  Created by Faysal on 11/10/21.
//

import UIKit

class Utility: NSObject {

       
    
}

extension String {
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}
