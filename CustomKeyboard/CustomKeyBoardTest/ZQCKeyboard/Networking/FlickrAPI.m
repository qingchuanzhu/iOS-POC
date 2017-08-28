//
//  FlickrAPI.m
//  CustomKeyBoardTest
//
//  Created by Qingchuan Zhu on 3/17/17.
//  Copyright © 2017 ProgrammingC. All rights reserved.
//

#import "FlickrAPI.h"

@interface FlickrAPI ()

@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *APIKey;

@end

@implementation FlickrAPI

- (instancetype) init{
    if (self = [super init]) {
        self.baseURL = @"https://api.flickr.com/services/rest";
        self.APIKey = @"a6d819499131071f158fd740860a5a88";
    }
    return self;
}

- (NSURL *)flickURLWithMethod:(NSString *)method andParams: (NSDictionary *)params{
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:self.baseURL];
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSURLQueryItem *item = [[NSURLQueryItem alloc] initWithName:key value:obj];
        [queryItems addObject:item];
    }];
    components.queryItems = queryItems;
    return [components URL];
}

- (NSURL *)recentPhotoURL{
    NSDictionary *params = [NSDictionary dictionary];
    params = @{
        @"extras":@"url_h,date_taken",
        @"method":API_METHOD,
        @"format":@"json",
        @"nojsoncallback":@"1",
        @"api_key":self.APIKey
    };
    return [self flickURLWithMethod:API_METHOD andParams:params];
}

@end
