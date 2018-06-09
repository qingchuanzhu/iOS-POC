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
- (NSArray<ChartDataEntry *>*) retrive360ChartData;

@end

#endif /* BA360ChartProtocolBundle_h */
