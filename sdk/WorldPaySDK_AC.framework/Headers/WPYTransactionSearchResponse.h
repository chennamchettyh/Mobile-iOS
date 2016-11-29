//
//  WPYTransactionSearchResponse.h
//  WorldPaySDK
//
//  Copyright © 2016 WorldPay. All rights reserved.
//

#import "WPYDomainObject.h"

@class WPYTransaction;

@interface WPYTransactionSearchResponse : WPYDomainObject
/**
 * Gateway response code for the current request
 */
@property (nonatomic, readonly) WPYResponseCode responseCode;
/**
 * Response Message containing a detailed message for the merchant, such as why a transaction was declined
 */
@property (nonatomic, readonly) NSString *responseMessage;
/**
 * Indicates whether or not the current request was successfully processed
 */
@property (nonatomic, readonly) BOOL success;
/**
 * Short message indicating the result of processing. Suitable to display to the card holder
 */
@property (nonatomic, readonly) NSString *result;
/**
 * The list of transactions that matches the parameters in the initial search
 */
@property (nonatomic, readonly) NSArray <WPYTransaction *> *transactions;
@end
