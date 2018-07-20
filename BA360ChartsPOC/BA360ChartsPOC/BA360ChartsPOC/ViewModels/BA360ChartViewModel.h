//
//  BA360ChartViewModel.h
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 6/6/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BA360ChartProtocolBundle.h"

typedef NS_ENUM(NSInteger, BA360ChartDataFetchStatus){
    BA360ChartDataFetchStatus_In_progress = 0,
    BA360ChartDataFetchStatus_Idle
};

@interface BA360ChartViewModel : NSObject<BA360ChartViewModelProtocol>

- (BA360ChartDataFetchStatus)currentFetchStatus;
- (void)fetchNewDataForDay:(NSInteger) startDay andEndDay:(NSInteger) endDay withCallBack:(void (^)(void))callBack;

@end
