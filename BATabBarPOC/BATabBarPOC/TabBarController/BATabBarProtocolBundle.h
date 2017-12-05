//
//  BATabBarProtocolBundle.h
//  BATabBarPOC
//
//  Created by Qingchuan Zhu on 12/5/17.
//  Copyright © 2017 Qingchuan Zhu. All rights reserved.
//

#ifndef BATabBarProtocolBundle_h
#define BATabBarProtocolBundle_h


#endif /* BATabBarProtocolBundle_h */

#import <UIKit/UIKit.h>

@protocol BARRTabBarChildProtocol<NSObject>

@property (nonatomic, strong) UIScrollView * _Nullable verticalScrollView;
@property (nonatomic, assign) BOOL needVerticalScrolling;

@end
