//
//  WPYPaymentRefund.h
//  WorldpaySDK
//
//  Copyright © 2015 Worldpay. All rights reserved.
//

#import "WPYDomainObject.h"

/**
 * This requests that the specified transaction be refunded to the account holder
 */
@interface WPYPaymentRefund : WPYDomainObject
/**
 * The amount of the refund being requested
 */
@property (nonatomic, strong) NSDecimalNumber *amount;
/**
 * The transaction ID that the refund will be applied against
 */
@property (nonatomic, strong) NSString *transactionId;
/**
 * Client-generated unique ID for each transaction, used as a way to prevent the processing of duplicate
 * transactions. The orderId must be unique to the merchant's SecureNet ID; however, uniqueness is only
 * evaluated for APPROVED transactions and only for the last 30 days. If a transaction is declined, the
 * corresponding orderId may be used again.
 *
 * The orderId is limited to 25 characters; e.g., “CUSTOMERID MMddyyyyHHmmss”.
 */
@property (nonatomic, strong) NSString * orderId;

@end
