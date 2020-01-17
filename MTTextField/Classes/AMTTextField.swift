//
//  AMTTextField.swift
//  AMTTextField_Example
//
//  Created by wangyutao on 2018/7/30.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation

public class AMTTextField: UIView {
    
    //Private property
    private class AMTTextFieldObserver: NSObject {
        
        var observerAction: ((String?, Any?, [NSKeyValueChangeKey : Any]?, UnsafeMutableRawPointer?) -> Void)?

        override init() {
            super.init()
        }
        
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            observerAction?(keyPath, object, change, context)
        }
        
    }
    
    private let placeholderLayer: CATextLayer = {
        let layer = CATextLayer()
        layer.foregroundColor = UIColor.lightGray.cgColor
        layer.fontSize = 15
        layer.contentsScale = UIScreen.main.scale
        layer.alignmentMode = CATextLayerAlignmentMode.justified
        return layer
    }()
    
    private weak var topConstraint: NSLayoutConstraint?
    private var isEditingState: Bool = false
    
    private let observer = AMTTextFieldObserver()

    //Public property
    public let textField = UITextField()
    
    public var topOffset = 30.0 {
        didSet {
            self.topConstraint?.constant = CGFloat(topOffset)
        }
    }
    
    weak open var delegate: UITextFieldDelegate?
    
    public var text: String? {
        set {
            textField.text = newValue
            refresh()
        }
        get {
            return textField.text
        }
    }
    
    public var placeholder: String? {
        didSet {
            placeholderLayer.string = placeholder
        }
    }
    
    public var placeholderColor: UIColor = .lightGray {
        didSet {
            if !isEditingState {
                placeholderLayer.foregroundColor = placeholderColor.cgColor
            }
        }
    }
    
    public var placeholderFont: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            if !isEditingState {
                placeholderLayer.font = placeholderFont.fontName as CFTypeRef
                placeholderLayer.fontSize = placeholderFont.pointSize
            }
        }
    }
    
    public var titleColor: UIColor = .darkGray {
        didSet {
            if isEditingState {
                placeholderLayer.foregroundColor = titleColor.cgColor
            }
        }
    }
    
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 13) {
        didSet {
            if isEditingState {
                placeholderLayer.font = titleFont.fontName as CFTypeRef
                placeholderLayer.fontSize = titleFont.pointSize
            }
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        observer.observerAction = {[weak self] keyPath, object, _, _ in
            self?.refreshPlaceholder()
        }
        textField.addObserver(observer, forKeyPath: "bounds", options: [.new, .old], context: nil)
        textField.addObserver(observer, forKeyPath: "center", options: [.new], context: nil)
        textField.addObserver(observer, forKeyPath: "frame", options: [.new], context: nil)
        self.addSubview(textField)
        self.layer.addSublayer(placeholderLayer)
        layoutTextField()
        
        textField.delegate = delegate
        textField.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }
    
    func refreshPlaceholder() {
        if !isEditingState {
            var rect = textField.frame
            rect.size.height = placeholderFont.lineHeight
            rect.origin.y = textField.frame.origin.y + (textField.frame.size.height - rect.size.height) / 2
            placeholderLayer.frame = rect
        }
        else {
            var rect = textField.frame
            rect.size.height = titleFont.lineHeight
            rect.origin.y = textField.frame.origin.y - rect.size.height - 3
            placeholderLayer.frame = rect
        }
    }
    
    
    private func layoutTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: CGFloat(topOffset))
        let left = NSLayoutConstraint(item: textField, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: textField, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -10)
        let bottom = NSLayoutConstraint(item: textField, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -5)
        self.addConstraints([top, left, right, bottom])
        self.topConstraint = top
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func editingDidBegin() {
        refresh()
    }
    
    @objc func editingDidEnd() {
        refresh()
    }
    
    func refresh() {
        
        let isEditing: Bool
        let text = textField.text ?? ""
        isEditing = !text.isEmpty || textField.isFirstResponder
        
        if isEditingState == isEditing { return }
        isEditingState = isEditing
        
        self.placeholderLayer.font = isEditing ? titleFont : placeholderFont
        self.placeholderLayer.fontSize = isEditing ? titleFont.pointSize : placeholderFont.pointSize
        self.placeholderLayer.foregroundColor = isEditing ? titleColor.cgColor : placeholderColor.cgColor
        var rect: CGRect
        if isEditing {
            rect = placeholderLayer.frame
            rect.size.height = titleFont.lineHeight
            rect.origin.y = textField.frame.origin.y - rect.size.height - 3
        }
        else {
            rect = placeholderLayer.frame
            rect.size.height = placeholderFont.lineHeight
            rect.origin.y = textField.frame.origin.y + (textField.frame.size.height - rect.size.height) / 2
        }
        self.placeholderLayer.frame = rect

    }
    
    deinit {
        textField.removeObserver(observer, forKeyPath: "bounds")
        textField.removeObserver(observer, forKeyPath: "center")
        textField.removeObserver(observer, forKeyPath: "frame")
    }
    
}
