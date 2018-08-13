//
//  BA360AutoChartView.swift
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 8/6/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit
import Charts
import CoreGraphics

enum BA360DataSetType:Int {
    case BA360DataSetTypeHistory = 0
    case BA360DataSetTypeForecast = 1
}

enum BA360ChartColors:String {
    case BA360ChartColorDotGray = "#575757"
    case BA360ChartColorDotRed = "#DC1431"
}

class BA360AutoChartView: LineChartView {
    
    var viewModel:BA360AutoChartViewModel?
    var numberOfDataSet:Int = 0
    var numberOfNewDataSet:Int = 0
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = false
        self.dragEnabled = true
        self.rightAxis.enabled = false
        self.leftAxis.setLabelCount(7, force: true)
        self.xAxis.enabled = true
        self.xAxis.granularityEnabled = true
        self.xAxis.granularity = 1.0
        self.setVisibleXRangeMaximum(4)
        self.setVisibleXRangeMinimum(4)
        self.leftAxis.drawLabelsEnabled = true
        self.leftAxis.axisLineColor = .clear
        self.autoScaleMinMaxEnabled = true
        self.legend.enabled = false
        self.chartDescription = nil
        self.drawGridBackgroundEnabled = true
        self.doubleTapToZoomEnabled = false
        self.setScaleEnabled(true)
        
        self.renderer = BA360LineChartRender(dataProvider: self, animator: self.chartAnimator, viewPortHandler: self.viewPortHandler)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateChartData(_ forHistory:Bool) {
        createData()
        changeViewPort(forHistory)
    }
    
    func createData()  {
        let allValues:[BA360DataSection]? = self.viewModel?.dataToPresent()
        var indexCounter:Int = 0
        
        guard let sections = allValues else {
            return
        }
        
        var allSets:[LineChartDataSet] = []
        
        for (index,section) in sections.enumerated() {
            // For the below section, we need to pass:
            // 1. the last point from above section preceeds it if any
            // 2. the first point from above section after it if any
            
            var prevAbove:Double? = nil
            
            if index - 1 >= 0 {
                let prevAboveSec = sections[index - 1]
                prevAbove = prevAboveSec.rawData.last
            }
            let set = createDataSetForDataSection(section, startIndex: &indexCounter, prevAbove: prevAbove)
            allSets.append(set)
        }
        
        numberOfNewDataSet = allSets.count - numberOfDataSet
        numberOfDataSet = allSets.count
        
        let data = LineChartData(dataSets: allSets)
        self.data = data
    }
    
    func changeViewPort(_ forHistory:Bool) {
        self.xAxis.setLabelCount(5, force: true)
        self.setVisibleXRangeMaximum(4)
        self.setVisibleXRangeMinimum(4)
        self.xAxis.granularity = 1
        guard let viewModel = self.viewModel else {
            return
        }
        if forHistory {
            self.moveViewToX(Double(3))
        } else {
            self.moveViewToX(Double(viewModel.dataCount - 1))
        }
    }
    
    func createDataSetForDataSection(_ dataSection:BA360DataSection, startIndex:inout Int, prevAbove:Double?) -> LineChartDataSet {
        let values:[Double] = dataSection.rawData
        let history:Bool = dataSection.history
        let belowTH:Bool = dataSection.belowTH
        
        var dataArray:[ChartDataEntry] = []
        // append any prev values if any
        if let prev = prevAbove{
            let prevEntry = ChartDataEntry(x: Double(startIndex - 1), y: prev)
            dataArray.append(prevEntry)
        }
        
        for (index, data) in values.enumerated(){
            let yValue = data
            let entry = ChartDataEntry(x: Double(startIndex + index), y: yValue)
            dataArray.append(entry)
        }
        
        startIndex += (dataArray.count - (prevAbove == nil ? 0 : 1))
        
        let dataSet = LineChartDataSet(values: dataArray, label: nil)
        configureAllDataSet(dataSet: dataSet, history: history, belowTH: belowTH, dataCount: dataArray.count, hasPrev: (prevAbove == nil ? false : true))
        
        return dataSet
    }
    
    func insertDataToLeft() {
        // TODO: show loading indicator
        if let highLight = self.lastHighlighted{
            self.viewModel?.lastHighLight = highLight
        }
        
        if viewModel?.currentFetchStatus == BA360AutoChartViewModelFetchStatus.idle{
            viewModel?.fetchHistoryData {
                // TODO: weak self
                self.createData()
                // TODO: hide loading indicator
                
                // TODO: add back cross line
                if let highLight = self.viewModel?.lastHighLight{
                    let hx = highLight.x + 20
                    let hy = highLight.y
                    let newHighLight = Highlight(x: hx, y: hy, dataSetIndex: self.numberOfNewDataSet + highLight.dataSetIndex)
                    self.highlightValue(newHighLight)
                    self.viewModel?.lastHighLight = nil
                }
                // TODO: move chart to correct position
                self.changeViewPort(true)
            }
        }
    }
    
    
    func configureAllDataSet(dataSet:LineChartDataSet, history:Bool, belowTH:Bool, dataCount:Int, hasPrev:Bool) {
        dataSet.drawValuesEnabled = true
        dataSet.drawCirclesEnabled = true
        dataSet.circleRadius = 4
        dataSet.circleHoleRadius = 3
        dataSet.circleHoleColor = UIColor.white
        
        if belowTH{
            var colorArray:[NSUIColor] = []
            for i in 0...dataCount - 1{
                if i == 0 && hasPrev{
                    colorArray.append(ChartColorTemplates.colorFromString(BA360ChartColors.BA360ChartColorDotGray.rawValue))
                } else {
                    colorArray.append(ChartColorTemplates.colorFromString(BA360ChartColors.BA360ChartColorDotRed.rawValue))
                }
            }
            dataSet.circleColors = colorArray
            dataSet.highlightColor = ChartColorTemplates.colorFromString(BA360ChartColors.BA360ChartColorDotRed.rawValue)
        } else {
            var colorArray:[NSUIColor] = []
            for i in 0...dataCount - 1{
                if i == 0 && hasPrev{
                    colorArray.append(ChartColorTemplates.colorFromString(BA360ChartColors.BA360ChartColorDotRed.rawValue))
                } else {
                    colorArray.append(ChartColorTemplates.colorFromString(BA360ChartColors.BA360ChartColorDotGray.rawValue))
                }
            }
            dataSet.circleColors = colorArray
            dataSet.highlightColor = ChartColorTemplates.colorFromString("#0073CF")
        }
        
        dataSet.highlightLineWidth = 3
        // fill the color of history part
        dataSet.fillAlpha = 0.7
        
        let gradientColors = [ChartColorTemplates.colorFromString("#00B3FE").cgColor,
                              ChartColorTemplates.colorFromString("#029AD9").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)
        
        dataSet.fill = Fill(linearGradient: gradient!, angle: 45)
        dataSet.drawFilledEnabled = true
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let optionalContext = UIGraphicsGetCurrentContext()
        guard let context = optionalContext else { return }
        // if highlighting is enabled
        if (valuesToHighlight())
        {
            self.renderer?.drawHighlighted(context: context, indices: self.highlighted)
        }
    }
}
