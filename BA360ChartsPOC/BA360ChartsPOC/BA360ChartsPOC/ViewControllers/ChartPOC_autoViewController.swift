//
//  ChartPOC_autoViewController.swift
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 8/6/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit

let numOfFetch:Int = 1

class ChartPOC_autoViewController: UIViewController, ChartViewDelegate {

    @IBOutlet var holderView: UIView!
    var chartView: BA360AutoChartView!
    var fetchCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        chartView = BA360AutoChartView(frame: .zero)
        chartView.viewModel = BA360AutoChartViewModel()
        chartView.delegate = self
        fetchCount = 0
        constraintChartView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chartView.updateChartData(false)
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
    
    // chart view callbacks
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        let chartView = chartView as! BA360AutoChartView
        let minIndex = chartView.lowestVisibleX
//        let maxIndex = chartView.highestVisibleX
        if 0.0 == floor(minIndex) && fetchCount < numOfFetch {
            print("reach left end")
            chartView.insertDataToLeft()
            fetchCount += 1
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
