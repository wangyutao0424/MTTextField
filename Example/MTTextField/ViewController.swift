//
//  ViewController.swift
//  MTTextField
//
//  Created by wangyutao0424 on 01/17/2020.
//  Copyright (c) 2020 wangyutao0424. All rights reserved.
//

import UIKit
import MTTextField

class ViewController: UIViewController {
    
    let phoneTextField: AMTTextField = {
        let textField = AMTTextField()
        textField.placeholder = "请输入手机号码"
        textField.titleFont = .systemFont(ofSize: 14)
        textField.titleColor = .darkGray
        textField.placeholderFont = .systemFont(ofSize: 18)
        textField.placeholderColor = .lightGray
        textField.textField.font = .systemFont(ofSize: 24)
        textField.textField.textColor = .darkGray
        textField.textField.clearButtonMode = .whileEditing
        textField.textField.keyboardType = .numberPad
        return textField
    }()
    
    let cardTextField: AMTTextField = {
        let textField = AMTTextField()
        textField.placeholder = "请输入银行卡号"
        textField.titleFont = .systemFont(ofSize: 14)
        textField.titleColor = .darkGray
        textField.placeholderFont = .systemFont(ofSize: 18)
        textField.placeholderColor = .lightGray
        textField.textField.font = .systemFont(ofSize: 24)
        textField.textField.textColor = .darkGray
        textField.textField.clearButtonMode = .whileEditing
        textField.textField.keyboardType = .numberPad
        return textField
    }()
    
    let customTextField: AMTTextField = {
        let textField = AMTTextField()
        textField.placeholder = "自定义规则"
        textField.titleFont = .systemFont(ofSize: 14)
        textField.titleColor = .darkGray
        textField.placeholderFont = .systemFont(ofSize: 18)
        textField.placeholderColor = .lightGray
        textField.textField.font = .systemFont(ofSize: 24)
        textField.textField.textColor = .darkGray
        textField.textField.clearButtonMode = .whileEditing
        textField.textField.keyboardType = .numberPad
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(phoneTextField)
        
        phoneTextField.frame = CGRect(x: 20, y: 100, width: view.bounds.width - 40, height: 80)
        phoneTextField.textField.fmt.type = .phone
        phoneTextField.textField.fmt.enabled = true
        addBottomLine(phoneTextField)
        
        view.addSubview(cardTextField)
        cardTextField.frame = CGRect(x: 20, y: 200, width: view.bounds.width - 40, height: 80)
        cardTextField.textField.fmt.type = .card
        cardTextField.textField.fmt.enabled = true
        addBottomLine(cardTextField)
        
        view.addSubview(customTextField)
        customTextField.frame = CGRect(x: 20, y: 300, width: view.bounds.width - 40, height: 80)
        
        /// let's  try
//        let customSeparator1 = GridSeparator(maxCount: 10, grid: 2)
        let customSeparator2 = GroupSeparator(maxCount: 20, group: [1, 2, 3, 4])
        customTextField.textField.fmt.type = .custom(separtor: customSeparator2)
        customTextField.textField.fmt.enabled = true
        addBottomLine(customTextField)
    }

    func addBottomLine(_ view: UIView) {
        let line = UIView()
        line.backgroundColor = .blue
        var frame = view.bounds
        frame.origin.y = frame.height - 1
        frame.size.height = 1
        line.frame = frame
        view.addSubview(line)
    }

}

