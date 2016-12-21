//
//  WPYTransactionSearchResponse.h
//  WorldPaySDK
//
//  Copyright © 2016 WorldPay. All rights reserved.
//

#import "WPYResponseObject.h"

@class WPYTransaction;

@interface WPYTransactionSearchResponse : WPYResponseObject
/**
 * The list of transactions that matches the parameters in the initial search
 */
@property (nonatomic, readonly) NSArray <WPYTransaction *> *transactions;
@end
