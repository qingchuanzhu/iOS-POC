//
//  flickerController.m
//  CustomKeyBoardTest
//
//  Created by Qingchuan Zhu on 3/17/17.
//  Copyright © 2017 ProgrammingC. All rights reserved.
//

#import "flickerController.h"
#import "FlickrAPI.h"

@interface flickerController ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation flickerController

- (instancetype)init{
    if (self = [super init]) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

- (void)fetchRecentPhotos{
    FlickrAPI *flickerAPI = [[FlickrAPI alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[flickerAPI recentPhotoURL]];
    NSURLSessionTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
    [task resume];
}

@end
