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
    
    func updateChartData() {
        let values:[ChartDataEntry]? = self.retriveDataArray()
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

}
