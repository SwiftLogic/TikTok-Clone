//
//  SegmentedProgressView.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 1/8/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import UIKit
class SegmentedProgressView: UIView {
    
    

    //MARK: - Properties
    var aPath: UIBezierPath = UIBezierPath()
    let shapeLayer = CAShapeLayer()
    var segments = [UIView]()
    
//    fileprivate let verticalLine : UIView = {
//        let view = UIView()
////        view.backgroundColor = .red
//        return view
//    }()
    
    //MARK: - Draw Rect
    override func draw(_ rect: CGRect) {
        //draw a straight line with UIBenzierPath
        // Specify the point that the path should start get drawn and close it.
        aPath.move(to: CGPoint(x: 0.0, y: 0.0))
        aPath.addLine(to: CGPoint(x: self.frame.size.width, y: 0.0))
        aPath.move(to: CGPoint(x: 0.0, y: 0.0))
        aPath.close()
        handleSetUpTrackLayer()
        handleSetUpShapeLayer()
        
//        addSubview(verticalLine)
//        verticalLine.centerInSuperview(size: .init(width: 5, height: 6))
//        verticalLine.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -3).isActive = true
    }


    
    //MARK: - Handlers
    fileprivate func handleSetUpTrackLayer() {
        let trackLayer = CAShapeLayer()
        trackLayer.path = aPath.cgPath
        trackLayer.lineWidth = 6
        trackLayer.strokeColor = UIColor.white.withAlphaComponent(0.2).cgColor
        trackLayer.lineCap = .round
        trackLayer.strokeEnd = 1
        layer.addSublayer(trackLayer)

    }
    
    
    fileprivate func handleSetUpShapeLayer() {
        //set the path of a shapelayer to the uibenzier path
        shapeLayer.path = aPath.cgPath
        shapeLayer.strokeColor = snapchatBlueColor.cgColor
        shapeLayer.lineWidth = 6
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = .round
        layer.addSublayer(shapeLayer)
    }
    
    
    func setProgress(_ progress: CGFloat) {
        shapeLayer.strokeEnd = progress
      
    }
    
    
    func pauseProgress() {
        let newSegment = handleCreateSegment()
        addSubview(newSegment)
        newSegment.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -3).isActive = true
        segments.append(newSegment)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // your code here
            self.handlePositionSegment(newSegment: newSegment)
        }
    }
    
    
    fileprivate func handlePositionSegment(newSegment: UIView) {
        let positionPath = CGPoint(x: shapeLayer.strokeEnd * frame.width, y: 0)
        newSegment.frame.origin.x = positionPath.x
        newSegment.backgroundColor = .white
    }
    
    
    
    fileprivate func handleCreateSegment() -> UIView {
         let view = UIView()
         view.translatesAutoresizingMaskIntoConstraints = false
         view.constrainWidth(constant: 5)
         view.constrainHeight(constant: 6)
        return view
    }
}
