//
//  WPYBatchResponse.h
//  WorldpaySDK
//
//  Copyright © 2015 Worldpay. All rights reserved.
//

#import "WPYDomainObject.h"

@class WPYTransaction;

/** 
 * An object that only contains the identifier for the current batch.  Note that the 'identifier' property is common to all
 * WPYDomainObjects and is therefore visible at the base class level
 */
@interface WPYBatchResponse : WPYDomainObject
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
 * A convenience method to get the WPYBatchResponse.identifier associated with the transaction
 */
@property (nonatomic, readonly, getter=getBatchId) NSString *batchId;
/**
 * A list of transactions associated with the batch
 */
@property (nonatomic, readonly, strong) NSArray <WPYTransaction *> *transactions;
@end
