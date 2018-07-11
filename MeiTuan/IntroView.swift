//
//  IntroView.swift
//  MeiTuan
//
//  Created by zzq on 2018/7/11.
//  Copyright © 2018年 zzq. All rights reserved.
//

import UIKit

class IntroView: UIView {
    
    
    let tmp3 = ItemView(frame: CGRect(x: 110, y: 320, width: 5, height: 5))
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let w = self.bounds.size.width
        let h = self.bounds.size.height
        
        let imv = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        imv.image = UIImage(named: "11")
        self.addSubview(imv)
        imv.center = CGPoint(x: w/2, y: h/2)
        
        let duration = 5
        
        
        UIView.animate(withDuration: 1, delay: TimeInterval(duration), options: .curveEaseOut, animations: {
            imv.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        }, completion: { (finish) in
            
            UIView.animate(withDuration: 1, delay: 1, options: .curveEaseOut, animations: {
                self.alpha = 0.01
            }, completion: { (finished) in
                self.removeFromSuperview()
            })
        })
        
        
        
        for i in 0..<duration*5 {
            
            
            var x: CGFloat!
            var y: CGFloat!
            
            //            arc4random_uniform(4)%4
            switch i%4 {
            case 0:
                x = CGFloat(arc4random_uniform(UInt32(w/4)))+w/4
                y = CGFloat(arc4random_uniform(UInt32(h/4)))+h/4
                break
            case 1:
                x = CGFloat(arc4random_uniform(UInt32(w/4)))+w/2
                y = CGFloat(arc4random_uniform(UInt32(h/4)))+h/4
                break
            case 2:
                x = CGFloat(arc4random_uniform(UInt32(w/4)))+w/4
                y = CGFloat(arc4random_uniform(UInt32(h/4)))+h/2
                break
            case 3:
                x = CGFloat(arc4random_uniform(UInt32(w/4)))+w/2
                y = CGFloat(arc4random_uniform(UInt32(h/4)))+h/2
                break
            default: break
                
            }
            
            let time = DispatchTimeInterval.milliseconds(i*200)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+time) {
                let tmp = ItemView(frame: CGRect(x: x, y: y, width: 5, height: 5))
                self.addSubview(tmp)
                
                tmp.startPoint = self.center
                tmp.fillColor = UIColor.random
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class ItemView: UIView {
    
    var a: Double = 0
    var b: Double = 0
    
    var w: CGFloat = 0
    var fillColor: UIColor?
    var centerX: CGFloat!
    var centerY: CGFloat!
    var speed: CGFloat = -1
    
    var startPoint: CGPoint? {
        
        didSet {
            let p2 = self.center
            
            self.a = Double((p2.y-startPoint!.y)/(p2.x-startPoint!.x))
            self.b = Double((p2.x*startPoint!.y-p2.y*startPoint!.x)/(p2.x-startPoint!.x))
            
            
            
            let cc: CGFloat = 1
            if p2.x>startPoint!.x {
                speed = cc
            }else {
                speed = -cc
            }
        }
        
    }
    var link: CADisplayLink!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        w = min(frame.size.height*0.5, frame.size.width*0.5)
        link = CADisplayLink(target: self, selector: #selector(UIView.setNeedsDisplay as (UIView) -> () -> Void))
        link.add(to: RunLoop.main, forMode: .commonModes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMoveToSuperview() {
        centerX = self.center.x
        centerY = self.center.y
        
        if self.superview != nil {
            self.startPoint = self.superview!.center
        }
        
        self.fillColor = UIColor.random
    }
    override func draw(_ rect: CGRect) {
        
        //        print("centerX:"+"\(centerX)"+"centerY:\(centerY)")
        
        let ctx: CGContext? = UIGraphicsGetCurrentContext()
        ctx?.addPath(UIBezierPath(arcCenter: CGPoint(x: self.bounds.size.width*0.5, y: self.bounds.size.height*0.5), radius: w, startAngle: 0, endAngle: .pi*2, clockwise: false).cgPath)
        ctx?.clip()
        ctx?.setFillColor(fillColor!.cgColor)
        UIRectFill(self.bounds)
        w += speed>0 ? speed : -speed
        centerX = centerX + CGFloat(speed*2)
        centerY = CGFloat(a)*centerX + CGFloat(b)
        
        self.bounds = CGRect(x: 0, y: 0, width:  w*2, height: w*2)
        self.center = CGPoint(x: centerX, y: centerY)

        if self.superview!.bounds.intersects(self.frame) {
            
        }else {
            //            print(self)
            link.invalidate()
            self.removeFromSuperview()
        }
        
    }
}

