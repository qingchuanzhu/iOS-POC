//
//  BA360AutoChartView.swift
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 8/6/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit
import Charts

enum BA360DataSetType:Int {
    case BA360DataSetTypeHistory = 0
    case BA360DataSetTypeForecast = 1
}

class BA360AutoChartView: LineChartView {
    
    var viewModel:BA360AutoChartViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = false
        self.dragEnabled = true
        self.rightAxis.enabled = false
        self.leftAxis.setLabelCount(7, force: true)
        self.xAxis.enabled = true
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateChartData(_ forHistory:Bool) {
        createData()
        changeViewPort(forHistory)
    }
    
    func createData()  {
        let allValues:[ChartDataEntry] = self.retrive360ChartData()
        let allSet = LineChartDataSet(values: allValues, label: "History")
        
        configureAllDataSet(dataSet: allSet)
        
        let data = LineChartData(dataSets: [allSet])
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
            self.moveViewToX(Double(viewModel.historyData.count - 1))
        }
    }
        
    func insertDataToLeft() {
        // TODO: show loading indicator
        if viewModel?.currentFetchStatus == BA360AutoChartViewModelFetchStatus.idle{
            viewModel?.fetchHistoryData {
                // TODO: weak self
                self.createData()
                // TODO: hide loading indicator
                // TODO: move chart to correct position
            }
        }
    }
    
    func retrive360ChartData() -> [ChartDataEntry] {
        
        var dataArray:[ChartDataEntry] = []
        guard let viewModel = self.viewModel else {
            return []
        }
        for (index, data) in viewModel.historyData.enumerated(){
            let yValue = data
            let entry = ChartDataEntry(x: Double(index), y: yValue)
            dataArray.append(entry)
        }
        return dataArray
    }
    
    func configureAllDataSet(dataSet:LineChartDataSet) {
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
}
