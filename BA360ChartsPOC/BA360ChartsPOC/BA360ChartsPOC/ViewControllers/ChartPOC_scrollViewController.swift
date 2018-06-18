//
//  ChartPOC_scrollViewController.swift
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 6/18/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit

class ChartPOC_scrollViewController: UIViewController, ChartViewDelegate {

    @IBOutlet var holderScrollView: BA360ChartScrollView!
    var chartView:BA360ChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView = holderScrollView.embeddingChartView
        
        // set the view model of chartView
        chartView.viewModel = BA360ChartViewModel()
        
        chartView.delegate = self
        // chartView is ready, now configure its appearence
        holderScrollView.constrainTheChartView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chartView.updateChartData()
    }

    // MARK: - Chart View Delegate callbacks
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        // Logics view controller needs to coordinate
        if chartView === self.chartView {
            self.chartView.chartValueSelected(chartView, entry: entry, highlight: highlight)
        }
    }
}
