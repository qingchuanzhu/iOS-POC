//
//  BA360ChartSelectionDot.swift
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 6/13/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit

class BA360ChartSelectionDot: UIView {
    
    var shapeLayer:CAShapeLayer? // The sublayer drawing the circle
    
    var radius:CGFloat = 1 {
        willSet{
            if newValue < 0 {
                fatalError("Trying to set radius less than 0")
            }
        }
        didSet {
            dimensionChanged()
        }
    }
    
    var fillColor:UIColor = UIColor.clear {
        didSet {
            colorChanged()
        }
    }
    
    var borderColor:UIColor = UIColor.black {
        didSet {
            colorChanged()
        }
    }
    
    var lineColor:UIColor = UIColor.black {
        didSet {
            colorChanged()
        }
    }
    
    var borderWith:CGFloat = 0 {
        willSet{
            if newValue < 0 {
                fatalError("Trying to set radius less than 0")
            }
        }
        didSet {
            dimensionChanged()
        }
    }
    
    var dimension:CGFloat {
        return (radius + borderWith) * 2.0
    }

    /// empty init method
    init() {
        super.init(frame: .zero)
        dotCommonInit()
    }
    
    /// frame will be discarded, the size is based on the radius parameters
    override init(frame: CGRect) {
        super.init(frame: frame)
        dotCommonInit()
    }
    
    func dotCommonInit() {
        backgroundColor = UIColor.clear
        
        shapeLayer = CAShapeLayer()
        layer.addSublayer(shapeLayer!)
        redrawTheDot()
    }
    
    func dimensionChanged() {
        redrawTheDot()
    }
    
    func colorChanged() {
        redrawTheDot()
    }
    
    func redrawTheDot() {
        shapeLayer?.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        self.frame.size = CGSize(width: dimension, height: dimension)
        
        shapeLayer?.lineWidth = 1.0
        shapeLayer?.strokeColor = self.lineColor.cgColor
        shapeLayer?.fillColor = self.fillColor.cgColor
        
        let arcCenter = self.center
        let radius = self.radius
        let startAngle = CGFloat(0.0)
        let endAngle = CGFloat(2.0 * .pi)
        let clockwise = true
        
        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        shapeLayer?.path = circlePath.cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
}
