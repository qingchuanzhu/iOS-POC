//
//  AccountsIntentHandler.m
//  HomePodPOCSiri
//
//  Created by Qingchuan Zhu on 2/9/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

#import "AccountsIntentHandler.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation AccountsIntentHandler

- (void)handleSearchForAccounts:(INSearchForAccountsIntent *)intent
                     completion:(void (^)(INSearchForAccountsIntentResponse *response))completion NS_SWIFT_NAME(handle(intent:completion:)){
    INSpeakableString *acctNickName = [[INSpeakableString alloc] initWithSpokenPhrase:@"Check123"];
    INBalanceAmount *balaAmt = [[INBalanceAmount alloc] initWithAmount:[NSDecimalNumber decimalNumberWithDecimal:[@100 decimalValue]] currencyCode:@"USD"];
    INPaymentAccount *account = [[INPaymentAccount alloc] initWithNickname:acctNickName number:nil accountType:INAccountTypeCredit organizationName:nil balance:balaAmt secondaryBalance:nil];
    INSearchForAccountsIntentResponse *response = [[INSearchForAccountsIntentResponse alloc] initWithCode:INSearchForAccountsIntentResponseCodeSuccess userActivity:nil];
    response.accounts = @[account];
    completion(response);
    
}

- (void)confirmSearchForAccounts:(INSearchForAccountsIntent *)intent completion:(void (^)(INSearchForAccountsIntentResponse * _Nonnull))completion{
    LAContext *contextTouch = [LAContext new];
    [contextTouch setLocalizedFallbackTitle:@"Use Passcode"];
    [contextTouch evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"Sign In with Online ID:yes****" reply:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            INSearchForAccountsIntentResponse *response = [[INSearchForAccountsIntentResponse alloc] initWithCode:INSearchForAccountsIntentResponseCodeReady userActivity:nil];
            completion(response);
        } else {
            INSearchForAccountsIntentResponse *response = [[INSearchForAccountsIntentResponse alloc] initWithCode:INSearchForAccountsIntentResponseCodeFailure userActivity:nil];
            completion(response);
        }
    }];
    
}
@end
