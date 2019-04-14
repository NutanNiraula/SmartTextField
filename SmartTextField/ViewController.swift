//
//  ViewController.swift
//  SmartTextField
//
//  Created by Nutan Niraula on 4/13/19.
//  Copyright © 2019 Nutan Niraula. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: HighlightedTextField!
    @IBOutlet weak var passwordTextField: HighlightedTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var isValidEmail = false
    var isValidPassword = false
    
    var isValidForm: Bool {
        return isValidEmail && isValidPassword
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.type = .email
        passwordTextField.type = .password
        emailTextField.validityDelegate = self
        passwordTextField.validityDelegate = self
        setLoginEnabledState(whenFormIsValid: isValidForm)
    }
    
    func setLoginEnabledState(whenFormIsValid isValid: Bool) {
        loginButton.isUserInteractionEnabled = isValid
        loginButton.alpha = isValid ? 1.0 : 0.5
    }

}

extension ViewController: HighlightedTextFieldValidityDelegate {
    
    func text(in textField: HighlightedTextField, isValid: Bool, text: String) {
        if textField == emailTextField {
            isValidEmail = isValid
        } else if textField == passwordTextField {
            isValidPassword = isValid
        }
        setLoginEnabledState(whenFormIsValid: isValidForm)
    }
    
    
}
