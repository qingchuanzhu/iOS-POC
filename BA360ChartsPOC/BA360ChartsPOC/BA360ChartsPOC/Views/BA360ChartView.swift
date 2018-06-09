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

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
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
        let values:[ChartDataEntry]? = self.retriveDataArray()
        configureChartBasedOnData(data: values)
        let set1 = LineChartDataSet(values: values, label: "Data set 1")
        
        // following settings should come from VM
        set1.drawCirclesEnabled = true
        set1.setColor(.black)
        set1.lineWidth = 1
        set1.circleRadius = 3
        set1.valueFont = .systemFont(ofSize: 9)
        
        let data = LineChartData(dataSet: set1)
        self.data = data
    }
    
    func retriveDataArray() -> [ChartDataEntry]? {
        return viewModel?.retrive360ChartData()
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
