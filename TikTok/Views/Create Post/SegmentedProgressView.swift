//
//  SegmentedProgressView.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 1/8/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import UIKit
class SegmentedProgressView: UIView {
//    override func draw(_ rect: CGRect) {
//        let aPath = UIBezierPath()
//
//        aPath.move(to: CGPoint(x:20, y:50))
//
//        aPath.addLine(to: CGPoint(x:300, y:50))
//
//        //Keep using the method addLineToPoint until you get to the one where about to close the path
//
//        aPath.close()
//
//        //If you want to stroke it with a red color
//        UIColor.red.set()
//        aPath.stroke()
//        //If you want to fill it as well
//        aPath.fill()
//
//
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = aPath.cgPath
//        shapeLayer.strokeColor = UIColor.yellow.withAlphaComponent(0.5).cgColor
//        shapeLayer.lineWidth = 10
//        layer.addSublayer(shapeLayer)
//
//    }
    
    
    var aPath: UIBezierPath = UIBezierPath()
    let shapeLayer = CAShapeLayer()

   
    
    

    
    
    
        override func draw(_ rect: CGRect) {
            
            //draw a rect with uibezier path
            // Specify the point that the path should start get drawn.
                   aPath.move(to: CGPoint(x: 0.0, y: 0.0))
                
//                   // Create a line between the starting point and the bottom-left side of the view.
//                   aPath.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
//
                   // Create the bottom line (bottom-left to bottom-right).
            aPath.addLine(to: CGPoint(x: self.frame.size.width, y: 0.0))
                
            aPath.move(to: CGPoint(x: 0.0, y: 0.0))

                   // Create the vertical line from the bottom-right to the top-right side.
//                   aPath.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
    
            //Keep using the method addLineToPoint until you get to the one where about to close the path
    
            aPath.close()

            
           let trackLayer = CAShapeLayer()
           trackLayer.path = aPath.cgPath
           trackLayer.lineWidth = 6
           trackLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
           trackLayer.lineCap = .round
           trackLayer.strokeEnd = 1
           layer.addSublayer(trackLayer)

    
            //set the path of a shapelayer to the uibenzier path
            shapeLayer.path = aPath.cgPath
            shapeLayer.strokeColor = snapchatBlueColor.cgColor
            shapeLayer.lineWidth = 6
            shapeLayer.strokeEnd = 0
            shapeLayer.lineCap = .round
            layer.addSublayer(shapeLayer)
            
            
           

//
        }

}
