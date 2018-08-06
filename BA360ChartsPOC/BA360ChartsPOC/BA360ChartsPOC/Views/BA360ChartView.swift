//
//  BA360ChartView.swift
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 6/7/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit
import Charts
import CoreGraphics

class BA360ChartView: LineChartView {

    var viewModel:BA360ChartViewModelProtocol?
    var overlayLineChart: LineChartView?
    var selectionDot:BA360ChartSelectionDot?
    var boarderWidth:CGFloat = 10 {
        didSet(newValue){
            self.minOffset = newValue
            self.overlayLineChart?.minOffset = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = false
        self.dragEnabled = false
        self.rightAxis.enabled = false
        self.leftAxis.setLabelCount(7, force: true)
        self.xAxis.enabled = false
        self.leftAxis.drawLabelsEnabled = false
        self.leftAxis.axisLineColor = .clear
        self.legend.enabled = false
        self.chartDescription = nil
        self.drawGridBackgroundEnabled = true
        self.overlayLineChart = LineChartView(frame: frame)
        self.overlayLineChart?.minOffset = boarderWidth
        self.overlayLineChart?.clipsToBounds = false
        self.doubleTapToZoomEnabled = false
        self.setScaleEnabled(false)
        self.minOffset = boarderWidth
        configureOverlayLineChartAppearence()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0, 0.1, 0.9, 1]
        self.layer.mask = gradient
    }
    
    // MARK: - Label Drawing
    func drawLabels(_ rect: CGRect) {
        let historyLabel = UILabel(frame: .zero)
        historyLabel.text = self.viewModel?.historyPartString()
        historyLabel.font = UIFont.systemFont(ofSize: 13)
        historyLabel.sizeToFit()
        historyLabel.frame.origin = determineOriginForHistoryLabel(historyLabel)
        if historyLabel.frame.origin == .zero {
            // today entry not found, something wrong, don't draw the label
        } else {
            let string:NSString = NSString(string: (self.viewModel?.historyPartString())!)
            string.draw(in: historyLabel.frame, withAttributes: labelDrawingAttributes())
        }
        
        let forecastLabel = UILabel(frame: .zero)
        forecastLabel.text = self.viewModel?.forecastPartString()
        forecastLabel.font = UIFont.systemFont(ofSize: 13)
        forecastLabel.sizeToFit()
        forecastLabel.frame.origin = determineOriginForForecastLabel(forecastLabel)
        if forecastLabel.frame.origin == .zero {
            // today entry not found, something wrong, don't draw the label
        } else {
            let string:NSString = NSString(string: (self.viewModel?.forecastPartString())!)
            string.draw(in: forecastLabel.frame, withAttributes: labelDrawingAttributes())
        }
    }
    
