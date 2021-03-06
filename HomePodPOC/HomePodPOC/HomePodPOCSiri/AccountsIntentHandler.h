//
//  AccountsIntentHandler.h
//  HomePodPOCSiri
//
//  Created by Qingchuan Zhu on 2/9/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Intents/Intents.h>

static NSString *HOMEPODPOC_TOUCHID_EN = @"enable_touchID";

@interface AccountsIntentHandler : NSObject <INSearchForAccountsIntentHandling>

@end
