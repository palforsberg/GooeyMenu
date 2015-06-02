//
//  BridgeLayer.swift
//  Gooey2
//
//  Created by Pål Forsberg on 2015-02-19.
//  Copyright (c) 2015 Pål Forsberg. All rights reserved.
//

import UIKit

class BridgeLayer: CALayer {

    override init!(layer: AnyObject!) {
        if layer is BridgeLayer{
            color = layer.color
            image = (layer as! BridgeLayer).image
            
        }
        percent = layer.percent
        super.init(layer: layer)
        self.contentsScale = UIScreen.mainScreen().scale
        self.anchorPoint = CGPoint(x: 0.5, y: 1.0)
    }
    override init!() {
        percent = closeValue
        super.init()
        
        self.contentsScale = UIScreen.mainScreen().scale
        self.anchorPoint = CGPoint(x: 0.5, y: 1.0)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override class func needsDisplayForKey(key: String!) -> Bool {
        if (key == "percent") {
            return true
        }
        return super.needsDisplayForKey(key)
    }

    var path : CGPath?
    var percent : CGFloat{
        didSet{
            path = bridgePath()
        }
    }

    let closeValue : CGFloat    = -1.0
    let openValue : CGFloat     = 1.0
    var color : UIColor?
    var image : UIImage?
    
    
    func animateOpen(duration : Double, delay : Double){
        animate(duration, duration2: duration*2, delay: delay, from: closeValue, to: openValue, timing1: kCAMediaTimingFunctionLinear, timing2: kCAMediaTimingFunctionEaseOut)
        
    }
    
    func animateClose(duration : Double, delay : Double){
        animate(duration*2, duration2: duration, delay: delay, from: openValue, to: closeValue, timing1: kCAMediaTimingFunctionEaseIn, timing2: kCAMediaTimingFunctionLinear)
        
    }
    
    func animate(duration1 : Double, duration2: Double, delay : Double, from : CGFloat, to : CGFloat, timing1 : String, timing2 : String){
        

        let breakpoint = 0.78
        let a1 = SpringAnimation.create("percent", duration: duration1, fromValue: from, toValue: breakpoint)
        a1.beginTime = CACurrentMediaTime() + delay
        a1.timingFunction = CAMediaTimingFunction(name: timing1)
        a1.removedOnCompletion = false
        a1.fillMode = kCAFillModeForwards
        self.addAnimation(a1, forKey: "percent")
        
        let a2 = SpringAnimation.create("percent", duration: duration2, fromValue: breakpoint, toValue: to)
        a2.beginTime = a1.beginTime + duration1
        a2.timingFunction = CAMediaTimingFunction(name:  timing2)
        a2.delegate = self
        a2.removedOnCompletion = false
        a2.fillMode = kCAFillModeForwards
        self.addAnimation(a2, forKey: "percent2")
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        self.removeAllAnimations()
        let a : CABasicAnimation = anim as! CABasicAnimation
        self.percent = a.toValue as! CGFloat
        
    }
    
    override func drawInContext(ctx: CGContext!) {
        
        let p = path == nil ? bridgePath() : path
        
        CGContextSetFillColorWithColor(ctx, self.color == nil ? UIColor.redColor().CGColor : self.color?.CGColor)
        CGContextAddPath(ctx, p)
        CGContextFillPath(ctx)
        
        path = nil
    }
    
    private func bridgePath() -> CGMutablePathRef{
        
        let ballsize : CGFloat = 44
        let height : CGFloat = 78 - 22
        let rect = CGRect(x: self.frame.origin.x, y:(22+(height * (1-percent))), width: 60, height: percent * (height))
        let path = CGPathCreateMutable()
        let inset : CGFloat = (rect.size.width-ballsize)/CGFloat(2)
        
   
        
        let p1 = CGPoint(x: inset,                               y: rect.origin.y)

        CGPathMoveToPoint(path, nil, p1.x, p1.y)
        CGPathAddEllipseInRect(path, nil, CGRect(x: p1.x, y: p1.y-22, width: ballsize, height: ballsize))
        
        if(percent < 0.82 && percent > 0){
            //  p1------p2
            //   p6    p3
            //p5__________p4
            let curve : CGFloat = 3
            let curveInset : CGFloat = 0
            let p : CGFloat = percent
            let distCurvePoint     : CGFloat = 23 //Distance the middple point (p3, p6) should travel inwards.
            let travelCurvePoint   : CGFloat = distCurvePoint * p
            let newCurveInset      : CGFloat = travelCurvePoint // MAX(curveInset + travelCurvePoint, v2:inset)

            
            let p2 = CGPoint(x: rect.size.width - inset ,            y: rect.origin.y)
            let p3 = CGPoint(x: rect.size.width - newCurveInset,     y: rect.size.height * 0.55 + rect.origin.y)
            let p4 = CGPoint(x: rect.size.width,                     y: rect.size.height + rect.origin.y)
            let p5 = CGPoint(x: 0,                                   y: rect.size.height + rect.origin.y)
            let p6 = CGPoint(x: newCurveInset,                       y: rect.size.height * 0.55 + rect.origin.y)
            CGPathMoveToPoint(path, nil, p2.x, p2.y)
            
            CGPathAddCurveToPoint(path, nil, p2.x, p2.y, p3.x, p3.y - curve, p3.x, p3.y)
            CGPathAddCurveToPoint(path, nil, p3.x, p3.y + curve, p4.x, p4.y, p4.x, p4.y)
            
            CGPathAddLineToPoint(path, nil, p5.x, p5.y)
            CGPathAddCurveToPoint(path, nil, p5.x, p5.y, p6.x, p6.y + curve, p6.x, p6.y)
            CGPathAddCurveToPoint(path, nil, p6.x, p6.y - curve, p1.x, p1.y, p1.x, p1.y)
            CGPathCloseSubpath(path)
        }
        
        CGPathCloseSubpath(path)

        return path
    }
    
    func MIN(v1 : CGFloat, v2 : CGFloat) -> CGFloat{
        return v1 < v2 ? v1 : v2
    }
    func MAX(v1 : CGFloat, v2 : CGFloat) -> CGFloat{
        return v1 > v2 ? v1 : v2
    }
}
