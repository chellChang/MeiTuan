//
//  ViewController.swift
//  MeiTuan
//
//  Created by zzq on 2018/7/10.
//  Copyright © 2018年 zzq. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var t_collectionView: UICollectionView!
    var array = [UIColor]()
    var link: CADisplayLink!
    
    var outLayer: CAShapeLayer?
    var inLayer: CAShapeLayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.creatSubview()
        self.view.backgroundColor = UIColor.white
        link = CADisplayLink(target: self, selector: #selector(showA))
        link.add(to: RunLoop.main, forMode: .commonModes)
        link.isPaused = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func creatSubview() {
       
        for i in 0..<4 {
            let btn = UIButton(frame: CGRect(x: 50*(i+1), y: 100, width: 50, height: 50))
            self.view.addSubview(btn)
            let c = UIColor.random
            array.append(c)
            btn.setImage(UIImage.gestureImage1(color: c), for: .normal)
            btn.tag = i+100
            btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        }
        
       
    }
    
    @objc func click(sender: UIButton) {
        if link.isPaused {
            self.resetLayer()
            
            outLayer = CAShapeLayer()
            self.view.layer.addSublayer(outLayer!)
            outLayer?.path = UIBezierPath(arcCenter: sender.center, radius: 30, startAngle: 0, endAngle: .pi*2, clockwise: true).cgPath
            outLayer?.fillColor = array[sender.tag-100].cgColor
            
            
            link.isPaused = false
            
        }
    }
    @objc func showA() {
        
    }
    
    func resetLayer() {
        outLayer?.removeFromSuperlayer()
        outLayer = nil
        
        inLayer?.removeFromSuperlayer()
        inLayer = nil
    }
}

class DetailView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.random
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
class IntroView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        let tmp = ItemView(frame: CGRect(x: 85, y: 106, width: 5, height: 5))
        self.addSubview(tmp)
        
        let tmp2 = ItemView(frame: CGRect(x: 200, y: 240, width: 5, height: 5))
        self.addSubview(tmp2)
        
        let tmp3 = ItemView(frame: CGRect(x: 110, y: 320, width: 5, height: 5))
        self.addSubview(tmp3)

        let tmp4 = ItemView(frame: CGRect(x: 240, y: 450, width: 5, height: 5))
        self.addSubview(tmp4)
        
        
        
        
        for i in 0..<100 {

            let x = CGFloat(arc4random_uniform(UInt32(self.bounds.size.width)))
            let y = CGFloat(arc4random_uniform(UInt32(self.bounds.size.height)))

            UIView.animate(withDuration: 0.1, delay: TimeInterval(CGFloat(i)*0.1), options: .beginFromCurrentState, animations: {
                let tmp = ItemView(frame: CGRect(x: x, y: y, width: 5, height: 5))
                self.addSubview(tmp)

                tmp.startPoint = self.center
                tmp.fillColor = UIColor.random
            }, completion: nil)

        }
       
       
//        link.isPaused = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class ItemView: UIView {

    var a: CGFloat = 0
    var b: CGFloat = 0
    
    var w: CGFloat = 0
    var fillColor: UIColor?
    var centerX: CGFloat!
    var centerY: CGFloat!
    var speed: CGFloat = -1
    
    var startPoint: CGPoint? {
        
        didSet {
            let p2 = self.center
            
            self.a = (p2.y-startPoint!.y)/(p2.x-startPoint!.x)
            self.b = (p2.x*startPoint!.y-p2.y*startPoint!.x)/(p2.x-startPoint!.x)
            
            let cc: CGFloat = 0.5
            if a>=0 {
                speed = -cc
            }else {
                speed = cc
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
        
        print("centerX:"+"\(centerX)"+"centerY:\(centerY)")
        
        let ctx: CGContext? = UIGraphicsGetCurrentContext()
        ctx?.addPath(UIBezierPath(arcCenter: CGPoint(x: self.bounds.size.width*0.5, y: self.bounds.size.height*0.5), radius: w, startAngle: 0, endAngle: .pi*2, clockwise: false).cgPath)
        ctx?.clip()
        ctx?.setFillColor(fillColor!.cgColor)
        UIRectFill(self.bounds)
        w += speed
        centerX = centerX + CGFloat(speed*2)
        centerY = a*centerX + b
        self.bounds = CGRect(x: 0, y: 0, width: w*2, height: w*2)
        self.center = CGPoint(x: centerX, y: centerY)
       
        
        
        if self.superview!.bounds.intersects(self.frame) {
            
        }else {
            link.invalidate()
            self.removeFromSuperview()
        }
        
    }
}
