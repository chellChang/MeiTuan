//
//  ImageTool.swift
//  ImageTool
//
//  Created by zzq on 2018/7/6.
//  Copyright © 2018年 zzq. All rights reserved.
//

import UIKit

extension UIImage {
    // 颜色生成图片
    class func color(_ color: UIColor) -> UIImage{
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
//        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, UIScreen.main.scale)
        let ctx: CGContext? = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(color.cgColor)
        ctx?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func gradientColor(_ colors: [UIColor], locations: [CGFloat], start: CGPoint, end: CGPoint) -> UIImage{
        UIGraphicsBeginImageContext(CGSize(width: 100, height: 100))
        let ctx: CGContext? = UIGraphicsGetCurrentContext()
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var componets = [CGFloat]()
        
        for i in 0..<colors.count {
            let c = colors[i].cgColor
            
            for j in 0..<4 {
                componets.append(c.components![j])
            }
            
        }
        
        let gradient = CGGradient.init(colorSpace: colorSpace, colorComponents: componets, locations: locations, count: locations.count)
        ctx?.drawLinearGradient(gradient!, start: start, end: end, options: .drawsAfterEndLocation)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    //
    func tined(color: UIColor, fraction: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        
        color.set()
        UIRectFill(CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height), blendMode: .destinationIn, alpha: 1)
        if fraction>0 {
            self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height), blendMode: .sourceAtop, alpha: fraction)
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
        
    }
    
    // 自由拉伸
    class func zq_resizeImage(named: String) -> UIImage {
        let img = UIImage(named: named)
        let h = img!.size.height
        let w = img!.size.width
        
        //UIEdgeInsetsMake(h*0.5-10, w*0.5-10, h*0.5-10, w*0.5-10)
        let newImg = img!.resizableImage(withCapInsets: UIEdgeInsetsMake(h*0.5-5, w*0.5-5, h*0.5-5, w*0.5-5), resizingMode: .tile)
        return newImg
    }
    // 按照图片比例，
    func zq_resizeImage(size: CGSize) -> UIImage {
        
        let w = size.width*UIScreen.main.scale
        let h = size.height*UIScreen.main.scale
        
        let scale = min(w/self.size.width, h/self.size.height)
        let newW = self.size.width*scale
        let newH = self.size.width*scale
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: w, height: h), false, 0) // true 不透明
        self.draw(in: CGRect(x: (w-newW)/2, y: (h-newH)/2, width: newW, height: newH))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    // 指定裁剪尺寸
    func clip(rect: CGRect) -> UIImage {
        let sources = self.cgImage
        let newSources = sources!.cropping(to: rect)
        let image = UIImage(cgImage: newSources!)
        return image
    }
    
    // 圆角
    func cornerRadius(_ radius: CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContext(self.size)
        
        let ctx: CGContext? = UIGraphicsGetCurrentContext()
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        
        ctx?.addPath(path.cgPath)
        ctx?.clip()
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func clip(path: UIBezierPath) -> UIImage {
        
        UIGraphicsBeginImageContext(self.size)
        
        let ctx: CGContext? = UIGraphicsGetCurrentContext()
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        ctx?.addPath(path.cgPath)
        ctx?.clip()
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func clip(path: UIBezierPath, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
        
//        UIGraphicsBeginImageContext(CGSize(width: self.size.width+borderWidth*2, height: self.size.height+borderWidth*2))
        UIGraphicsBeginImageContext(self.size)
        let ctx: CGContext? = UIGraphicsGetCurrentContext()
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        ctx?.addPath(path.cgPath)
        ctx?.clip()
        self.draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()

        
        UIGraphicsEndImageContext()
        
        
        UIGraphicsBeginImageContext(self.size)
        let ctx2: CGContext? = UIGraphicsGetCurrentContext()

        image!.draw(in: CGRect(x: (rect.size.width-image!.size.width)/2, y: (rect.size.height-image!.size.height)/2, width: image!.size.width, height: image!.size.height))
        ctx2?.addPath(path.cgPath)
        ctx2?.setLineWidth(borderWidth)
        ctx2?.setStrokeColor(borderColor.cgColor)
        ctx2?.strokePath()
        let image2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image2!
    }
    
    // 截图
    
    class func capture(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
        let ctx: CGContext? = UIGraphicsGetCurrentContext()
        view.layer.render(in: ctx!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    //
    class func gestureImage1(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 100, height: 100), false, 0)
        let ctx: CGContext? = UIGraphicsGetCurrentContext()
        ctx?.addPath(UIBezierPath(arcCenter: CGPoint(x: 50, y: 50), radius: 25, startAngle: 0, endAngle: .pi*2, clockwise: true).cgPath)
        ctx?.clip()
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 100, height: 100))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    class func gestureImage1() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 100, height: 100), false, 0)
        let ctx: CGContext? = UIGraphicsGetCurrentContext()
        ctx?.addPath(UIBezierPath(arcCenter: CGPoint(x: 50, y: 50), radius: 25, startAngle: 0, endAngle: .pi*2, clockwise: true).cgPath)
        ctx?.clip()
        UIColor.random.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 100, height: 100))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    class func gestureImage2() -> UIImage {
        let cc  = UIColor.random
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 100, height: 100), false, 0)
        let ctx: CGContext? = UIGraphicsGetCurrentContext()
        
        
        ctx?.addPath(UIBezierPath(arcCenter: CGPoint(x: 50, y: 50), radius: 45, startAngle: 0, endAngle: .pi*2, clockwise: true).cgPath)
        ctx?.setLineWidth(3)
        ctx?.setStrokeColor(cc.cgColor)
        ctx?.strokePath()
        
        
        UIRectFill(CGRect(x: 0, y: 0, width: 100, height: 100))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
//        UIGraphicsBeginImageContext(image!.size)
//        let ctx2: CGContext? = UIGraphicsGetCurrentContext()
//
//        image!.draw(in: CGRect(x: 0, y: 0, width: 100, height: 100))
//        ctx2?.addPath(UIBezierPath(arcCenter: CGPoint(x: 50, y: 50), radius: 45, startAngle: 0, endAngle: .pi*2, clockwise: true).cgPath)
//        ctx2?.setLineWidth(3)
//        ctx2?.setStrokeColor(cc.cgColor)
//        ctx2?.strokePath()
//        let image2 = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        
        return image!
    }
}
extension UIColor {
    
    class var random: UIColor {
        get {
            let r = CGFloat(arc4random_uniform(255))
            let g = CGFloat(arc4random_uniform(255))
            let b = CGFloat(arc4random_uniform(255))
            return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
        }
    }
    
    class func randomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(255))
        let g = CGFloat(arc4random_uniform(255))
        let b = CGFloat(arc4random_uniform(255))
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
    }
    class func rgba(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}
