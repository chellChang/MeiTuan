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
    var presentLink: CADisplayLink?
    var dismissLink: CADisplayLink?
    
    var outLayer: CAShapeLayer?
    var inLayer: CAShapeLayer?
    
    var detailView: DetailView?
    var inRadius: CGFloat = 15
    var outRadius: CGFloat = 30
    var currentPoint: CGPoint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.creatSubview()
        self.view.backgroundColor = UIColor.white
        
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
        self.view.isUserInteractionEnabled = false
        
        currentPoint = sender.center
        self.resetLayer()
        outLayer = CAShapeLayer()
        self.view.layer.addSublayer(outLayer!)
        outLayer?.path = UIBezierPath(arcCenter: currentPoint!, radius: outRadius, startAngle: 0, endAngle: .pi*2, clockwise: true).cgPath
        outLayer?.fillColor = array[sender.tag-100].cgColor
        inLayer?.fillColor = array[sender.tag-100].cgColor
        inLayer = CAShapeLayer()
        self.view.layer.addSublayer(inLayer!)
        inLayer?.path = UIBezierPath(arcCenter: currentPoint!, radius: inRadius, startAngle: 0, endAngle: .pi*2, clockwise: true).cgPath
        
        self.resetPresentLink()
        presentLink = CADisplayLink(target: self, selector: #selector(presentDetail))
        presentLink?.add(to: RunLoop.main, forMode: .commonModes)
        
        detailView = DetailView(frame: UIScreen.main.bounds)
        self.view.addSubview(detailView!)
        detailView?.backColuse =  {
            self.view.isUserInteractionEnabled = false
            self.resetDismissLink()
            self.dismissLink = CADisplayLink(target: self, selector: #selector(self.dismissA))
            self.dismissLink?.add(to: RunLoop.main, forMode: .commonModes)
        }
        
        detailView?.layer.mask = inLayer
    }
    @objc func presentDetail() {
        let speed: CGFloat = 10
        inRadius += speed
        outRadius += (speed+speed)
        inLayer?.path = UIBezierPath(arcCenter: currentPoint!, radius: inRadius, startAngle: 0, endAngle: .pi*2, clockwise: true).cgPath
        outLayer?.path = UIBezierPath(arcCenter: currentPoint!, radius: outRadius, startAngle: 0, endAngle: .pi*2, clockwise: true).cgPath
        
        if inRadius>self.view.frame.size.height {
            self.resetPresentLink()
            self.view.isUserInteractionEnabled = true
        }
    }
    @objc func dismissA() {
        let speed: CGFloat = 10
        inRadius -= speed
        outRadius -= (speed+speed)
        inLayer?.path = UIBezierPath(arcCenter: currentPoint!, radius: inRadius, startAngle: 0, endAngle: .pi*2, clockwise: true).cgPath
        outLayer?.path = UIBezierPath(arcCenter: currentPoint!, radius: outRadius, startAngle: 0, endAngle: .pi*2, clockwise: true).cgPath
        
        if inRadius <= 15 {
            self.resetDismissLink()
            self.view.isUserInteractionEnabled = true
            self.resetLayer()
            self.detailView?.removeFromSuperview()
            self.detailView = nil
        }
    }
    
    func resetLayer() {
        outLayer?.removeFromSuperlayer()
        outLayer = nil
        
        inLayer?.removeFromSuperlayer()
        inLayer = nil
   
    }
    func resetPresentLink() {
        presentLink?.invalidate()
        presentLink = nil
    }
    func resetDismissLink() {
        dismissLink?.invalidate()
        dismissLink = nil
    }
}

typealias kBack = ()->Void
class DetailView: UIView {
    
    var backColuse: kBack?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.random
        
        let imv = UIImageView(frame: self.bounds)
        self.addSubview(imv)
        
        imv.image = UIImage(named: "cha")
        
        imv.isUserInteractionEnabled = true
        imv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backEvent)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func backEvent() {
        if let back = self.backColuse{
            back()
        }
    }
}
