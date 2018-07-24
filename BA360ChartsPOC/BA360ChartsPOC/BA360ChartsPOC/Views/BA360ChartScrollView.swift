//
//  BA360ChartScrollView.swift
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 6/18/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit

class BA360ChartScrollView: UIScrollView {

    let embeddingChartView:BA360ChartView!
    var contentWidth:CGFloat?
    
    override init(frame: CGRect) {
        embeddingChartView = BA360ChartView(frame: .zero)
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        embeddingChartView = BA360ChartView(frame: .zero)
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(embeddingChartView)
    }
    
    func constrainTheChartView() {
        //1. calculate the width of content
        /*
         chart(and the scroll view) will occupy 80% of the screen width
         Inside the chart, at every moment, there will be 5 equally spaced dots
         Thus, the total width is (number of data - 1) * data_Space
         data_Space = SCREEN_WIDTH * 0.8 / 5
         So, total chart widht would be:
            (number of data - 1) * SCREEN_WIDTH * 0.8 / 5
         */
        let screen_width = UIScreen.main.bounds.width
        guard let numberOfData = embeddingChartView.viewModel?.retrive360ChartData().count else {
            // something wrong with view model
            return
        }
        contentWidth = CGFloat(numberOfData - 1) * screen_width * 0.8 / 5
        embeddingChartView.translatesAutoresizingMaskIntoConstraints = false
        embeddingChartView.widthAnchor.constraint(equalToConstant: contentWidth!).isActive = true
        embeddingChartView.heightAnchor.constraint(equalToConstant: self.bounds.height).isActive = true
        embeddingChartView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        embeddingChartView.setNeedsLayout()
//        self.contentSize = CGSize(width: width, height: self.bounds.height)
//        self.setNeedsLayout()
    }
    
    
    override func layoutSubviews() {
        self.contentSize = CGSize(width: contentWidth!, height: self.bounds.height)
        super.layoutSubviews()
    }
}
