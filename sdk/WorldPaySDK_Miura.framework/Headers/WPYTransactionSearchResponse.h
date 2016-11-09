//
//  WPYTransactionSearchResponse.h
//  WorldPaySDK
//
//  Copyright © 2016 WorldPay. All rights reserved.
//

#import "WPYDomainObject.h"

@class WPYTransactionResponse;

@interface WPYTransactionSearchResponse : WPYDomainObject
@property (nonatomic, readonly) NSArray <WPYTransactionResponse *> *transactions;
@end
