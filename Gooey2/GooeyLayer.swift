//
//  GooeyLayer.swift
//  Gooey2
//
//  Created by Pål Forsberg on 2015-02-18.
//  Copyright (c) 2015 Pål Forsberg. All rights reserved.
//

import UIKit

enum Direction {
    case Back
//    case TopOut
//    case TopIn
//    case TopRightOut
//    case TopRightIn
    case RightOut
//    case RightIn
//    case BottomRightOut
//    case BottomRightIn
//    case BottomOut
//    case BottomIn
//    case BottomLeftOut
//    case BottomLeftIn
    case LeftOut
//    case LeftIn
//    case TopLeftOut
//    case TopLeftIn
}
enum Animation {
    case Calm
    case Gooey
}

typealias Vectors = (CGVector, CGVector, CGVector, CGVector)
typealias GooAnimation = (CAAnimation, Vectors)

class GooeyLayer: CALayer{

    override init!(layer: AnyObject!) {
        if(layer.isKindOfClass(GooeyLayer)){
            self.nextVectors = (layer as GooeyLayer).nextVectors
            self.color = (layer as GooeyLayer).color
            self.currentVectors = (layer as GooeyLayer).currentVectors
            self.insets = (layer as GooeyLayer).insets
        } else{
            nextVectors = VectorsFunc.zero()
            self.color = UIColor.redColor().CGColor
            self.currentVectors = VectorsFunc.zero()
        }
        super.init(layer: layer)
    }
    
    override init!() {

        self.nextVectors = VectorsFunc.zero()
        self.currentVectors = VectorsFunc.zero()
        super.init()
        
    }
    required init(coder aDecoder: NSCoder) {

        self.nextVectors = VectorsFunc.zero()
        self.currentVectors = VectorsFunc.zero()
        super.init(coder: aDecoder)
    }
    
    
    @NSManaged var xpercent : CGFloat
    
    private var currentVectors : Vectors
    private var nextVectors : Vectors
    private var animationQueue : [GooAnimation] = [GooAnimation]()
    
    var animating = false
    let size : CGFloat = 82
    var insets : CGFloat?
    var color : CGColor?
    let damping : Double = 0.2
    let velocity : Double = 2.5
    
    override var frame : CGRect{
        didSet{
            insets = (frame.size.width-size)/2
        }
    }
    
    override class func needsDisplayForKey(key: String!) -> Bool {
        if (key == "xpercent") {
            return true
        }
        return super.needsDisplayForKey(key)
    }
    
    func vectorsForDirection(d : Direction) -> Vectors{
        switch d{
        case Direction.Back:
            return backVectors()
        case Direction.LeftOut:
            return leftOutVectors()
        case Direction.RightOut:
            return rightOutVectors()
        default :
            return VectorsFunc.zero()
        }
    }
    
    func backVectors()->Vectors{
        return VectorsFunc.zero()
    }
    
    func leftOutVectors() -> Vectors{
        return (
            CGVector(dx: -12, dy: 0),
            CGVector(dx: -10, dy: 0),
            CGVector(dx: 10, dy: 0),
            CGVector(dx: 0, dy: 0))
    }
    func rightOutVectors() -> Vectors{
        return (
            CGVector(dx: 12, dy: 0),
            CGVector(dx: -10, dy: 0),
            CGVector(dx: 10, dy: 0),
            CGVector(dx: 0, dy: 0))
    }
    
    
    func getAnimation(duration : CFTimeInterval, direction : Direction, type : Animation)-> GooAnimation{
        var ani : CAAnimation?
        if type == Animation.Calm{
            ani = SpringAnimation.create("xpercent", duration: duration, fromValue: Double(0.0), toValue: Double(1.0))

        } else{
            ani = SpringAnimation.createSpring("xpercent", duration: duration, usingSpringWithDamping: damping, initialSpringVelocity: velocity, fromValue: 0.0, toValue: 1.0)
        }
        return (ani!, vectorsForDirection(direction))
    }
    
