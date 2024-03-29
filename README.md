
MTTextField 是一个处理常用的手机号、银行卡格式的工具，也可以自定义处理其他的数字格式，另外还提供了常见的编辑态动画组件AMTTextField。

# MTTextField

[![Version](https://img.shields.io/cocoapods/v/MTTextField.svg?style=flat)](https://cocoapods.org/pods/MTTextField)
[![License](https://img.shields.io/cocoapods/l/MTTextField.svg?style=flat)](https://cocoapods.org/pods/MTTextField)
[![Platform](https://img.shields.io/cocoapods/p/MTTextField.svg?style=flat)](https://cocoapods.org/pods/MTTextField)

## Example

[![demo](https://github.com/wangyutao0424/MTTextField/blob/master/demo.gif)](https://github.com/wangyutao0424/MTTextField/blob/master/demo.)


## Usage

### 格式化TextField
```swift
let cardTextField = UITextField()
cardTextField.fmt.type = .card
cardTextField.fmt.enabled = true

let phoneTextField = UITextField()
phoneTextField.fmt.type = .phone
phoneTextField.fmt.enabled = true
```

### 自定义Separator
#### GridSeparator
maxCount: 定义最大位数，超过位数输入无效，例：手机号限定11位，这里可设置11，超过11位输入无反应；
grid: 表示每2个字符有一个分隔，这样对于银行卡来说，是固定每4位有一个空格分隔符，所以这里选择4；

#### GroupSeparator
maxCount：同GridSeparator
group：可以自定义不同分隔位数规则，用`group`数组参数来表示。例如：[1, 2, 3, 4]，则结果为：1 11 111 1111
```swift
let customTextField = UITextField()
//let customSeparator1 = GridSeparator(maxCount: 10, grid: 2)
let customSeparator2 = GroupSeparator(maxCount: 20, group: [1, 2, 3, 4])
customTextField.fmt.type = .custom(separtor: customSeparator2)
customTextField.fmt.enabled = true
```

### 带动画的TextField
创建一个AMTTextField即可
```swift
let phoneTextField: AMTTextField = {
  let textField = AMTTextField()
  textField.placeholder = "请输入手机号码"
  textField.titleFont = .systemFont(ofSize: 14)
  textField.titleColor = .darkGray
  textField.placeholderFont = .systemFont(ofSize: 18)
  textField.placeholderColor = .lightGray
  textField.textField.font = .systemFont(ofSize: 24)
  textField.textField.textColor = .darkGray
  return textField
}()
```

## Installation

MTTextField is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MTTextField'
```

## Author

wangyutao0424, wangyutao0424@163.com

## License

MTTextField is available under the MIT license. See the LICENSE file for more info.
