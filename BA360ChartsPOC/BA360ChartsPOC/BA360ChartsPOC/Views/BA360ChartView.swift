//
//  BA360ChartView.swift
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 6/7/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit
import Charts

class BA360ChartView: LineChartView {

    var viewModel:BA360ChartViewModelProtocol?
    
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
        addGradientLayer()
        super.draw(rect)
    }
    
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
    }
    
    func configureHistoryDataSet(dataSet:LineChartDataSet) {
        dataSet.drawCirclesEnabled = true
        dataSet.setColor(.black)
        dataSet.lineWidth = 1
        dataSet.circleRadius = 3
        dataSet.valueFont = .systemFont(ofSize: 9)
    }
    
    func configureForecastDataSet(dataSet:LineChartDataSet) {
        dataSet.drawCirclesEnabled = true
        dataSet.setColor(.black)
        dataSet.lineWidth = 1
        dataSet.circleRadius = 3
        dataSet.valueFont = .systemFont(ofSize: 9)
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

}
