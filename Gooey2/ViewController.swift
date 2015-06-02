//
//  ViewController.swift
//  Gooey2
//
//  Created by Pål Forsberg on 2015-02-18.
//  Copyright (c) 2015 Pål Forsberg. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GooeyDelegate {
    var gooey = Gooey(frame: CGRect(x: 100, y: 478, width: 120, height: 120))
    var durationLabel : UILabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        gooey.color = UIColor(red: 29/255.0, green: 163/255, blue: 1, alpha: 1.0)
        gooey.delegate = self
        self.view.addSubview(gooey)
    
        
//        let slider = UISlider(frame: CGRect(x: 20, y: 300, width: 280, height: 40))
        let slider = UISlider(frame: CGRect(x: 20, y: 300, width: 280, height: 40))
        slider.addTarget(self, action: "update:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(slider)
        
        let label = UILabel(frame: CGRect(x: 0, y: 350, width: 320, height: 40))
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        self.view.addSubview(label)
        
        durationLabel = label
        
    }
    
    func update(s : UISlider){
        let duration = 0.13 + Double(s.value)
        
        let string = NSMutableAttributedString(string: String(format: "Duration: %0.2f", duration))
        string.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Bold", size: 18.0)!, range: NSMakeRange(0, 9))
        self.durationLabel.attributedText = string
        self.gooey.duration = duration
    }
    
    func gooeyDidSelectIndex(index: Int) {
        println("Gooey did select index \(index)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

