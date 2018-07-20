//
//  BA360ChartLongScrollView.swift
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 7/19/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit

private let numberOfSections:Int = 7

class BA360ChartLongScrollView: UIScrollView {
    
    var chartsArray:[BA360ChartView] = []
    
    var contentWidth:CGFloat = 0
    var dataCount:Int = 0
    let chartViewModel:BA360ChartViewModel = BA360ChartViewModel()
    let dataForEachSection:Int = 15
    let screen_width = UIScreen.main.bounds.width
    let sectionWidth = CGFloat(15 - 1) * UIScreen.main.bounds.width * 0.8 / 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
    }
    
    func fetchNewData()  {
        self.chartViewModel.fetchNewData(forDay: 0, andEndDay: 1) {
            self.appendNewChart()
        }
    }
    
    func appendNewChart(){
        // create a new BA360ChartView
        let chartView = BA360ChartView(frame: self.frame)
        chartView.viewModel = self.chartViewModel
        chartView.updateChartData()
        // add to subView and charts array
        addSubview(chartView)
        dataCount += dataForEachSection
        // constraint it
        contentWidth = CGFloat(dataCount - 1) * screen_width * 0.8 / 5
        self.contentSize = CGSize(width: contentWidth, height: self.bounds.height)
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.heightAnchor.constraint(equalToConstant: self.bounds.height).isActive = true
        chartView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        chartView.widthAnchor.constraint(equalToConstant: sectionWidth).isActive = true
        // leadig constraint
        if chartsArray.count == 0 {
            chartView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        } else {
            let previewsChart = chartsArray.last
            chartView.rightAnchor.constraint(equalTo: (previewsChart?.leftAnchor)!).isActive = true
        }
        chartsArray.append(chartView)
        chartView.setNeedsLayout()
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        self.contentSize = CGSize(width: contentWidth, height: self.bounds.height)
        super.layoutSubviews()
    }

}
