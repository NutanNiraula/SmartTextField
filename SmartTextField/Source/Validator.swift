//
//  Validator.swift
//  SmartTextField
//
//  Created by Nutan Niraula on 4/14/19.
//  Copyright © 2019 Nutan Niraula. All rights reserved.
//

import Foundation

extension String {
    
    func validate(rule: TextValidationRule) -> (isValid: Bool, errorMessage: String?) {
        let predicate = NSPredicate(format: "SELF MATCHES %@", rule.regex)
        if predicate.evaluate(with: self) {
            return (true, nil)
        }
        return (false, rule.errorMessage)
    }
    
}
