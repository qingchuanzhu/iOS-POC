//
//  BA360AutoChartView.swift
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 8/6/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit
import Charts

class BA360AutoChartView: LineChartView {
    
    let historyData:[Double] = [11.0, 12.0, 13.0, 14.0, 15.0, 13.0, 12.0, 11.0, 11.0, 12.0, 13.0, 14.0, 15.0, 13.0, 12.0, 11.0, 24.0, 45.0, 67.0, 56.0, 45.0, 67.0, 56.0, 45.0, 67.0, 56.0]

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = false
        self.dragEnabled = true
        self.rightAxis.enabled = false
        self.leftAxis.setLabelCount(7, force: true)
        self.xAxis.enabled = true
//        self.xAxis.setLabelCount(5, force: true)
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
        self.delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateChartData() {
        let allValues:[ChartDataEntry] = self.retrive360ChartData()
        let allSet = LineChartDataSet(values: allValues, label: "History")
        
//        let data:[Double] = [11.0, 12.0, 13.0, 14.0, 15.0, 13.0, 12.0, 11.0, 11.0, 12.0, 13.0, 14.0, 15.0, 13.0, 12.0, 11.0, 24.0, 45.0, 67.0, 56.0, 45.0, 67.0, 56.0, 45.0, 67.0, 56.0]
//        var xAxisEntry:[Double] = []
//        for (index, data) in data.enumerated(){
//            xAxisEntry.append(Double(index))
//        }
//        self.xAxis.entries = xAxisEntry
//        self.leftAxis.entries = data
        
        configureAllDataSet(dataSet: allSet)
        
        let data = LineChartData(dataSets: [allSet])
        self.data = data
        changeViewPort()
    }
    
    func changeViewPort() {
        self.xAxis.setLabelCount(5, force: true)
        self.setVisibleXRangeMaximum(4)
        self.setVisibleXRangeMinimum(4)
        self.xAxis.granularity = 1
        self.moveViewToX(Double(historyData.count - 1))
        
    }
    
//    - (NSArray<ChartDataEntry*> *)retrive360HistoricalChartData{
//    __block NSMutableArray<ChartDataEntry *> *dataArray = [NSMutableArray new];
//    [self.historyData enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//    double yValue = (self.historyData[idx]).doubleValue;
//    ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:idx y:yValue];
//    [dataArray addObject:entry];
//    }];
//    return dataArray;
//    }
    
    func retrive360ChartData() -> [ChartDataEntry] {
        
        var dataArray:[ChartDataEntry] = []
        for (index, data) in historyData.enumerated(){
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
