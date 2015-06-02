//
//  Vectors.swift
//  Gooey2
//
//  Created by Pål Forsberg on 2015-02-20.
//  Copyright (c) 2015 Pål Forsberg. All rights reserved.
//

import UIKit

class VectorsFunc {
    
    class func plus(v1 : Vectors, v2 : Vectors)->Vectors{
        let d1 = CGVector(dx:v1.0.dx + v2.0.dx, dy:v1.0.dy + v2.0.dy)
        let d2 = CGVector(dx:v1.1.dx + v2.1.dx, dy:v1.1.dy + v2.1.dy)
        let d3 = CGVector(dx:v1.2.dx + v2.2.dx, dy:v1.2.dy + v2.2.dy)
        let d4 = CGVector(dx:v1.3.dx + v2.3.dx, dy:v1.3.dy + v2.3.dy)

        return (d1, d2, d3, d4)
    }
    
    class func minus(v1 : Vectors, v2 : Vectors)->Vectors{
        let d1 = CGVector(dx:v1.0.dx - v2.0.dx, dy:v1.0.dy - v2.0.dy)
        let d2 = CGVector(dx:v1.1.dx - v2.1.dx, dy:v1.1.dy - v2.1.dy)
        let d3 = CGVector(dx:v1.2.dx - v2.2.dx, dy:v1.2.dy - v2.2.dy)
        let d4 = CGVector(dx:v1.3.dx - v2.3.dx, dy:v1.3.dy - v2.3.dy)
        return (d1, d2, d3, d4)
    }
    
    class func mult(v1 : Vectors, v2 : Vectors)->Vectors{
        let d1 = CGVector(dx:v1.0.dx * v2.0.dx, dy:v1.0.dy * v2.0.dy)
        let d2 = CGVector(dx:v1.1.dx * v2.1.dx, dy:v1.1.dy * v2.1.dy)
        let d3 = CGVector(dx:v1.2.dx * v2.2.dx, dy:v1.2.dy * v2.2.dy)
        let d4 = CGVector(dx:v1.3.dx * v2.3.dx, dy:v1.3.dy * v2.3.dy)
        return (d1, d2, d3, d4)
    }

    class func multConst(v1 : Vectors, k : CGFloat)->Vectors{
        let d1 = CGVector(dx:v1.0.dx * k, dy:v1.0.dy * k)
        let d2 = CGVector(dx:v1.1.dx * k, dy:v1.1.dy * k)
        let d3 = CGVector(dx:v1.2.dx * k, dy:v1.2.dy * k)
        let d4 = CGVector(dx:v1.3.dx * k, dy:v1.3.dy * k)
        return (d1, d2, d3, d4)
    }
    
    class func zero()->Vectors{
        return (CGVector(dx: 0, dy: 0),CGVector(dx: 0, dy: 0),CGVector(dx: 0, dy: 0),CGVector(dx: 0, dy: 0))
    }
}




