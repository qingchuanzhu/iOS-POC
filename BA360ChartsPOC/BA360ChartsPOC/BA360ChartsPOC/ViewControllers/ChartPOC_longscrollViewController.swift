//
//  ChartPOC_longscrollViewController.swift
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 7/19/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit

class ChartPOC_longscrollViewController: UIViewController, UIScrollViewDelegate{

    @IBOutlet var holderView: BA360ChartLongScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        holderView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset
        if currentOffset.x <= 0 {
            if holderView.chartViewModel.currentFetchStatus() == .idle {
                holderView.fetchNewData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.holderView.fetchNewData()
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
