//
//  CounterView.swift
//  Flo
//
//  Created by Qingchuan Zhu on 12/28/16.
//  Copyright © 2016 ProgrammingC. All rights reserved.
//

import UIKit

let NoOfGlassess = 8
let π: CGFloat = CGFloat(M_PI)

@IBDesignable class CounterView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var counter:Int = 5 {
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable var outlineColor:UIColor = UIColor.blue
    @IBInspectable var counterColor:UIColor = UIColor.orange
    
    override func draw(_ rect: CGRect) {
        //---- Drawing the background arc
        // 1. Define the center point of view
        let center_x = rect.midX
        let center_y = rect.midY
        let arc_center = CGPoint(x: center_x, y: center_y)
        // 2. Calculate the radius based on the dimension of the view
        let radius = min(rect.width, rect.height) / 3.0
        // 3. Define the thickness of the arc
        let thickness = radius
        // 4. Define the start/end position of the arc
        let start_p = π * 3/4
        let end_p = π / 4
        // 5. Create the arc based on the parameters
        let arc_path = UIBezierPath(arcCenter: arc_center, radius: radius, startAngle: start_p, endAngle: end_p, clockwise: true)
        // 6. Set the line width and color
        counterColor.setStroke()
        arc_path.lineWidth = thickness
        arc_path.stroke()
        
        //---- Drawing the outline
        //1 - first calculate the difference between the start/end angles
        //ensuring it is positive
        let angleDifference = 2 * π + end_p - start_p
        
        //2. then calculate the angle span for each single glass
        let angleSpanPerGlass = angleDifference/CGFloat(NoOfGlassess)
        
        //3. then multiply out by the actual glasses drunk
        let currentAngleSpan = angleSpanPerGlass * CGFloat(counter) + start_p
        
        //4 - draw the outer arc
        let outlinePath = UIBezierPath(arcCenter: arc_center, radius: radius + thickness/2 - 2.5, startAngle: start_p, endAngle: currentAngleSpan, clockwise: true)
        
        //5 - draw the inner arc
        outlinePath.addArc(withCenter: arc_center, radius: radius - thickness/2 , startAngle: currentAngleSpan, endAngle: start_p, clockwise: false)
        
        //6 - close the path
        outlinePath.close()
        outlinePath.lineWidth = 5.0
        outlineColor.setStroke()
        outlinePath.stroke()
    }

}
