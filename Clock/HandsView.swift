//
//  HandsView.swift
//  Clock
//
//  Created by Meier, Markus on 12.03.2015
//  Copyright (c) 2015 Innotronic Ingenieurbüro GmbH. All rights reserved.
//

import UIKit

protocol HandsViewDataSource: class
{
    func hourForClock( sender: HandsView ) -> Double?
    func minuteForClock( sender: HandsView ) -> Double?
    func secondForClock( sender: HandsView ) -> Double?
}


@IBDesignable
class HandsView: UIView
{
    weak var dataSource: HandsViewDataSource?
    
    
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
        static let HourHandWidth: CGFloat = 0.070
        static let HourHandLength: CGFloat = 0.6
        static let HourHandColor: UIColor = UIColor.blackColor()
        
        static let MinuteHandWidth: CGFloat = 0.050
        static let MinuteHandLength: CGFloat = 0.8
        static let MinuteHandColor: UIColor = UIColor.blackColor()
        
        static let SecondHandWidth: CGFloat = 0.020
        static let SecondHandLength: CGFloat = 0.8
        static let SecondHandColor: UIColor = UIColor.redColor()
    }
    
    
    private func drawLine( context: CGContext, from: CGFloat, to: CGFloat, width: CGFloat, color: CGColor )
    {
        CGContextSetStrokeColorWithColor( context, color );
        CGContextSetLineWidth( context, myRadius * width );
        
        CGContextMoveToPoint( context, 0, CGFloat( -from * myRadius ))
        CGContextAddLineToPoint( context, 0, CGFloat( -to * myRadius ))
        CGContextStrokePath( context )
    }
    
    
    override func drawRect( rect: CGRect )
    {
        let hour = dataSource?.hourForClock( self ) ?? 7.666
        let minute = dataSource?.minuteForClock( self ) ?? 20
        let second = dataSource?.secondForClock( self ) ?? 0
        
        
        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM( context, myCenter.x, myCenter.y )
        
        
        // Hours
        CGContextSaveGState( context )
        CGContextRotateCTM( context, CGFloat( 2 * M_PI * ( hour / 12 + minute / 720 )))
        
        drawLine( context!, from: 0, to: Geometry.HourHandLength, width: Geometry.HourHandWidth, color: Geometry.HourHandColor.CGColor )
        
        CGContextRestoreGState( context )
        
        
        // Minutes
        CGContextSaveGState( context )
        CGContextRotateCTM( context, CGFloat( 2 * M_PI * ( minute / 60 + second / 3600 )))
        
        drawLine( context!, from: 0, to: Geometry.MinuteHandLength, width: Geometry.MinuteHandWidth, color: Geometry.MinuteHandColor.CGColor )
        
        CGContextRestoreGState( context )
        
        
        // Seconds
        CGContextSaveGState( context )
        CGContextRotateCTM( context, CGFloat( 2 * M_PI * second / 60 ))
        
        drawLine( context!, from: 0, to: Geometry.SecondHandLength, width: Geometry.SecondHandWidth, color: Geometry.SecondHandColor.CGColor )
        
        CGContextRestoreGState( context )
    }
}
