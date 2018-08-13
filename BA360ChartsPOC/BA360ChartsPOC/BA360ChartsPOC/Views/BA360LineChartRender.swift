//
//  BA360LineChartRender.swift
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 8/13/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit

class BA360LineChartRender: LineChartRenderer {
    override func drawHighlighted(context: CGContext, indices: [Highlight]) {
        guard
            let dataProvider = dataProvider,
            let lineData = dataProvider.lineData
            else { return }
        
        let chartXMax = dataProvider.chartXMax
        
        context.saveGState()
        
        for high in indices
        {
            guard let set = lineData.getDataSetByIndex(high.dataSetIndex) as? ILineChartDataSet
                , set.isHighlightEnabled
                else { continue }
            
            guard let e = set.entryForXValue(high.x, closestToY: high.y) else { continue }
            
            if !isInBoundsX(entry: e, dataSet: set)
            {
                continue
            }
            
            context.setStrokeColor(set.highlightColor.cgColor)
            context.setLineWidth(set.highlightLineWidth)
            if set.highlightLineDashLengths != nil
            {
                context.setLineDash(phase: set.highlightLineDashPhase, lengths: set.highlightLineDashLengths!)
            }
            else
            {
                context.setLineDash(phase: 0.0, lengths: [])
            }
            
            let x = high.x // get the x-position
            let y = high.y * Double(animator.phaseY)
            
            if x > chartXMax * animator.phaseX
            {
                continue
            }
            
            let trans = dataProvider.getTransformer(forAxis: set.axisDependency)
            
            let pt = trans.pixelForValues(x: x, y: y)
            
            high.setDraw(pt: pt)
            
            // draw the lines
            drawHighlightLines(context: context, point: pt, set: set)
            
            // draw the top layer circle
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: pt.x, y: pt.y), radius: 6, startAngle: CGFloat(0.0), endAngle: CGFloat(2.0 * .pi), clockwise: true)
            
            let shapeLayer = CAShapeLayer()
            
            shapeLayer.lineWidth = 1.0
            shapeLayer.strokeColor = UIColor.clear.cgColor
            shapeLayer.fillColor = set.highlightColor.cgColor
            shapeLayer.path = circlePath.cgPath
            
            shapeLayer.render(in: context)
        }
        
        context.restoreGState()
    }
    
    func isInBoundsX(entry e: ChartDataEntry, dataSet: IBarLineScatterCandleBubbleChartDataSet) -> Bool{
        let entryIndex = dataSet.entryIndex(entry: e)
        return Double(entryIndex) < Double(dataSet.entryCount) * animator.phaseX
    }

}
