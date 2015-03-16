//
//  Gooey.swift
//  Gooey2
//
//  Created by Pål Forsberg on 2015-02-18.
//  Copyright (c) 2015 Pål Forsberg. All rights reserved.
//

import UIKit

enum State {
    case Open
    case Closed
    case Animating
}

protocol GooeyDelegate{
    func gooeyDidSelectIndex(index : Int)
}

class Gooey : UIView, GooeyItemDelegate{
    
    var gooey : GooeyLayer
    var state : State = State.Closed
    
    var items : [GooeyItem] = [GooeyItem]()
    
    let angles : [CGFloat] = [Gooey.radians(40), Gooey.radians(90), Gooey.radians(140)]
    let bridgeAngles : [CGFloat] = [Gooey.radians(-50), Gooey.radians(0), Gooey.radians(50)]
    var duration : Double = 0.13
    var delegate : GooeyDelegate?
    let gooeyImage = Cross()
    var color : UIColor?{
        didSet{
            gooey.color = color?.CGColor
            for i in items{
                i.color = color
            }
        }
    }
    
    class func radians(degrees: CGFloat)->CGFloat {
        return degrees * CGFloat(M_PI) / 180
    }
    
    override init(frame: CGRect) {
        gooey = GooeyLayer()
        
        let item1 = GooeyItem()
        let item2 = GooeyItem()
        let item3 = GooeyItem()
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        
        gooey.contentsScale = UIScreen.mainScreen().scale
        let gooeywidth = min(self.frame.size.width, self.frame.size.height)
        gooey.frame = CGRect(x:self.frame.size.width/2-gooeywidth/2, y:self.frame.size.height-gooeywidth, width:gooeywidth, height:gooeywidth)
        gooey.masksToBounds = false
        gooey.setNeedsDisplay()
        
        let width : CGFloat = 26
        gooeyImage.contentScaleFactor = UIScreen.mainScreen().scale
        gooeyImage.frame = CGRect(x: self.frame.size.width/2-width/2, y: self.frame.size.height/2-width/2, width: width, height: width)
        gooeyImage.setNeedsDisplay()
        gooeyImage.backgroundColor = UIColor.clearColor()
        
        self.layer.addSublayer(gooey)
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.addSubview(gooeyImage)
        
        let tapper = UITapGestureRecognizer(target: self, action: "tapped:")
        self.addGestureRecognizer(tapper)
        
        addItem(item1)
        addItem(item2)
        addItem(item3)
        
        self.bringSubviewToFront(gooeyImage)        
    }
    
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        for v in items{
            if v.pointInside(point, withEvent: event) {
                return true
            }
        }
        return true
    }
    
    func tapped(tapper : UITapGestureRecognizer){
        for v in items{
            if v.state == State.Animating{
                return
            }
        }
        
        let point = tapper.locationInView(tapper.view)
        
        if(!CGRectContainsPoint(CGRectInset(gooey.frame, gooey.insets!, gooey.insets!), point)){
            return
        }
        if (state == State.Closed){
            animateOpen(self.duration)
            state = State.Open
        } else if(state == State.Open){
            animateClose(self.duration)
            state = State.Closed
        }
    }

    
    func addItem(v : GooeyItem){
        
        let angle = angles[items.count]
        let bridgeAngle = bridgeAngles[items.count]
        var point = CGPoint(x: self.frame.size.width/2 - cos(angle) * 65, y: self.frame.size.height/2 - sin(angle) * 65)
        v.frame = CGRect(x: 0, y: 0, width: 60, height: 78)
        v.angle = bridgeAngle
        v.center = CGPoint(x: gooey.frame.origin.x + point.x, y: gooey.frame.origin.y + point.y)
        v.color = self.color
        v.delegate = self
        v.imageView.image = UIImage(named: "p.png")
        self.addSubview(v)
        items.append(v)
        
    }
    
    func animateOpen(duration : Double){
        
        for i in 0...items.count-1{
            let b = items[i]
            let angle = angles[i]
            let delay = duration * Double(i) + duration*2
            b.animateOpen(duration, delay: delay)
        }
        
        gooeyImage.animate(45, fromangle:0, duration: duration*2)
        
        let out1 = gooey.getAnimation(duration*2.5, direction: Direction.LeftOut, type: Animation.Calm)
        let out2 = gooey.getAnimation(duration*2.5, direction: Direction.RightOut, type: Animation.Calm)
        let in1 = gooey.getAnimation(duration * 8, direction: Direction.Back, type: Animation.Gooey)
        gooey.animateGroup([out1, out2, in1])
    }
    
    func animateClose(duration : Double){
        
        for i in 1...items.count {
            let b = items[items.count - i]
            let angle = angles[angles.count - i]
            let delay = Double(i-1) * (duration) + duration/**1.5*/
            b.animateClose(duration, delay: delay)
        }
    
        gooeyImage.animate(0, fromangle:45, duration: duration*2)
        
        let out1 = gooey.getAnimation(duration * 3.0, direction: Direction.RightOut, type: Animation.Calm)
        let out2 = gooey.getAnimation(duration * 2.1, direction: Direction.LeftOut, type: Animation.Calm)
        let in1 = gooey.getAnimation(duration * 8, direction: Direction.Back, type: Animation.Gooey)
        gooey.animateGroup([out1, out2, in1])
    }
    
    func gooeyItemDidSelect(item: GooeyItem) {
        var i = 0
        for v in items{
            if v == item{
                break
            }
            i++
        }
        let index = i
        self.delegate?.gooeyDidSelectIndex(index)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
