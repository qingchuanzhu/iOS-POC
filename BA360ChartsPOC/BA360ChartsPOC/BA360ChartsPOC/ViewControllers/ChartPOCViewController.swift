//
//  ChartPOCViewController.swift
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 6/7/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit
import Charts

class ChartPOCViewController: UIViewController, ChartViewDelegate {

    @IBOutlet var holderView: UIView!
    var chartView: BA360ChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        chartView = BA360ChartView(frame: .zero)
        
        // set the view model of chartView
        chartView.viewModel = BA360ChartViewModel()
        
        chartView.delegate = self
        chartView.dragEnabled = true
        
        chartView.rightAxis.enabled = false
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMaximum = 50
        leftAxis.axisMinimum = 0
        
        constraintChartView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chartView.updateChartData()
    }

    func constraintChartView() {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        self.holderView.addSubview(chartView)
        chartView.leftAnchor.constraint(equalTo: holderView.leftAnchor, constant: 0).isActive = true
        chartView.rightAnchor.constraint(equalTo: holderView.rightAnchor, constant: 0).isActive = true
        chartView.topAnchor.constraint(equalTo: holderView.topAnchor, constant: 0).isActive = true
        chartView.bottomAnchor.constraint(equalTo: holderView.bottomAnchor, constant: 0).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
