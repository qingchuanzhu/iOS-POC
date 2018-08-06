//
//  ChartPOC_longscrollViewController.swift
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 7/19/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit

private let numberOfSections:Int = 6
private let numberOfForecastSections:Int = 6

class ChartPOC_longscrollViewController: UIViewController, UIScrollViewDelegate{

    @IBOutlet var holderView: BA360ChartLongScrollView!
    var numOfSectionFetched:Int = 0
    var numOfForecastSectionFetched:Int = 0
    var nextFetchOffset:CGFloat = 1000000.0 // rightFetch offset
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        holderView.delegate = self
        holderView.callBack = self
        numOfSectionFetched = 0
        numOfForecastSectionFetched = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset
        if currentOffset.x <= 0 && numOfSectionFetched < numberOfSections {
            if holderView.chartViewModel.currentFetchStatus() == .idle {
                holderView.fetchNewData(true)
                numOfSectionFetched += 1
            }
        } else if currentOffset.x >= nextFetchOffset && numOfForecastSectionFetched < numberOfForecastSections{
            if holderView.chartViewModel.currentFetchStatus() == .idle{
                holderView.fetchNewData(false)
                numOfForecastSectionFetched += 1
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset
        holderView.scaleLeftAixsForOffset(currentOffset)
    }
    
    func updateNextFetchOffset(_ nextOffset:CGFloat) {
        nextFetchOffset = nextOffset
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.holderView.fetchNewData(true)
        numOfSectionFetched += 1
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
