//
//  TextType.swift
//  SmartTextField
//
//  Created by Nutan Niraula on 4/14/19.
//  Copyright © 2019 Nutan Niraula. All rights reserved.
//

import UIKit

enum AddressType {
    case streetAddress
    case city
    case state
    case postalCode
}

enum UIPickerViewType {
    case datePicker(mode: UIDatePicker.Mode)
    case picker(data: [String])
}

enum NumberType {
    case contactNumber(type: ContactNumber)
    case normal
    case decimal
}

enum ContactNumber {
    case phoneNumber
    case mobileNumber
}

enum TextType {
    case normal
    case nonEmpty
    case custom(rule: TextValidationRule)
    case name
    case email
    case password
    case number(type: NumberType)
    case url
    case address(type: AddressType)
    case picker(type: UIPickerViewType)
    case oneTimeCode
    
    func getValidationRule() -> TextValidationRule {
        switch self {
        case .normal:
            return .none
        case .nonEmpty:
            return .nonEmpty
        case .custom(let rule):
            return rule
        case .name:
            return .fullName
        case .email:
            return .email
        case .password:
            return .password
        case .number(let type):
            switch type {
            case .contactNumber(_):
                return .phoneNumber
            case .normal:
                return .number
            case .decimal:
                return .decimalNumber
            }
        case .url:
            return .none
        case .address(let type):
            switch type {
            case .city, .state, .streetAddress:
                return .address
            case .postalCode:
                return .number
            }
        case .picker(_):
            return .nonEmpty
        case .oneTimeCode:
            return .none
        }
    }
}
