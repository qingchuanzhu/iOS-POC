//
//  BA360ChartProtocolBundle.h
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 6/8/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

#ifndef BA360ChartProtocolBundle_h
#define BA360ChartProtocolBundle_h

#import <Foundation/Foundation.h>
@import Charts;

@protocol BA360ChartViewModelProtocol<NSObject>

@required
/// returns all the data entries used to plot the chart
- (NSArray<ChartDataEntry *>*) retrive360ChartData;

/// returns historical data entries
- (NSArray<ChartDataEntry *>*) retrive360HistoricalChartData;

/// returns future data entries
- (NSArray<ChartDataEntry *>*) retrive360ForcastChartData;

@end

#endif /* BA360ChartProtocolBundle_h */
