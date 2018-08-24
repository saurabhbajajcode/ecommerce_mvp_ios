//
//  Extensions.swift
//  Ecommerce MVP
//
//  Created by Saurabh on 24/08/18.
//  Copyright © 2018 Saurabh. All rights reserved.
//

import Foundation
import UIKit

extension String {
    static func isValidEmail(_ testStr: String) -> Bool {
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$" //BS
        let emailTestPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let result = emailTestPredicate.evaluate(with: testStr)
        return result
    }
}

