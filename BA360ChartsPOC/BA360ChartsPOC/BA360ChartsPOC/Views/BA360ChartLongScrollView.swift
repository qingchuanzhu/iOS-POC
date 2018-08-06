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
    
    func fetchNewData(_ history:Bool)  {
        self.chartViewModel.fetchNewData(forDay: history ? 0 : 1, andEndDay: history ? 1 : 0) {
            self.counter += 1
            self.expendChart(history)
        }
        // add loading indicator whenever there is chartView at its right
        if dataCount >= 1 {
            self.addSubview(loadingIndicator)
            loadingIndicator.heightAnchor.constraint(equalToConstant:self.bounds.height).isActive = true
            loadingIndicator.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            loadingIndicator.widthAnchor.constraint(equalToConstant: indicatorWidth).isActive = true
            if history{
                loadingIndicator.rightAnchor.constraint(equalTo: (chartView.leftAnchor)).isActive = true
                self.contentInset = UIEdgeInsetsMake(0, indicatorWidth, 0, 0)
            } else {
                loadingIndicator.leftAnchor.constraint(equalTo: (chartView.rightAnchor)).isActive = true
                self.contentInset = UIEdgeInsetsMake(0, 0, 0, indicatorWidth)
            }
            
            loadingIndicator.startAnimating()
        }
    }
    
    func expendChart(_ history:Bool){
        
        var adjContentOffset = self.contentOffset
        print("offset when expending = \(adjContentOffset)")
        
        // seting this to zero will have a bounce back effect, so reassign the adjContentOffset back to compensate it
        self.contentInset = .zero
        self.contentOffset = adjContentOffset

        chartView.updateChartData()

        dataCount += self.chartViewModel.newlyFetchDataCount()
        contentWidth = CGFloat(dataCount - 1) * (screen_width * 0.8) / 5 + 20
        contentViewWidthConstraint.constant = contentWidth

        if history{
            adjContentOffset.x += (12 * (screen_width * 0.8) / 5)
        }
        
        self.contentOffset = adjContentOffset

        // need to stop and remove after calculation of new contentwidth, otherwise system will
        // shift the view first by indicatorWidth, then adjust the new width
        if loadingIndicator.superview != nil {
//            self.contentInset = .zero
            loadingIndicator.stopAnimating()
            loadingIndicator.removeFromSuperview()
        }

        callBack?.updateNextFetchOffset(contentWidth - self.bounds.width)
    }
    
    func scaleLeftAixsForOffset(_ currentOffset:CGPoint) {
        
    }
    
    override func layoutSubviews() {
        self.contentSize = CGSize(width: contentWidth, height: self.bounds.height)
        super.layoutSubviews()
    }
}
