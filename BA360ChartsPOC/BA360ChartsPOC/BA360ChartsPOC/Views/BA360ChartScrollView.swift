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
    
    override init(frame: CGRect) {
        embeddingChartView = BA360ChartView(frame: .zero)
        super.init(frame: frame)
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
