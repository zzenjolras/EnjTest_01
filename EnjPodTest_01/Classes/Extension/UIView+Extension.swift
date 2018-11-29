//
//  UIView+Extension.swift
//  Yeting
//
//  Created by GYz on 2018/4/9.
//  Copyright © 2018年 GYz. All rights reserved.
//

import Foundation

extension UIView {
    var originX :CGFloat{
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }
    var originY :CGFloat{
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    var width :CGFloat{
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.width
        }
    }
    var height :CGFloat{
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.height
        }
    }
    var centerX :CGFloat{
        get {
            return self.center.x
        }
        set {
            self.center.x = newValue
        }
    }
    var centerY :CGFloat{
        get {
            return self.center.y
        }
        set {
            self.center.y = newValue
        }
    }
    var size :CGSize{
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
        get {
            return self.frame.size
        }
    }

    
    @IBInspectable var cornerRadius:CGFloat{
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    @IBInspectable var shadowRadius:CGFloat{
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
    @IBInspectable var borderWidth:CGFloat{
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    @IBInspectable var borderColor:UIColor{
        get {
            return UIColor.init(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    @IBInspectable var shadowColor:UIColor{
        get {
            return UIColor.init(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue.cgColor
        }
    }
    @IBInspectable var shadowOffset:CGSize{
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    @IBInspectable var shadowOpacity:Float{
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    @IBInspectable var masksToBounds:Bool{
        get {
            return self.layer.masksToBounds
        }
        set {
            self.layer.masksToBounds = newValue
        }
    }
    
    var avatarCorner: Bool {
        get {
            return self.layer.cornerRadius > 0
        }
        set {
            self.layer.cornerRadius = self.frame.width / 2
            self.layer.masksToBounds = newValue
        }
    }
}
