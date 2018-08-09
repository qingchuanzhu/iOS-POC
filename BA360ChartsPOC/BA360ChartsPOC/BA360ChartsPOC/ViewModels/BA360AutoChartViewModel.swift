//
//  BA360AutoChartViewModel.swift
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 8/6/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

import UIKit

enum BA360AutoChartViewModelFetchStatus {
    case in_progress
    case idle
}

let randomCount:Int = 200

class BA360AutoChartViewModel: NSObject {
    
    var historyData:[Double] = [11.0, 12.0, 13.0, 14.0, 15.0, 13.0, 12.0, 11.0, 11.0, 12.0, 13.0, 14.0, 15.0, 13.0, 12.0, 11.0, 24.0, 45.0, 67.0, 56.0, 45.0, 67.0, 56.0, 45.0, 67.0, 56.0]
    var currentFetchStatus:BA360AutoChartViewModelFetchStatus = .idle
    
    
    func generateRandom(_ low:Double, high:Double, count:Int) -> [Double] {
        let diff = high - low
        var rslt:[Double] = []
        for _ in 0...count - 1{
            let num:Double = drand48()
            rslt.append(low + diff * num)
        }
        
        return rslt
    }
    
    func fetchHistoryData(_ callBack:@escaping () -> Void) {
        currentFetchStatus = .in_progress
        
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 4) {
            let randomData = self.generateRandom(0, high: 100, count: randomCount)
            for data in randomData{
                self.historyData.insert(data, at: 0)
            }
            DispatchQueue.main.async {
                self.currentFetchStatus = .idle
                callBack()
            }
        }
        
//        dispatch_queue_t myCustomQueue;
//        myCustomQueue = dispatch_queue_create("com.qingchuan.MyCustomQueue", DISPATCH_QUEUE_SERIAL);
//        self.fetchStatus = BA360ChartDataFetchStatus_In_progress;
//        NSDate *startTime = [NSDate date];
//        NSString *fetchTime = endDay == 1 ? @"History" : @"Forecast";
//        NSLog(@"%@", [NSString stringWithFormat:@"Start fetching %@ data at %@", fetchTime, [self.formatter stringFromDate:startTime]]);
//        dispatch_after(, myCustomQueue, ^{
//            if (endDay == 1) {
//                [self doubleHistoryData];
//            } else if (startDay == 1){
//                [self doubleFutureData];
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                callBack();
//                self.fetchStatus = BA360ChartDataFetchStatus_Idle;
//                });
//
//            NSDate *endTime = [NSDate date];
//            NSLog(@"%@", [NSString stringWithFormat:@"fetching %@ data complete at %@", fetchTime, [self.formatter stringFromDate:endTime]]);
//            });
    }
    
    
}
