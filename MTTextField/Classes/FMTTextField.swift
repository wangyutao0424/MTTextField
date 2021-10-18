//
//  CardField.swift
//  CardField_Example
//
//  Created by wangyutao on 2018/7/7.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit


/// Format textfield type
///
/// - card: separate for four unit, and limited 19 count
/// - phone: separate for 3,4,4, and lmited 11 count
/// - custom: you can custom type use calss Separator
public enum FMTTextFieldType {
    case card
    case phone
    case custom(separtor: Separator)
}

protocol SeparatorProtocol {
    @discardableResult
    func next() -> Int?
    func currentGrid() -> Int?
    func reset()
}

public class Separator: SeparatorProtocol {
    
    fileprivate var _maxCount: Int?
    
    var maxCount: Int? {
        get {
            return _maxCount
        }
    }
    
    static let card = GridSeparator(maxCount: 19, grid: 4)
    static let phone = GroupSeparator(maxCount: 11, group: [3, 4, 4])
    
    public static func separator(maxCount: Int, grid: Int) -> Separator {
        return GridSeparator(maxCount: maxCount, grid: grid)
    }
    
    public static func separator(maxCount: Int, group: [Int]) -> Separator {
        return GroupSeparator(maxCount: maxCount, group: group)
    }
    
    @discardableResult
    func next() -> Int? {
        return nil
    }
    
    func currentGrid() -> Int? {
        return nil
    }
    
    func reset() {}
}

public class GridSeparator: Separator {
    
    private var _grid: Int
    private var _current: Int?

    public init(maxCount: Int, grid: Int) {
        _grid = grid
        super.init()
        _maxCount = maxCount
        reset()
    }
    
    override func next() -> Int? {
        if _grid < 1 {
            _current = nil
            return _current
        }
        _current = (_current ?? 0) + _grid
        return _current
    }
    
    override func currentGrid() -> Int? {
        return _current
    }
    
    override func reset() {
        _current = _grid > 0 ? _grid : nil
    }
}

public class GroupSeparator: Separator {
    
    private var _group: [Int]
    private var _current: Int?
    private var _currentIndex: Int = 0

    public init(maxCount: Int, group: [Int]) {
        
        _group = group.filter({ (item) -> Bool in
            return item > 0
        })
        super.init()
        _maxCount = maxCount
        reset()
    }
    
    override func next() -> Int? {
        _currentIndex = _currentIndex + 1
        
        guard _group.count > _currentIndex else {
            _current = nil
            return _current
        }
        
        let count = _group[_currentIndex]
        
        if let max = _maxCount, max > count {
            _current = count + (_current ?? 0)
        }
        else {
            _current = nil
        }
        return _current
    }
    
    override func currentGrid() -> Int? {
        return _current
    }
    
    override func reset() {
        _current = nil
        _currentIndex = 0
        
        guard _group.count > 0 else {
            return
        }
        
        let count = _group[_currentIndex]
        
        if let max = _maxCount, max > count {
            _current = count
        }
    }
}

private let digitals: [Character] = ["0","1","2","3","4","5","6","7","8","9"]

fileprivate class FMTTextFieldManager {
    
    private unowned let textField: UITextField
    
    fileprivate var enabeled: Bool = false
    fileprivate var separator: Separator = .card


    fileprivate var type: FMTTextFieldType = .card {
        didSet {
            //refresh
            switch type {
            case .card:
                separator = .card
            case .phone:
                separator = .phone
            case .custom(let sep):
                separator = sep
            }
            _texFieldChanged(textField: self.textField)
        }
    }
    
    init(textField: UITextField) {
        self.textField = textField
        self.textField.addTarget(self, action: #selector(_texFieldChanged(textField:)), for: .editingChanged)
    }
    
    func setTextToFormate(text: String?) {
        self.textField.text = text
        _texFieldChanged(textField: self.textField)
    }
    
    @objc private func _texFieldChanged(textField: UITextField) {
        if !enabeled { return }
        var cursorPositon = 0
        if let startRange = textField.selectedTextRange?.start {
            cursorPositon = textField.offset(from: textField.beginningOfDocument, to: startRange)
        }
        
        let pureDigital = self.removeNotDigitals(text: textField.text, cursorPosition: &cursorPositon)
        let spaceText = self.format(text: pureDigital, cursorPosition: &cursorPositon)
        textField.text = spaceText
        if let position = textField.position(from: textField.beginningOfDocument, offset: cursorPositon) {
            textField.selectedTextRange = textField.textRange(from: position, to: position)
        }
    }
    
    func removeNotDigitals(text: String?, cursorPosition: inout Int) -> String {
        guard let str = text else { return "" }
        cursorPosition = max(cursorPosition, 0)
        
        let prefix = str.prefix(cursorPosition)
        let preDig = self.pureNumber(text: String(prefix))
        let strDig = self.pureNumber(text: str)
        cursorPosition = preDig.count
        return strDig
    }
    
    //new
    func format(text: String?, cursorPosition: inout Int) -> String {
        guard let str = text else { return "" }
        cursorPosition = max(cursorPosition, 0)
        let originCursor = cursorPosition

        var count = 0
        var value = [Character]()
        
        separator.reset()
        
        for c in str {
            
            if let maxCount = separator.maxCount, count >= maxCount {
                break
            }
            
            if count > 0, let grid = separator.currentGrid(), count == grid {
                value.append(" ")
                if count < originCursor, count != originCursor  {
                    cursorPosition += 1
                }
                separator.next()
            }
            value.append(c)
            count += 1
        }
        
        return String(value)
    }

    func pureDigital() -> String {
        return self.pureNumber(text: textField.text)
    }
    
    func pureNumber(text: String?) -> String {
        guard let str = text else { return "" }
        var value = [Character]()
        for c in str {
            if digitals.contains(c) {
                value.append(c)
            }
        }
        let s = String(value)
        return s
    }
    
}

public extension UITextField {
    var fmt: FMTCompatible {
        return FMTCompatible(self)
    }
}

public class FMTCompatible {
    
    let target: UITextField
    
    init(_ textField: UITextField) {
        target = textField
    }

    
    /// format enable, default card type
    public var enabled: Bool {
        get {
            return target.manager.enabeled
        }
        set {
            target.manager.enabeled = newValue
        }
    }
    
    /// format type, default is card, you can choose phone and custom
    public var type: FMTTextFieldType {
        get {
            return target.manager.type
        }
        
        set {
            target.manager.type = newValue
        }
    }
    
    public func setTextToFormat(text: String?) {
        if !enabled {
            target.text = text
            return
        }
        target.manager.setTextToFormate(text: text)
    }
    
    public func pureDigital() -> String {
        if enabled {
            return target.manager.pureDigital()
        }
        return target.text ?? ""
    }
}

extension UITextField {
    
    private struct AssociatedKeys {
        static var managerKey = "FMTTextField.Manager"
    }
    
    fileprivate var manager: FMTTextFieldManager {
        get {
            if let manager = objc_getAssociatedObject(self, &AssociatedKeys.managerKey) as? FMTTextFieldManager {
                return manager
            }
            let manager = FMTTextFieldManager(textField: self)
            objc_setAssociatedObject(self, &AssociatedKeys.managerKey, manager, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return manager
        }
    }    
}
