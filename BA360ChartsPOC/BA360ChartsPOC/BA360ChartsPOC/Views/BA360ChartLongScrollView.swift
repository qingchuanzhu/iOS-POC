//
//  BA360ChartLongScrollView.swift
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 7/19/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit

class BA360ChartLongScrollView: UIScrollView {
    
    var chartsArray:[BA360ChartView] = []
    var contentView:UIView!
    
    var contentWidth:CGFloat = 0
    var dataCount:Int = 0
    let chartViewModel:BA360ChartViewModel = BA360ChartViewModel()
    let dataForEachSection:Int = 15
    let screen_width = UIScreen.main.bounds.width
    let sectionWidth = CGFloat(15 - 1) * UIScreen.main.bounds.width * 0.8 / 5
    var contentViewWidthConstraint:NSLayoutConstraint?
    weak var callBack:ChartPOC_longscrollViewController?
    
    // loading indicator, will be always resued
    let loadingIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var counter:Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentViewWidthConstraint = nil
        contentView = UIView(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentViewWidthConstraint = nil
        contentView = UIView(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
//        addSubview(contentView)
//
////        contentView.layer.anchorPoint = CGPoint(x: 0, y: 1)
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.heightAnchor.constraint(equalToConstant: self.bounds.height).isActive = true
//        contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
//        contentViewWidthConstraint = contentView.widthAnchor.constraint(equalToConstant: sectionWidth)
//        contentViewWidthConstraint?.isActive = true
//        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func fetchNewData()  {
        self.chartViewModel.fetchNewData(forDay: 0, andEndDay: 1) {
            self.counter += 1
            self.appendNewChart()
        }
        // add loading indicator whenever there is chartView at its right
        if let previewsChart = chartsArray.last{
            self.addSubview(loadingIndicator)
            loadingIndicator.heightAnchor.constraint(equalToConstant:self.bounds.height).isActive = true
            loadingIndicator.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            loadingIndicator.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
            loadingIndicator.rightAnchor.constraint(equalTo: (previewsChart.leftAnchor)).isActive = true
            loadingIndicator.startAnimating()
        }
    }
    
    func appendNewChart(){
        // remove the loading indicator, we don't care here if it is added to scroll view
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
        
        // create a new BA360ChartView
        let chartView = BA360ChartView(frame: self.frame)
        chartView.viewModel = self.chartViewModel
        chartView.updateChartData()
        // add to subView and charts array
        addSubview(chartView)
        dataCount += dataForEachSection
        // constraint it
        contentWidth = CGFloat(dataForEachSection - 1) * screen_width * 0.8 / 5
        self.contentSize = CGSize(width: contentWidth, height: self.bounds.height)
        
        //TODO: fix gaps between each section
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.heightAnchor.constraint(equalToConstant:self.bounds.height).isActive = true
        chartView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        chartView.widthAnchor.constraint(equalToConstant: sectionWidth).isActive = true
        // leadig constraint
        if chartsArray.count == 0 {
            chartView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            chartView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        } else {
            let previewsChart = chartsArray.last
            chartView.rightAnchor.constraint(equalTo: (previewsChart?.leftAnchor)!).isActive = true
        }
        
        /*
         The idea here is not change the contentsize of the scroll view, which if changed will
         reposition the whole scroll view, instead we change the contentInset to adjust the scrollable area
         */
        chartsArray.append(chartView)
        let insetChange = CGFloat(chartsArray.count - 1) * sectionWidth
        self.contentInset = UIEdgeInsetsMake(0, insetChange, 0, 0)
        callBack?.updateNextFetchOffset(-insetChange)
        
        
        chartView.setNeedsLayout()
//        contentView.setNeedsLayout()
//        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        self.contentSize = CGSize(width: contentWidth, height: self.bounds.height)
        super.layoutSubviews()
    }

}
