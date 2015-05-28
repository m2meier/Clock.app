//
//  TopView.swift
//  Clock
//
//  Created by Meier, Markus on 12.03.2015
//  Copyright (c) 2015 Innotronic Ingenieurbüro GmbH. All rights reserved.
//

import UIKit

@IBDesignable
class TopView: UIView
{
    var myScale: CGFloat = 1.0
    {
        didSet { setNeedsDisplay() }
    }
    
    var myCenter: CGPoint
    {
        return convertPoint( center, fromView: superview )
    }
    
    var myRadius: CGFloat
    {
        return min( bounds.size.width, bounds.size.height ) / 2 * myScale
    }
    
    
    private struct Geometry
    {
        static let CenterRadius: CGFloat = 0.060
        static let CenterColor: UIColor = UIColor.blackColor()
    }
    
    
    override func drawRect( rect: CGRect )
    {
        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM( context, myCenter.x, myCenter.y )
        
        
        // Center
        CGContextSetFillColorWithColor( context, Geometry.CenterColor.CGColor )
        
        CGContextAddArc( context, 0, 0, Geometry.CenterRadius * myRadius, 0, CGFloat( M_PI * 2 ), 1 )
        CGContextFillPath( context )
    }
}