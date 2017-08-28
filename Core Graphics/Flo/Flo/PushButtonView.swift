//
//  PushButtonView.swift
//  Flo
//
//  Created by Qingchuan Zhu on 12/24/16.
//  Copyright © 2016 ProgrammingC. All rights reserved.
//

import UIKit

@IBDesignable class PushButtonView: UIButton {

    @IBInspectable var fillColor:UIColor = UIColor.green
    @IBInspectable var isAddButton:Bool = true
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        //------ Drawing the circle
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
        //------ Circle done
        
        //------ Drawing the horizantal line
        //1. set up the width and height variables
        //for the horizontal stroke
        let plusHeight: CGFloat = 3.0
        let plusWidth = min(bounds.width, bounds.height) * 0.6
        
        //2. create the path
        let plusHPath = UIBezierPath()
        
        //3. set the path's line width to the height of the stroke
        plusHPath.lineWidth = plusHeight
        
        //4. move the initial point of the path
        //to the start of the horizontal stroke
        plusHPath.move(to: CGPoint(
            x:bounds.width/2 - plusWidth/2,
            y:bounds.height/2))
        //5. add a point to the path at the end of the stroke
        plusHPath.addLine(to: CGPoint(
            x:bounds.width/2 + plusWidth/2,
            y:bounds.height/2))
        //------- Horizantal line done
        
        //6. move the initial point of the path
        //to the start of the vertical stroke
        if isAddButton {
            plusHPath.move(to: CGPoint(x: bounds.width/2 - plusHeight/2, y: bounds.height/2 - plusWidth/2))
            //7. add a point to the path at the end of the stroke
            plusHPath.addLine(to: CGPoint(x: bounds.width/2 - plusHeight/2, y: bounds.height/2 + plusWidth/2))
        }
        
        //8. set the stroke color
        UIColor.white.setStroke()
        
        //9. draw the stroke
        plusHPath.stroke()
        
    }
    

}
