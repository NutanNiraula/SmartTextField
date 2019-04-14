//
//  SmartTextField.swift
//  SmartTextField
//
//  Created by Nutan Niraula on 4/14/19.
//  Copyright © 2019 Nutan Niraula. All rights reserved.
//

import UIKit

class SmartTextField: UITextField {
    
    var type: TextType = .normal {
        didSet {
            reloadInputViews()
            validationRule = type.getValidationRule()
            switch type {
            case .name:
                configureNameTextField()
            case .email:
                configureEmailTextField()
            case .password:
                configurePasswordTextField()
            case .number(let type):
                configureNumberTextField(with: type)
            case .normal:
                break
            case .nonEmpty:
                setNonEmptyTextField()
            case .custom(rule: let rule):
                setRule(rule: rule)
            case .url:
                configureUrlTextField()
            case .picker(let type):
                configurePicker(with: type)
            case .address(let address):
                configureAddressTextField(with: address)
            case .oneTimeCode:
                configureOneTimeCodeTextField()
            }
        }
    }
    
    lazy var datePicker = UIDatePicker()
    lazy var picker = UIPickerView()
    lazy var pickerData = [String]()
    var validationRule: TextValidationRule = .none
    
    private func setRule(rule: TextValidationRule) {
        validationRule = rule
    }
    
    private func setNonEmptyTextField() {
        validationRule = .nonEmpty
    }
    
    private func configureEmailTextField() {
        textContentType = .emailAddress
        keyboardType = .emailAddress
        validationRule = .email
    }
    
    private func configurePasswordTextField() {
        if #available(iOS 11.0, *) {
            textContentType = .password
        }
        isSecureTextEntry = true
        keyboardType = .asciiCapable
        validationRule = .password
        addPasswordToggleButton(withImage: #imageLiteral(resourceName: "eye-stripe").withRenderingMode(UIImage.RenderingMode.alwaysTemplate))
    }
    
    private func addPasswordToggleButton(withImage image: UIImage) {
        let rightSideButton = UIButton(frame: CGRect(x: frame.width - frame.height, y: 0, width: frame.height, height: 30))
        rightSideButton.imageView?.contentMode = .scaleAspectFit
        rightView = rightSideButton
        rightViewMode = .whileEditing
        rightSideButton.tintColor = UIColor.black
        rightSideButton.setImage(image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: UIControl.State.normal)
        rightSideButton.imageEdgeInsets = UIEdgeInsets(top: rightSideButton.frame.height/2 - 10, left: 0, bottom: rightSideButton.frame.height/2 - 10, right: 0)
        rightSideButton.addTarget(self, action: #selector(eyeButtonTapped(sender:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc func eyeButtonTapped(sender:UIButton) {
        if isSecureTextEntry {
            sender.setImage(#imageLiteral(resourceName: "eye").withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: UIControl.State.normal)
            isSecureTextEntry = false
        } else {
            sender.setImage(#imageLiteral(resourceName: "eye-stripe").withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: UIControl.State.normal)
            isSecureTextEntry = true
        }
    }
    
    private func configureNameTextField() {
        keyboardType = .asciiCapable
        validationRule = .fullName
    }
    
    private func configureNumberTextField(with type: NumberType) {
        switch type {
        case .contactNumber(let contactNumberType):
            configureContactNumberTextField(with: contactNumberType)
        case .normal:
            keyboardType = .numberPad
            validationRule = .number
        case .decimal:
            keyboardType = .decimalPad
            validationRule = .decimalNumber
        }
    }
    
    private func configureContactNumberTextField(with type: ContactNumber) {
        textContentType = .telephoneNumber
        validationRule = .phoneNumber
        switch type {
        case .mobileNumber:
            keyboardType = .phonePad
        case .phoneNumber:
            keyboardType = .numberPad
        }
    }
    
    private func configureUrlTextField() {
        textContentType = .URL
        keyboardType = .URL
    }
    
    private func configurePicker(with type: UIPickerViewType) {
        switch type {
        case .picker(let data):
            validationRule = .nonEmpty
            picker.backgroundColor = .white
            pickerData = data
            picker.dataSource = self
            picker.delegate = self
            inputView = picker
        case .datePicker(let mode):
            validationRule = .nonEmpty
            configureDatePickerTextField(with: mode)
        }
    }
    
    private func configureDatePickerTextField(with mode: UIDatePicker.Mode) {
        datePicker.datePickerMode = mode
        datePicker.backgroundColor = .white
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(dateSelected), for: UIControl.Event.valueChanged)
        inputView = datePicker
    }
    
    @objc private func dateSelected() {
        text = dateInYearMonthDay(date: datePicker.date)
    }
    
    private func configureAddressTextField(with type: AddressType) {
        switch type {
        case .city, .state, .streetAddress:
            keyboardType = .alphabet
            textContentType = .location
            validationRule = .address
        case .postalCode:
            keyboardType = .numberPad
            textContentType = .postalCode
            validationRule = .zipCode
        }
    }
    
    private func configureOneTimeCodeTextField() {
        if #available(iOS 12.0, *) {
            textContentType = .oneTimeCode
        }
        keyboardType = .default
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        type = .normal
    }
    
    private func dateInYearMonthDay(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
}

extension SmartTextField: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let tf = textField as? SmartTextField {
            if tf.inputView is UIDatePicker {
                text = dateInYearMonthDay(date: datePicker.date)
            } else if tf.inputView is UIPickerView {
                text = pickerData[picker.selectedRow(inComponent: 0)]
            }
        }
    }
    
}

extension SmartTextField: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        text = pickerData[row]
    }
}
