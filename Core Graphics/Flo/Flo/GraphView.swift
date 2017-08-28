//
//  GraphView.swift
//  Flo
//
//  Created by Qingchuan Zhu on 1/3/17.
//  Copyright © 2017 ProgrammingC. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    //1 - the properties for the gradient, inspectable
    @IBInspectable var startColor:UIColor = UIColor.green
    @IBInspectable var endColor:UIColor = UIColor.red
    
    //Weekly sample data
    var graphPoints: [Int] = [4, 2, 6, 4, 5, 8, 3]
    
    override func draw(_ rect: CGRect) {
        //--------------- Drawing background gradient
        //1 - create a rounded clipp
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8.0, height: 8.0))
        path.addClip()
        //2 - get the current context
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.cgColor, endColor.cgColor]
        
        //3 - set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //4 - set up the color stops
        let colorStops:[CGFloat] = [0.0, 1.0]
        
        //5 - create the gradient
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorStops)
        
        //6 - draw the gradient
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: self.bounds.height)
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        
        //----------------- Drawing the lines
        //calculate the x point
        let margin:CGFloat  = 20.0
        
        let columnXPoint = {
            (column:Int) -> CGFloat in
            let spacer = (rect.width - margin*2 - 4) / CGFloat((self.graphPoints.count - 1))
            var x:CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        
        // calculate the y point
        let topBoarder:CGFloat = 60.0
        let bottomBoarder:CGFloat = 50.0
        let graphHeight = rect.height - topBoarder - bottomBoarder
        let maxValue = graphPoints.max()
        let columnYPoint = {
            (graphPoint:Int) -> CGFloat in
            var y:CGFloat = CGFloat(graphPoint) /
                CGFloat(maxValue!) * graphHeight
            y = graphHeight + topBoarder - y // Flip the graph
            return y
        }
        
        // drawing the line
        UIColor.white.setStroke()
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
        for i in 1...graphPoints.count - 1 {
            let nextPoint = CGPoint(x: columnXPoint(i), y:columnYPoint(graphPoints[i]))
            linePath.addLine(to: nextPoint)
        }
        
        //-------Create the clipping path for the graph gradient
        
        //1 - save the state of the context (commented out for now)
        context!.saveGState()
        //2 - make a copy of the path
        let clippingPath = linePath.copy() as! UIBezierPath
        
        //3 - add lines to the copied path to complete the clip area
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count - 1), y: rect.height))
        clippingPath.addLine(to: CGPoint(x: columnXPoint(0), y: rect.height))
        clippingPath.close()
        
        //4 - add the clipping path to the context
        clippingPath.addClip()
        
        //5 - fill the path with gradient
        
        context!.drawLinearGradient(gradient!, start: CGPoint(x:0, y:columnYPoint(maxValue!)), end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        context!.restoreGState()
        
        //draw the line on top of the clipped gradient
        linePath.lineWidth = 2.0
        linePath.stroke()
        
        //-------Draw the circles on top of graph stroke
        for i in 0..<graphPoints.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            point.x -= 5.0/2
            point.y -= 5.0/2
            let pointPath = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: 5.0, height: 5.0)))
            UIColor.white.setFill()
            pointPath.fill()
        }
        
        //Draw horizontal graph lines on the top of everything
        let linesPath = UIBezierPath()
        //top line
        linesPath.move(to: CGPoint(x: margin, y: topBoarder))
        linesPath.addLine(to: CGPoint(x: rect.width - margin, y: topBoarder))
        //center line
        linesPath.move(to: CGPoint(x: margin, y: topBoarder + graphHeight/2))
        linesPath.addLine(to: CGPoint(x: rect.width - margin, y: topBoarder + graphHeight/2))
        //bottom line
        linesPath.move(to: CGPoint(x: margin, y: topBoarder + graphHeight))
        linesPath.addLine(to: CGPoint(x: rect.width - margin, y: topBoarder + graphHeight))
        
        let linesColor = UIColor(white: 1.0, alpha: 0.3)
        linesColor.setStroke()
        linesPath.lineWidth = 1.0
        linesPath.stroke()
    }
    

}
