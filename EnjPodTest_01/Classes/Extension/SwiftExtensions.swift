//
//  SwiftExtensions.swift
//  Yeting
//
//  Created by GYz on 2018/4/12.
//  Copyright © 2018年 GYz. All rights reserved.
//

import Foundation

extension String {
    
    /**
     * 是否包含字符串
     */
    func contains(find: String) -> Bool {
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool {
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    var hexColor: UIColor {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return .clear
        }
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return boundingBox.height
    }
    
    func widthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat{
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height:height)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return boundingBox.width
    }
    
    //根据开始位置和长度截取字符串
    func subString(start:Int = 0, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - start
        }
        let st = self.index(startIndex, offsetBy:start)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
    
    
    /// 计算字符串个数
    ///
    /// - Parameters:
    ///   - textStr: 需要计算的字符串
    ///   - textFont: 字符串大小
    ///   - textRect: 需计算的范围
    /// - Returns: 结果范围
    func getLineTextRangeWith(textStr: String,textFont: UIFont, textRect: CGRect) -> NSRange {
        let attributes = NSMutableDictionary(capacity: 5)
        let font = textFont
        attributes.setValue(font, forKey: NSAttributedStringKey.font.rawValue)
        let attributedString = NSAttributedString(string: textStr, attributes: attributes as? [NSAttributedStringKey : Any])
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let bezierPath = UIBezierPath(rect: textRect)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), bezierPath.cgPath, nil)
        let range = CTFrameGetVisibleStringRange(frame)
        let rg = NSMakeRange(range.location, range.length)
        return rg
    }
    
    /// JSONString转换为字典
    static func getDictionaryFromJSONString(jsonString:String) ->NSDictionary {
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    
}


extension UIColor{
    convenience init(rgb:Int){
        let r = CGFloat(((rgb & 0xFF0000)>>16)) / CGFloat(255.0)
        let g = CGFloat(((rgb & 0xFF00)>>8)) / CGFloat(255.0)
        let b = CGFloat(((rgb & 0xFF))) / CGFloat(255.0)
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }

    
    class func colorWithHexString(hex:String,alpha:Float = 1) -> UIColor {
        
        var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            let index = cString.index(cString.startIndex, offsetBy:1)
            cString = cString.substring(from: index)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.red
        }
        
        let rIndex = cString.index(cString.startIndex, offsetBy: 2)
        let rString = cString.substring(to: rIndex)
        let otherString = cString.substring(from: rIndex)
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
        let gString = otherString.substring(to: gIndex)
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        let bString = cString.substring(from: bIndex)
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(alpha))
    }
    
}

extension UIButton {
    /// 设置 - 边框 & 文字 为相同颜色
    func setColor(same color: UIColor) {
        setTitleColor(color, for: .normal)
        borderColor = color
    }
    
    /// 水平排列，文字在左，图片在右
    ///
    /// - Parameter space: 文字和图片间隔
 
    func setTitleImageHorizontalAlignmentWithSpace(space: Float) {
        resetEdgeInsets()
        setNeedsLayout()
        layoutIfNeeded()
        
        let contentRect: CGRect = self.contentRect(forBounds: bounds)
        let titleSize: CGSize = self.titleRect(forContentRect: contentRect).size
        let imageSize: CGSize = self.imageRect(forContentRect: contentRect).size
        contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, CGFloat(space))
        titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width)
        imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width + CGFloat(space), 0, -titleSize.width - CGFloat(space))
    }
    
    
    /// 水平排列，图片在左，文字在右
    ///
    /// - Parameter space: 图片和文字间隔
    func setImageTitleHorizontalAlignmentWithSpace(space: Float) {
        resetEdgeInsets()
        titleEdgeInsets = UIEdgeInsetsMake(0, CGFloat(space), 0, -CGFloat(space))
        contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, CGFloat(space))
    }
    
    
    /// 竖直排列，文字在上，图片在下
    ///
    /// - Parameter space: 文字和图片的间距
    func setTitleImageVerticalAlignmentWithSpace(space: Float) {
        verticalAlignmentWithTitleTop(isTop: true, space: space)
    }
    
    
    /// 竖直排列，图片在上，文字在下
    ///
    /// - Parameter space: 图片和文字的间距
    func setImageTitleVerticalAlignmentWithSpace(space: Float) {
        verticalAlignmentWithTitleTop(isTop: false, space: space)
    }
    
    private func resetEdgeInsets() {
        contentEdgeInsets = UIEdgeInsets.zero
        imageEdgeInsets = UIEdgeInsets.zero
        titleEdgeInsets = UIEdgeInsets.zero
    }
    
    private func verticalAlignmentWithTitleTop(isTop: Bool, space: Float) {
        resetEdgeInsets()
        setNeedsLayout()
        layoutIfNeeded()
        
        let contentRect: CGRect = self.contentRect(forBounds: bounds)
        let titleSize: CGSize = self.titleRect(forContentRect: contentRect).size
        let imageSize: CGSize = self.imageRect(forContentRect: contentRect).size
        
        let halfWidth: CGFloat = (titleSize.width + imageSize.width) / 2
        let halfHeight: CGFloat = (titleSize.height + imageSize.height) / 2
        
        let topInset = min(halfHeight, titleSize.height)
        let leftInset = (titleSize.width - imageSize.width) > 0 ? (titleSize.width - imageSize.width) / 2 : 0
        let bottomInset = (titleSize.height - imageSize.height) > 0 ? (titleSize.height - imageSize.height) / 2 : 0
        let rightInset = min(halfWidth, titleSize.width)
        
        if isTop {
            self.titleEdgeInsets = UIEdgeInsetsMake(-halfHeight - CGFloat(space), -halfWidth, halfHeight + CGFloat(space), halfWidth)
            self.contentEdgeInsets = UIEdgeInsetsMake(CGFloat(topInset) + CGFloat(space), leftInset, -bottomInset, -rightInset)
        }
        else {
            self.titleEdgeInsets = UIEdgeInsetsMake(halfHeight + CGFloat(space), -halfWidth, -halfHeight - CGFloat(space), halfWidth)
            self.contentEdgeInsets = UIEdgeInsetsMake(-bottomInset, leftInset, topInset + CGFloat(space), -rightInset)
        }
    }
}