    func animateGroup(as_ : [GooAnimation]){
        animationQueue.removeAll(keepCapacity: false)
        animationQueue = as_
        
        if(self.animationForKey("animation eeoo") != nil){
            self.removeAllAnimations()
        } else {
            applyNexAnimation()
        }
    }
    
    func doneAnimating(){
        self.animating = false
        self.xpercent = 0.0
        self.currentVectors = self.nextVectors
        self.nextVectors = VectorsFunc.zero()
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {

        doneAnimating()
        applyNexAnimation()
    }
    
    func applyNexAnimation(){
        if animationQueue.count == 0 {  return  }
        
        let gooani = animationQueue.first
        animationQueue.removeAtIndex(0)
        
        self.nextVectors = gooani!.1
        self.xpercent = 1.0
        self.animating = true
        gooani!.0.delegate = self
        
        self.addAnimation(gooani!.0, forKey: "animation eeoo")
    }
    
    override func drawInContext(ctx: CGContext!) {
        let insets_ = insets == nil ? 0 : insets!
        let rect = CGRect(x: insets_, y: insets_, width: self.bounds.size.width - insets_ * 2, height: self.bounds.size.height - insets_ * 2)
        let curve : CGFloat = rect.size.width/3.6
        
        var d = self.currentVectors
        var next = self.nextVectors
        
        d = VectorsFunc.multConst(d, k: 1 - xpercent)
        next = VectorsFunc.multConst(next, k: xpercent)
        d = VectorsFunc.plus(d, v2: next)
        
        CGContextAddPath(ctx, circleDistortPath(rect, curve: curve,
            d1: d.0,
            d2: d.1,
            d3: d.2,
            d4: d.3))
        CGContextSetFillColorWithColor(ctx, self.color);
        
        CGContextFillPath(ctx);
    }

    
    func circleDistortPath(rect : CGRect, curve : CGFloat, d1 : CGVector, d2 : CGVector, d3 : CGVector, d4 : CGVector)->CGMutablePathRef{
        let nilvector = CGVector(dx:0, dy:0);
        
        return GooeyLayer.circlePath(rect, curve: curve, vs: (
                CGVector(dx:d1.dx, dy:d1.dy),
                CGVector(dx:d2.dx, dy:d2.dy),
                CGVector(dx:d3.dx, dy:d3.dy),
                CGVector(dx:d4.dx, dy:d4.dy)))
    }

    
    class func circlePath(rect : CGRect, curve : CGFloat, vs : Vectors) -> CGMutablePathRef{
        var path = CGPathCreateMutable()
        
        let x1 : CGFloat = ((rect.size.width)/2) + vs.0.dx     + rect.origin.x
        let y1 : CGFloat = (0 + vs.0.dy)                       + rect.origin.y
        
        let x2 : CGFloat = (rect.size.width)                   + rect.origin.x
        let y2 : CGFloat = ((rect.size.height)/2)              + rect.origin.y
        
        let x3 : CGFloat = ((rect.size.width)/2)               + rect.origin.x
        let y3 : CGFloat = (rect.size.height)                  + rect.origin.y
        
        let x4 : CGFloat = (0 + vs.3.dx)                       + rect.origin.x
        let y4 : CGFloat = ((rect.size.height)/2) + vs.3.dy    + rect.origin.y
        
        CGPathMoveToPoint(path, nil, x1, y1)
        CGPathAddCurveToPoint(path, nil,
            x1 + curve + vs.2.dx, y1 + vs.2.dy,
            x2, y2 - curve,
            x2, y2)
        
        CGPathAddCurveToPoint(path, nil,
            x2, y2 + curve,
            x3 + curve, y3,
            x3, y3)
        
        CGPathAddCurveToPoint(path, nil,
            x3 - curve, y3,
            x4, y4 + curve,
            x4, y4)
        
        CGPathAddCurveToPoint(path, nil,
            x4, y4 - curve,
            x1 - curve + vs.1.dx, y1 + vs.1.dy,
            x1, y1)
        CGPathCloseSubpath(path)
        return path
    }
}

