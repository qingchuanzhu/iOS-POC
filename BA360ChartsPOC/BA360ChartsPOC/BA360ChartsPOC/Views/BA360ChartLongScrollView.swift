//
//  BA360ChartLongScrollView.swift
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 7/19/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit

private let indicatorWidth:CGFloat = 30.0

class BA360ChartLongScrollView: UIScrollView {
    
    var chartsArray:[BA360ChartView] = []
    var contentView:UIView!
    var chartView:BA360ChartView!
    
    var contentWidth:CGFloat = 0
    var dataCount:Int = 0
    let chartViewModel:BA360ChartViewModel = BA360ChartViewModel()
    let dataForEachSection:Int = 15
    let screen_width = UIScreen.main.bounds.width
    let sectionWidth = CGFloat(15 - 1) * UIScreen.main.bounds.width * 0.8 / 5
    var contentViewWidthConstraint:NSLayoutConstraint!
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
        chartView = BA360ChartView(frame: self.frame)
        chartView.viewModel = self.chartViewModel
        
        self.addSubview(chartView)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.heightAnchor.constraint(equalToConstant:self.bounds.height).isActive = true
        chartView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        chartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        chartView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        chartView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentViewWidthConstraint = NSLayoutConstraint(item: chartView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 0)
        chartView.addConstraint(contentViewWidthConstraint)
    }
    
    func fetchNewData()  {
        self.chartViewModel.fetchNewData(forDay: 0, andEndDay: 1) {
            self.counter += 1
            self.expendChart()
        }
        // add loading indicator whenever there is chartView at its right
        if dataCount >= 1 {
            self.addSubview(loadingIndicator)
            loadingIndicator.heightAnchor.constraint(equalToConstant:self.bounds.height).isActive = true
            loadingIndicator.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            loadingIndicator.widthAnchor.constraint(equalToConstant: indicatorWidth).isActive = true
            loadingIndicator.rightAnchor.constraint(equalTo: (chartView.leftAnchor)).isActive = true
//            let insetChange = CGFloat(chartsArray.count - 1) * sectionWidth + indicatorWidth
//            self.contentInset = UIEdgeInsetsMake(0, insetChange, 0, 0)
            loadingIndicator.startAnimating()
        }
    }
    
    func expendChart(){
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
        chartView.updateChartData()
        
        dataCount += self.chartViewModel.newlyFetchDataCount()
        contentWidth = CGFloat(dataCount - 1) * screen_width * 0.8 / 5
        contentViewWidthConstraint.constant = contentWidth
        
        var adjContentOffset = self.contentOffset
        adjContentOffset.x += (12 * UIScreen.main.bounds.width * 0.8 / 5)
        self.contentOffset = adjContentOffset
        
        callBack?.updateNextFetchOffset(0)
    }
    
    func appendNewChart(){
        // remove the loading indicator, we don't care here if it is added to scroll view
//        loadingIndicator.stopAnimating()
//        loadingIndicator.removeFromSuperview()
        
        // create a new BA360ChartView
        let chartView = BA360ChartView(frame: self.frame)
        chartView.boarderWidth = 0
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
    }
    
    override func layoutSubviews() {
        self.contentSize = CGSize(width: contentWidth, height: self.bounds.height)
        super.layoutSubviews()
    }

}
