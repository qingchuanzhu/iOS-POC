//
//  BA360ChartViewModel.m
//  BA360ChartsPOC
//
//  Created by Qingchuan Zhu on 6/6/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

#import "BA360ChartViewModel.h"

@interface BA360ChartViewModel()

@property (nonatomic, strong) NSArray<NSNumber *> *dataArray1;

@end

@implementation BA360ChartViewModel

- (instancetype)init{
    if (self = [super init]) {
        self.dataArray1 = @[@12.1, @14.5, @45, @34.5, @22, @67];
    }
    return self;
}

- (NSArray<ChartDataEntry *>*)retrive360ChartData{
    __block NSMutableArray<ChartDataEntry *> *dataArray = [NSMutableArray new];
    [self.dataArray1 enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        double yValue = (self.dataArray1[idx]).doubleValue;
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:idx y:yValue];
        [dataArray addObject:entry];
    }];
    return dataArray;
}

@end
