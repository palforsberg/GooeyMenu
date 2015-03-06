//
//  Cross.swift
//  Gooey2
//
//  Created by Pål Forsberg on 2015-02-28.
//  Copyright (c) 2015 Pål Forsberg. All rights reserved.
//

import UIKit

class Cross: UIView {

    func animate(angle : CGFloat, fromangle: CGFloat, duration : NSTimeInterval){
        let diff = abs(angle - fromangle)
        UIView.animateWithDuration(duration*1.8, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.transform = CGAffineTransformMakeRotation(diff/2 * CGFloat(M_PI)/180)
            }) { (ended) -> Void in
                UIView.animateWithDuration(duration*0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    self.transform = CGAffineTransformMakeRotation(angle * CGFloat(M_PI)/180)
                    }) { (ended) -> Void in
                }
        }
    }
    
    override func drawRect(rect: CGRect) {
        let path = CGPathCreateMutable()
        let ctx = UIGraphicsGetCurrentContext()
        let lineWidth : CGFloat = 6
        let inset : CGFloat = lineWidth/2

        CGPathMoveToPoint(path, nil, rect.size.width/2, inset)
        CGPathAddLineToPoint(path, nil, rect.size.width/2, rect.size.height-inset)
        CGPathMoveToPoint(path, nil, inset, rect.size.height/2)
        CGPathAddLineToPoint(path, nil, rect.size.width-inset, rect.size.height/2)
        
        CGContextSetLineWidth(ctx, lineWidth)
        CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor().CGColor)
        CGContextSetLineCap(ctx, kCGLineCapRound)
        CGContextAddPath(ctx, path)
        CGContextStrokePath(ctx)
        
    }
}
