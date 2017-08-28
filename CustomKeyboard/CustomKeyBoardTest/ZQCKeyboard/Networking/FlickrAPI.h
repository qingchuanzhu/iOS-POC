//
//  FlickrAPI.h
//  CustomKeyBoardTest
//
//  Created by Qingchuan Zhu on 3/17/17.
//  Copyright © 2017 ProgrammingC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define API_METHOD @"flickr.photos.getRecent"

@interface FlickrAPI : NSObject

- (NSURL *)recentPhotoURL;

@end
