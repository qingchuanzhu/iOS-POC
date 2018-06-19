//
//  BA360ChartViewModel.m
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 6/6/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

#import "BA360ChartViewModel.h"

@interface BA360ChartViewModel()

@property (nonatomic, strong) NSArray<NSNumber *> *historyData; // total 12 according to req
@property (nonatomic, strong) NSArray<NSNumber *> *forcastData; // total 3 according to req

@end

@implementation BA360ChartViewModel

- (instancetype)init{
    if (self = [super init]) {
        self.historyData = @[@12.1, @14.5, @45, @34.5, @22, @67, @34.6, @56.8, @34, @56, @41.4, @22.2];
        self.forcastData = @[@45.1, @67.1, @45];
    }
    return self;
}

#pragma mark - BA360ChartViewModelProtocol implementation
- (NSArray<ChartDataEntry *>*)retrive360ChartData{
    NSArray *hisdataArray = [self retrive360HistoricalChartData];
    NSMutableArray *forcastArray = [NSMutableArray arrayWithArray:[self retrive360ForcastChartData]];
    [forcastArray removeObjectAtIndex:0];
    NSMutableArray *dataArray = [NSMutableArray new];
    [dataArray addObjectsFromArray:hisdataArray];
    [dataArray addObjectsFromArray:forcastArray];
    return dataArray;
}

- (NSArray<ChartDataEntry*> *)retrive360HistoricalChartData{
    __block NSMutableArray<ChartDataEntry *> *dataArray = [NSMutableArray new];
    [self.historyData enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        double yValue = (self.historyData[idx]).doubleValue;
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:idx y:yValue];
        [dataArray addObject:entry];
    }];
    return dataArray;
}

- (NSArray<ChartDataEntry *> *)retrive360ForcastChartData{
    __block NSMutableArray<ChartDataEntry *> *dataArray = [NSMutableArray new];
    NSUInteger historyDataCount = self.historyData.count - 1; // the first of forecast should have same index as last of history data
    NSMutableArray<NSNumber*> *forecastArray = [NSMutableArray arrayWithArray:self.forcastData];
    [forecastArray insertObject:[self.historyData lastObject] atIndex:0];
    [forecastArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        double yValue = forecastArray[idx].doubleValue;
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:idx+historyDataCount y:yValue];
        [dataArray addObject:entry];
    }];
    return dataArray;
}

- (NSString *)historyPartString{
    return @"History";
}

- (NSString *)forecastPartString{
    return @"Forecast";
}

@end
