//
//  SpringAnimationValues.swift
//
//  Animates CALayer with spring damping effect.
//
//  Created by Evgenii Neumerzhitckii on 22/11/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import UIKit

class SpringAnimation {
  // Animates layer with spring effect.
    
    class func animateCalmly(layer: CALayer,
    keypath: String,
    duration: CFTimeInterval,
    fromValue: Double,
    toValue: Double,
    onFinished: (()->())?) {

        CATransaction.begin()
        CATransaction.setCompletionBlock(onFinished)
        
        let animation = create(keypath, duration: duration,
            fromValue: fromValue, toValue: toValue)
        
        layer.addAnimation(animation, forKey: keypath + " spring animation")
        CATransaction.commit()
    }

  // Creates CAKeyframeAnimation object
    class func create(keypath: String,
        duration: CFTimeInterval,
        fromValue: AnyObject,
        toValue: AnyObject) -> CABasicAnimation {
            let animation = CABasicAnimation(keyPath: keypath)
            animation.fromValue = fromValue
            animation.toValue = toValue
            animation.repeatCount = 0
            animation.duration = duration
            
            return animation
    }
    
    /*****SPRING******/
    
    class func animate(layer: GooeyLayer,
        keypath: String,
        duration: CFTimeInterval,
        usingSpringWithDamping: Double,
        initialSpringVelocity: Double,
        fromValue: Double,
        toValue: Double,
        onFinished: (()->())?) {

            CATransaction.begin()
            CATransaction.setCompletionBlock(onFinished)
            
            let animation = createSpring(keypath, duration: duration,
                usingSpringWithDamping: usingSpringWithDamping,
                initialSpringVelocity: initialSpringVelocity,
                fromValue: fromValue, toValue: toValue)
            
            layer.addAnimation(animation, forKey: keypath + " spring animation")

            CATransaction.commit()
    }
  class func createSpring(keypath: String,
    duration: CFTimeInterval,
    usingSpringWithDamping: Double,
    initialSpringVelocity: Double,
    fromValue: Double,
    toValue: Double) -> CAKeyframeAnimation {

    let dampingMultiplier = Double(10)
    let velocityMultiplier = Double(10)

    let values = animationValues(fromValue, toValue: toValue,
      usingSpringWithDamping: dampingMultiplier * usingSpringWithDamping,
        initialSpringVelocity: velocityMultiplier * initialSpringVelocity, duration:duration)

    let animation = CAKeyframeAnimation(keyPath: keypath)
    animation.values = values
    animation.duration = duration

    return animation
  }
    class func animationValues(fromValue: Double, toValue: Double,
        usingSpringWithDamping: Double, initialSpringVelocity: Double, duration : Double) -> [Double]{
            
            let numOfPoints : Int = Int(duration * 60)
            var values = [Double](count: numOfPoints, repeatedValue: 0.0)
            
            let distanceBetweenValues = toValue - fromValue
            
            for point in (0..<numOfPoints) {
                let x = (Double(point) / Double(numOfPoints))
                let valueNormalized = animationValuesNormalized(x,
                    usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity)
                
                let value = toValue - distanceBetweenValues * valueNormalized
                values[point] = value
//                println("lastVal: \(values[point]) x: \(x)")
            }
            
            return values
    }

  private class func animationValuesNormalized(x: Double, usingSpringWithDamping: Double,
    initialSpringVelocity: Double) -> Double {
      
    return pow(M_E, -usingSpringWithDamping * x) * cos(initialSpringVelocity * x)
  }


/****VECTORS*****/
//    
//    class func animateVectors(layer: GooeyLayer,
//        keypath: String,
//        duration: CFTimeInterval,
//        usingSpringWithDamping: Double,
//        initialSpringVelocity: Double,
//        fromValue: Vectors,
//        toValue: Vectors,
//        onFinished: (()->())?) {
//            println("AnimateSpringVectors")
//            CATransaction.begin()
//            CATransaction.setCompletionBlock(onFinished)
//            
//            let animation = createVectors(keypath, duration: duration,
//                usingSpringWithDamping: usingSpringWithDamping,
//                initialSpringVelocity: initialSpringVelocity,
//                fromValue: fromValue, toValue: toValue)
//            
//            layer.addAnimation(animation, forKey: keypath + " spring animation")
//            CATransaction.commit()
//    }
//    
//    class func createVectors(keypath: String,
//        duration: CFTimeInterval,
//        usingSpringWithDamping: Double,
//        initialSpringVelocity: Double,
//        fromValue: Vectors,
//        toValue: Vectors) -> CAKeyframeAnimation {
//            
//            let values = animationVectors(fromValue, toValue: toValue, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, duration: duration)
//        
//            let animation = CAKeyframeAnimation(keyPath: keypath)
//            animation.values = values
//            animation.duration = duration
//            
//            return animation
//    }
//    
//    class func animationVectors(fromValue: Vectors, toValue: Vectors,
//        usingSpringWithDamping: Double, initialSpringVelocity: Double, duration : Double) -> [Vectors]{
//            
//            let numOfPoints : Int = Int(duration * 60) //500
//            var values = [Vectors](count: numOfPoints+1, repeatedValue: VectorsFunc.zero())
//            
//            let distanceBetweenValues =  VectorsFunc.minus(toValue, v2:fromValue)
//            
//            for point in (0..<numOfPoints+1) {
//                let x = Double(point) / Double(numOfPoints)
//                let valueNormalized = animationValuesNormalized(x,
//                    usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity)
//                
//                let foo = VectorsFunc.multConst(distanceBetweenValues, k:CGFloat(valueNormalized))
//                let value = VectorsFunc.minus(toValue, v2:foo)
//                NSLog("v: %@  x: %f", value[0], valueNormalized)
//                values[point] = value
//            }
//            
//            return values
//    }
//
//



}
