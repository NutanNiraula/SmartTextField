//
//  HighlightedTextField.swift
//  SmartTextField
//
//  Created by Nutan Niraula on 4/14/19.
//  Copyright © 2019 Nutan Niraula. All rights reserved.
//

import UIKit

protocol HighlightedTextFieldValidityDelegate: class {
    func text(in textField: HighlightedTextField, isValid: Bool, text: String)
}

class HighlightedTextField: SmartTextField {
    
    weak var validityDelegate: HighlightedTextFieldValidityDelegate?
    
    let highLightColor = AppColors.TextField.highlightColor.cgColor
    let validColor = AppColors.TextField.green.cgColor
    let warningColor = AppColors.TextField.warningColor.cgColor
    let borderColor = AppColors.TextField.borderColor.cgColor
    var errorLabel = UILabel()
    var titleLabel = UILabel()
    
    override var text: String? {
        didSet {
            checkValidity()
        }
    }
    
    override var placeholder: String? {
        didSet {
            titleLabel.text = placeholder
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        styleView()
        addObservers()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    private func addObservers() {
        delegate = self
        addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func styleView() {
        addErrorLabel()
        addTitleLabel()
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        layer.borderColor = borderColor
        layer.shadowColor = highLightColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2.0
        layer.masksToBounds = false
        layer.shadowOpacity = 0
    }
    
    private func addTitleLabel() {
        titleLabel = UILabel(frame: CGRect(x: 0, y: -20, width: frame.size.width, height: 16))
        titleLabel.alpha = 0
        addSubview(titleLabel)
    }
    
    private func addErrorLabel() {
        errorLabel = UILabel(frame: CGRect(x: 0, y: frame.size.height + 2, width: frame.size.width, height: 15))
        errorLabel.textColor = UIColor(cgColor: warningColor)
        errorLabel.text = ""
        errorLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(errorLabel)
    }
    
    @objc func textFieldDidChange(_ textField: HighlightedTextField) {
        checkValidity()
    }
    
    private func checkValidity() {
        guard let validityTuple = text?.validate(rule: validationRule) else { return }
        if (text ?? "").isEmpty {
            layer.shadowColor = highLightColor
            layer.borderColor = borderColor
            errorLabel.text = ""
        } else if !validityTuple.isValid {
            layer.shadowColor = warningColor
            layer.borderColor = warningColor
            errorLabel.text = validityTuple.errorMessage
        } else if validityTuple.isValid {
            layer.shadowColor = validColor
            layer.borderColor = validColor
            errorLabel.text = ""
        }
        validityDelegate?.text(in: self, isValid: validityTuple.isValid, text: text ?? "")
    }
    
    func setEnabled(state: Bool) {
        isUserInteractionEnabled = state
        alpha = state ? 1.0 : 0.5
    }
    
}

extension HighlightedTextField {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        checkValidity()
        layer.shadowOpacity = 0.8
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        layer.shadowOpacity = 0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let tf = textField as? HighlightedTextField {
            switch tf.type {
            case .picker(_):
                return false
            default:
                return true
            }
        }
        return true
    }
}
