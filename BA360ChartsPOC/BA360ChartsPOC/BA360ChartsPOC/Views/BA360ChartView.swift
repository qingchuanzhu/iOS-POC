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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.dragEnabled = true
        self.rightAxis.enabled = false
        self.leftAxis.setLabelCount(7, force: true)
        self.xAxis.enabled = false
        self.leftAxis.drawLabelsEnabled = false
        self.leftAxis.axisLineColor = .clear
        self.legend.enabled = false
        self.chartDescription = nil
        self.drawGridBackgroundEnabled = true
        self.overlayLineChart = LineChartView(frame: frame)
        self.highlightPerTapEnabled = false
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
    
    override func draw(_ rect: CGRect) {
        // 1. draw the filled shape
        // 2. draw the grid lines
        // 3. draw the chart line
        super.draw(rect)
        self.leftYAxisRenderer.renderGridLines(context: UIGraphicsGetCurrentContext()!)
        self.overlayLineChart?.frame = self.frame
        self.overlayLineChart?.draw(rect)
        addGradientLayer()
    }
    
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
    
    func configureOverlayLineChartAppearence() {
        self.overlayLineChart?.dragEnabled = true
        self.overlayLineChart?.rightAxis.enabled = false
//        self.overlayLineChart?.leftAxis.setLabelCount(7, force: true)
        self.overlayLineChart?.xAxis.enabled = false
//        self.overlayLineChart?.leftAxis.drawLabelsEnabled = false
//        self.overlayLineChart?.leftAxis.axisLineColor = .clear
        self.overlayLineChart?.legend.enabled = false
        self.overlayLineChart?.chartDescription = nil
        self.overlayLineChart?.leftAxis.enabled = false
//        self.overlayLineChart?.drawGridBackgroundEnabled = true
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

}
