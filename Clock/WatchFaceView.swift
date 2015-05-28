//
//  WatchFaceView.swift
//  Clock
//
//  Created by Meier, Markus on 12.03.2015
//  Copyright (c) 2015 Innotronic Ingenieurbüro GmbH. All rights reserved.
//

import UIKit

@IBDesignable
class WatchFaceView: UIView
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
        static let BorderWidth: CGFloat = 0.020
        static let BorderColor: UIColor = UIColor.blackColor()
        
        static let DigitDistance: CGFloat = 0.72
        static let DigitFontSize: CGFloat = 0.16
        static let DigitColor: UIColor = UIColor.darkGrayColor()
        
        static let TickDistance: CGFloat = 0.050
        
        static let Tick15Width: CGFloat = 0.020
        static let Tick15Length: CGFloat = 0.10
        static let Tick15Color: UIColor = UIColor.blackColor()
        
        static let Tick05Width: CGFloat = 0.020
        static let Tick05Length: CGFloat = 0.10
        static let Tick05Color: UIColor = UIColor.blackColor()
        
        static let Tick01Width: CGFloat = 0.010
        static let Tick01Length: CGFloat = 0.05
        static let Tick01Color: UIColor = UIColor.grayColor()
        
        static let NumberRadius: CGFloat = 0.06
    }
    
    
    private func drawLine( context: CGContext, from: CGFloat, to: CGFloat, width: CGFloat, color: CGColor )
    {
        CGContextSetStrokeColorWithColor( context, color );
        CGContextSetLineWidth( context, myRadius * width );
        
        CGContextMoveToPoint( context, 0, CGFloat( -from * myRadius ))
        CGContextAddLineToPoint( context, 0, CGFloat( -to * myRadius ))
        CGContextStrokePath( context )
    }
    
    
    func drawText( text: NSString, x: CGFloat, y: CGFloat )
    {
        let font = UIFont.systemFontOfSize( Geometry.DigitFontSize * myRadius )
        let attributes = [ NSFontAttributeName: font, NSForegroundColorAttributeName: Geometry.DigitColor ]
        
        let textSize = text.sizeWithAttributes( attributes )
        
        let posX = ( x * myRadius ) - ( textSize.width / 2 )
        let posY = ( y * myRadius ) - ( textSize.height / 2 )
        
        let textRect = CGRectMake( posX, posY, textSize.width, textSize.height )
        
        text.drawInRect( textRect, withAttributes: attributes )
    }
    
    
    override func drawRect( rect: CGRect )
    {
        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM( context, myCenter.x, myCenter.y )
        
        
        // Border
        CGContextSetStrokeColorWithColor( context, Geometry.BorderColor.CGColor );
        CGContextSetLineWidth(context, myRadius * Geometry.BorderWidth );
        
        CGContextAddArc( context, 0, 0, myRadius, 0, CGFloat( M_PI * 2 ), 1 )
        CGContextStrokePath( context )
        
        
        // Ticks
        CGContextSaveGState( context )
        
        let tickStart = 1 - Geometry.TickDistance
        let tick15End = tickStart - Geometry.Tick15Length
        let tick05End = tickStart - Geometry.Tick05Length
        let tick01End = tickStart - Geometry.Tick01Length
        
        
        for var pos: Int = 0; pos < 60; pos++
        {
            if( pos % 15 == 0 )
            {
                drawLine( context, from: tickStart, to: tick15End, width: Geometry.Tick15Width, color: Geometry.Tick15Color.CGColor )
            }
            else if( pos % 5 == 0 )
            {
                drawLine( context, from: tickStart, to: tick05End, width: Geometry.Tick05Width, color: Geometry.Tick05Color.CGColor )
            }
            else
            {
                drawLine( context, from: tickStart, to: tick01End, width: Geometry.Tick01Width, color: Geometry.Tick01Color.CGColor )
            }
            
            CGContextRotateCTM( context, CGFloat( 2 * M_PI / 60 ))
        }
        
        CGContextRestoreGState( context )
        
        
        for var pos: Int = 0; pos < 12; pos++
        {
            let a : CGFloat = CGFloat( M_PI * 2 / 12 * Double( pos - 2 ))
            let y : CGFloat = sin( a ) * Geometry.DigitDistance
            let x : CGFloat = cos( a ) * Geometry.DigitDistance
            let text : String = ( pos + 1 ).description;
            
            drawText( text, x: x, y: y )
        }
    }
}
