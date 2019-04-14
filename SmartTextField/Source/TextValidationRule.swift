//
//  TextValidationRule.swift
//  SmartTextField
//
//  Created by Nutan Niraula on 4/14/19.
//  Copyright © 2019 Nutan Niraula. All rights reserved.
//

import Foundation

enum TextValidationRule {
    case none
    case nonEmpty
    case email
    case fullName
    case address
    case password
    case number
    case zipCode
    case decimalNumber
    case phoneNumber
    case custom(rule: String, errorMessage: String)
    
    var regex: String {
        switch self {
        case .none:
            return ".*"
        case .email:
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case .custom(let rule, _):
            return rule
        case .fullName:
            return "[A-Za-z ]+"
        case .address:
            return "[A-Za-z0-9 .'-_]+"
        case .password:
            return "(?=.*[a-z])(?=.*[A-Z])(?=.*[$@$#^!%*?&])[A-Za-z\\d$@$#^!%*?&]{5,}"
        case .number:
            return "[0-9]+"
        case .decimalNumber:
            return "^(?:|0|[1-9]\\d*)(?:\\.\\d*)?$"
        case .phoneNumber:
            return "^[0-9]{10}"
        case .nonEmpty:
            return "^(?!\\s*$).+"
        case .zipCode:
            return "^[0-9]{5}"
        }
    }
    
    var errorMessage: String {
        switch self {
        case .none:
            return ""
        case .email:
            return "Email is invalid"
        case .custom(_, let errorMessage):
            return errorMessage
        case .fullName:
            return "Invalid name"
        case .password:
            return  "8 letters with capital, number & special character"
        case .address:
            return "Invalid address"
        case .number:
            return "Invalid number"
        case .decimalNumber:
            return "Invalid number"
        case .phoneNumber:
            return "Invalid phone number"
        case .nonEmpty:
            return "This field cannot be empty"
        case .zipCode:
            return "Invalid zip code"
        }
    }
    
}