    func labelDrawingAttributes() -> Dictionary<NSAttributedStringKey, Any> {
        let attrDict = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor:ChartColorTemplates.colorFromString("#333333")]
        return attrDict
    }
    
    func determineOriginForHistoryLabel(_ label:UILabel) -> CGPoint {
        var origin:CGPoint = .zero
        let size = label.frame.size
        let xPos = xPositionOfTodayEntry()
        origin.x = xPos - size.width - 5
        origin.y = self.frame.size.height - 5 - size.height - self.minOffset
        return origin
    }
    
    func determineOriginForForecastLabel(_ label:UILabel) -> CGPoint {
        var origin:CGPoint = .zero
        let size = label.frame.size
        let xPos = xPositionOfTodayEntry()
        origin.x = xPos + 5
        origin.y = self.frame.size.height - 5 - size.height - self.minOffset
        return origin
    }
    
    func xPositionOfTodayEntry() -> CGFloat {
        let entry = self.viewModel?.retrive360HistoricalChartData().last
        if let entry = entry {
            let point = self.getPosition(entry: entry, axis: YAxis.AxisDependency.left)
            return point.x
        }
        return 0.0
    }
    
    // MARK: - custom drawing
    override func draw(_ rect: CGRect) {
        // 1. draw the filled shape
        // 2. draw the grid lines
        // 3. draw the chart line
        super.draw(rect)
        self.leftYAxisRenderer.renderGridLines(context: UIGraphicsGetCurrentContext()!)
        drawLabels(rect)
        self.overlayLineChart?.frame = self.frame
        self.overlayLineChart?.draw(rect)
//        addGradientLayer()
    }
    
    // MARK: - Chart data updates
    // will be called by the view controller
    func updateChartData() {
        let historyValues:[ChartDataEntry]? = self.viewModel?.retrive360HistoricalChartData()
        let forecastValues:[ChartDataEntry]? = self.viewModel?.retrive360ForcastChartData()
        let allValues:[ChartDataEntry]? = self.viewModel?.retrive360ChartData()
        configureChartBasedOnData(data: allValues)
        let historySet = LineChartDataSet(values: historyValues, label: "History")
        let forecastSet = LineChartDataSet(values: forecastValues, label: "Forecast")
        
        configureHistoryDataSet(dataSet: historySet)
        configureForecastDataSet(dataSet: forecastSet)
        
        let data = LineChartData(dataSets: [historySet, forecastSet])
        self.data = data
        
        // overlay chart data depends on self.data, so call it at last
        configureOverlayLineChartData()
    }
    
    func configureHistoryDataSet(dataSet:LineChartDataSet) {
        dataSet.drawValuesEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.highlightColor = ChartColorTemplates.colorFromString("#0073CF")
        dataSet.highlightLineWidth = 3
        // fill the color of history part
        dataSet.fillAlpha = 1
        
        let gradientColors = [ChartColorTemplates.colorFromString("#00B3FE").cgColor,
                              ChartColorTemplates.colorFromString("#029AD9").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)
        
        dataSet.fill = Fill(linearGradient: gradient!, angle: 45)
        dataSet.drawFilledEnabled = true
    }
    
    func configureForecastDataSet(dataSet:LineChartDataSet) {
        dataSet.drawValuesEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.highlightColor = ChartColorTemplates.colorFromString("#0073CF")
        dataSet.highlightLineWidth = 3
        // fill the color of forecast part
        dataSet.fillAlpha = 1
        let gradientColors = [ChartColorTemplates.colorFromString("#D4EFFC").cgColor,
                              ChartColorTemplates.colorFromString("#DFF5FF").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)
        
        dataSet.fill = Fill(linearGradient: gradient!, angle: -45)
        dataSet.drawFilledEnabled = true
    }
    
    func configureChartBasedOnData(data:[ChartDataEntry]?){
        var maxValue:Double = 0
        let leftAxis = self.leftAxis
        leftAxis.removeAllLimitLines()
        
        guard let data = data  else {
            return
        }
        
        for entry in data {
            if entry.y > maxValue{
                maxValue = entry.y
            }
        }
        leftAxis.axisMaximum = maxValue * 1.2
        leftAxis.axisMinimum = 0
    }
    
    func updateLeftAxisScale(_ newMax:Double, newMin:Double) {
        let leftAxis = self.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMaximum = newMax * 1.2
        leftAxis.axisMinimum = newMin
    }
    
    func configureOverlayLineChartAppearence() {
        self.overlayLineChart?.dragEnabled = false
        self.overlayLineChart?.setScaleEnabled(false)
        self.overlayLineChart?.rightAxis.enabled = false
        self.overlayLineChart?.xAxis.enabled = false
        self.overlayLineChart?.legend.enabled = false
        self.overlayLineChart?.chartDescription = nil
        self.overlayLineChart?.leftAxis.enabled = false
    }
    
    func configureOverlayLineChartData() {
        self.overlayLineChart?.leftAxis.axisMaximum = self.leftAxis.axisMaximum
        self.overlayLineChart?.leftAxis.axisMinimum = self.leftAxis.axisMinimum
        let allValues:[ChartDataEntry]? = self.viewModel?.retrive360ChartData()
        let allDataSet = LineChartDataSet(values: allValues, label: "ALL")
        allDataSet.circleRadius = 5
        allDataSet.circleHoleRadius = 4.5
        allDataSet.circleHoleColor = UIColor.white
        allDataSet.lineWidth = 2
        allDataSet.setCircleColor(UIColor.black)
        let data = LineChartData(dataSet: allDataSet)
        self.overlayLineChart?.data = data
    }
    
    // MARK: - Chart tap actions
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight){
        let point = self.getPosition(entry: entry, axis: YAxis.AxisDependency.left)
        guard selectionDot != nil else {
            addDotToView()
            changeDotToPosition(xPos: point.x, yPos: point.y)
            return
        }
        
        changeDotToPosition(xPos: point.x, yPos: point.y)
    }
    
    func addDotToView() {
        selectionDot = BA360ChartSelectionDot()
        selectionDot?.radius = 8
        selectionDot?.lineColor = UIColor.clear
        selectionDot?.fillColor = ChartColorTemplates.colorFromString("#0073CF")
        selectionDot?.center = center
        self.addSubview(selectionDot!)
    }
    
    func changeDotToPosition(xPos x:CGFloat, yPos y:CGFloat) {
        selectionDot?.center = CGPoint(x: x, y: y)
    }
}
