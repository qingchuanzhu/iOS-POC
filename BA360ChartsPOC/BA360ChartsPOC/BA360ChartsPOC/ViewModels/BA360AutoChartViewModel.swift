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

let randomCount:Int = 20
let dummyThreshold:Double = 11.0

class BA360DataSection {
    var belowTH:Bool = false
    var history:Bool = false
    var rawData:[Double] = []
    
    init(_ belowTH:Bool, history:Bool, rawData:[Double]) {
        self.belowTH = belowTH
        self.history = history
        self.rawData = rawData
    }
}

class BA360AutoChartViewModel: NSObject {
    
    private var historyData:[Double] = [11.0, 12.0, 13.0, 14.0, 15.0, 13.0, 12.0, 11.0, 11.0, 12.0, 13.0, 14.0, 15.0, 13.0, 12.0, 11.0, 24.0, 45.0, 67.0, 56.0, 45.0, 67.0, 56.0, 45.0, 67.0, 56.0]
    var currentFetchStatus:BA360AutoChartViewModelFetchStatus = .idle
    private var unappendHistoryData:[Double] = [11.0, 12.0, 13.0, 14.0, 15.0, 13.0, 12.0, 11.0, 11.0, 12.0, 13.0, 14.0, 15.0, 13.0, 12.0, 11.0, 24.0, 45.0, 67.0, 56.0, 45.0, 67.0, 56.0, 45.0, 67.0, 56.0]
    private var unappendForecastData:[Double] = []
    private var currentDataSection:[BA360DataSection] = []
    
    var lastHighLight:Highlight? = nil
    
    var dataCount:Int{
        return historyData.count
    }
    
    func generateRandom(_ low:Double, high:Double, count:Int) -> [Double] {
        let diff = high - low
        var rslt:[Double] = []
        for _ in 0...count - 1{
            let num:Double = drand48()
            rslt.append(low + diff * num)
        }
        
        return rslt
    }
    
    func dataToPresent() -> [BA360DataSection] {
        if unappendHistoryData.count > 0{
            var index = 0
            var result:[BA360DataSection] = []
            
            var belowTHTemp:BA360DataSection? = nil
            var aboveTHTemp:BA360DataSection? = nil
            while index < unappendHistoryData.count {
                let val = unappendHistoryData[index]
                
                if val <= dummyThreshold{
                    if let section = belowTHTemp{
                        section.rawData.append(val)
                    } else {
                        // THIS IS THE FIRST BELOW VALUE AFTER POTENTIAL ABOVE VALUES
                        // 1. append above section if any
                        if let section = aboveTHTemp{
                            result.append(section)
                            // 2. clear the ref to above section
                            aboveTHTemp = nil
                        }
                        // 3.create a below section
                        let belowSection = BA360DataSection(true, history: true, rawData: [val])
                        belowTHTemp = belowSection
                    }
                } else {
                    if let section = aboveTHTemp{
                        section.rawData.append(val)
                    } else{
                        if let section = belowTHTemp{
                            result.append(section)
                            belowTHTemp = nil
                        }
                        let aboveSection = BA360DataSection(false, history: true, rawData: [val])
                        aboveTHTemp = aboveSection
                    }
                }
                
                index += 1
            }
            if let section = belowTHTemp{
                result.append(section)
            }
            if let section = aboveTHTemp{
                result.append(section)
            }
            unappendHistoryData.removeAll()
            currentDataSection = result + currentDataSection
        }
        
        if unappendForecastData.count > 0 {
            var result:[BA360DataSection] = []
            unappendForecastData.removeAll()
            currentDataSection = currentDataSection + result
        }
        
        return currentDataSection
    }
    
    func fetchHistoryData(_ callBack:@escaping () -> Void) {
        currentFetchStatus = .in_progress
        
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 4) {
            let randomData = self.generateRandom(0, high: 100, count: randomCount)
            for data in randomData{
                self.historyData.insert(data, at: 0)
                self.unappendHistoryData.insert(data, at: 0)
            }
            DispatchQueue.main.async {
                self.currentFetchStatus = .idle
                callBack()
            }
        }
    }
    
    
}