//MARK: - UIDevice延展
public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod1,1":  return "iPod Touch 1"
        case "iPod2,1":  return "iPod Touch 2"
        case "iPod3,1":  return "iPod Touch 3"
        case "iPod4,1":  return "iPod Touch 4"
        case "iPod5,1":  return "iPod Touch (5 Gen)"
        case "iPod7,1":   return "iPod Touch 6"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone 4"
        case "iPhone4,1":  return "iPhone 4s"
        case "iPhone5,1":   return "iPhone 5"
        case  "iPhone5,2":  return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":  return "iPhone 5c (GSM)"
        case "iPhone5,4":  return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":  return "iPhone 5s (GSM)"
        case "iPhone6,2":  return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,2":  return "iPhone 6"
        case "iPhone7,1":  return "iPhone 6 Plus"
        case "iPhone8,1":  return "iPhone 6s"
        case "iPhone8,2":  return "iPhone 6s Plus"
        case "iPhone8,4":  return "iPhone SE"
        case "iPhone9,1":   return "国行、日版、港行iPhone 7"
        case "iPhone9,2":  return "港行、国行iPhone 7 Plus"
        case "iPhone9,3":  return "美版、台版iPhone 7"
        case "iPhone9,4":  return "美版、台版iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":   return "iPhone 8"
        case "iPhone10,2","iPhone10,5":   return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":   return "iPhone X"
            
        case "iPad1,1":   return "iPad"
        case "iPad1,2":   return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":   return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":   return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":   return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":  return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":   return "iPad Air 2"
        case "iPad6,3", "iPad6,4":  return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":  return "iPad Pro 12.9"
        case "AppleTV2,1":  return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":  return "Apple TV 3"
        case "AppleTV5,3":   return "Apple TV 4"
        case "i386", "x86_64":   return "Simulator"
        default:  return identifier
        }
    }
}


//extension UIScrollView {
//    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        next?.touchesBegan(touches, with: event)
//    }
//    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        next?.touchesMoved(touches, with: event)
//    }
//    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        next?.touchesEnded(touches, with: event)
//    }
//}

//extension UIViewController {
//    func getCurrentVCFrom(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
//}


/**
 向tableView 注册 UITableViewCell
 
 - parameter tableView: tableView
 - parameter cell:      要注册的类名
 */
func regClass(_ tableView:UITableView , cell:AnyClass)->Void {
    tableView.register( cell, forCellReuseIdentifier: "\(cell)");
}
/**
 从tableView缓存中取出对应类型的Cell
 如果缓存中没有，则重新创建一个
 
 - parameter tableView: tableView
 - parameter cell:      要返回的Cell类型
 - parameter indexPath: 位置
 
 - returns: 传入Cell类型的 实例对象
 */
func getCell<T: UITableViewCell>(_ tableView:UITableView ,cell: T.Type ,indexPath:IndexPath) -> T {
    return tableView.dequeueReusableCell(withIdentifier: "\(cell)", for: indexPath) as! T ;
}

