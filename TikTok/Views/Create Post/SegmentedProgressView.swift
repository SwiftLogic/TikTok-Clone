//
//  SegmentedProgressView.swift
//  TikTok
//
//  Created by Osaretin Uyigue on 1/8/21.
//  Copyright © 2021 Osaretin Uyigue. All rights reserved.
//

import UIKit
class SegmentedProgressView: UIView {
    
   //MARK: - Init
      //this how to do a custom init
      required init(width: CGFloat) {
          self.width = width
          super.init(frame: CGRect.zero)
          handleDrawPaths()
      }
      
      
      
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK: - Properties
    private let width: CGFloat
    var aPath: UIBezierPath = UIBezierPath()
    var segments = [UIView]()
    var segmentPoints = [CGFloat]()
    
    
    let shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = snapchatBlueColor.cgColor
        shapeLayer.lineWidth = 6
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = .round
        return shapeLayer
    }()
    
    
   fileprivate let trackLayer: CAShapeLayer = {
        let trackLayer = CAShapeLayer()
        trackLayer.lineWidth = 6
        trackLayer.strokeColor = UIColor.white.withAlphaComponent(0.2).cgColor
        trackLayer.lineCap = .round
        trackLayer.strokeEnd = 1
        return trackLayer
    }()
    
    
    
    
    //MARK: - Draw Rect
//    override func draw(_ rect: CGRect) {
//        //draw a straight line with UIBenzierPath
//        // Specify the point that the path should start get drawn and close it.
//        aPath.move(to: CGPoint(x: 0.0, y: 0.0))
//        aPath.addLine(to: CGPoint(x: self.frame.size.width, y: 0.0))
//        aPath.move(to: CGPoint(x: 0.0, y: 0.0))
//        aPath.close()
//        handleSetUpTrackLayer()
//        handleSetUpShapeLayer()
//
//    }


    
    //MARK: - Handlers
    
    
    fileprivate func handleDrawPaths() {
        //draw a straight line with UIBenzierPath
        // Specify the point that the path should start get drawn and close it.
        aPath.move(to: CGPoint(x: 0.0, y: 0.0))
        aPath.addLine(to: CGPoint(x: width, y: 0.0))
        aPath.move(to: CGPoint(x: 0.0, y: 0.0))
        aPath.close()
        handleSetUpTrackLayer()
        handleSetUpShapeLayer()

    }
    
    fileprivate func handleSetUpTrackLayer() {
        trackLayer.path = aPath.cgPath
        layer.addSublayer(trackLayer)
    }
    
    
    fileprivate func handleSetUpShapeLayer() {
        //set the path of a shapelayer to the uibenzier path
        shapeLayer.path = aPath.cgPath
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
        segmentPoints.append(shapeLayer.strokeEnd)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // your code here
            self.handlePositionSegment(newSegment: newSegment)
        }
    }
    
    
    fileprivate func handlePositionSegment(newSegment: UIView) {
        let positionPath = CGPoint(x: shapeLayer.strokeEnd * frame.width, y: 0)
        newSegment.constrainToLeft(paddingLeft: positionPath.x)
//        newSegment.frame.origin.x = positionPath.x
        newSegment.backgroundColor = .white
        print("segmets:", segments.count)
    }
    
    
    
    fileprivate func handleCreateSegment() -> UIView {
         let view = UIView()
         view.translatesAutoresizingMaskIntoConstraints = false
         view.constrainWidth(constant: 3)
         view.constrainHeight(constant: 6)
        return view
    }
    
    
    
    func handleRemoveLastSegment() {
        segments.last?.removeFromSuperview()
        segmentPoints.removeLast()
        segments.removeLast()
        shapeLayer.strokeEnd = segmentPoints.last ?? 0
        print("segmets:", segments.count)

    }
    
    
}


