//
//  ClockViewController.swift
//  Clock
//
//  Created by Meier, Markus on 28.02.2015
//  Copyright (c) 2015 Innotronic Ingenieurbüro GmbH. All rights reserved.
//

import UIKit


class ClockViewController: UIViewController, UIScrollViewDelegate, HandsViewDataSource
{
    @IBOutlet weak var clockView: ClockView!
    {
        didSet
        {
            // clockView.addGestureRecognizer( UIPanGestureRecognizer( target: clockView, action: "pan:" ))
            // clockView.addGestureRecognizer( UIPinchGestureRecognizer( target: clockView, action: "scale:" ))
        }
    }
    
    @IBOutlet weak var faceView: WatchFaceView!
    {
        didSet
        {
            faceView.myScale = myScale;
        }
    }
    
    @IBOutlet weak var handsView: HandsView!
    {
        didSet
        {
            handsView.myScale = myScale
            handsView.dataSource = self
        }
    }
    
    @IBOutlet weak var topView: TopView!
    {
        didSet
        {
            topView.myScale = myScale;
        }
    }
    
    var myScale: CGFloat = 0.90
    {
        didSet
        {
            faceView.myScale = myScale
            handsView.myScale = myScale
            topView.myScale = myScale
        }
    }
    
    var time: NSDateComponents?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        updateTime()
        
        let timer = NSTimer.scheduledTimerWithTimeInterval( 1, target: self, selector: Selector( "updateTime" ), userInfo: nil, repeats: true )
        timer.tolerance = 0.1
    }
    
    
    func updateTime()
    {
        let calendar = NSCalendar.currentCalendar()
        time = calendar.components( [.Hour, .Minute, .Second], fromDate: NSDate() )
        
        handsView.setNeedsDisplay()
    }
    
    func hourForClock( sender: HandsView ) -> Double?
    {
        return Double( time?.hour ?? 0 )
    }
    
    func minuteForClock( sender: HandsView ) -> Double?
    {
        return Double( time?.minute ?? 0 )
    }
    
    func secondForClock( sender: HandsView ) -> Double?
    {
        return Double( time?.second ?? 0 )
    }

}

