//
//  WPYTransactionResponse.h
//  WorldpaySDK
//
//  Copyright © 2015 Worldpay. All rights reserved.
//

#import "WPYDomainObject.h"
#import "WPYTender.h"

@class WPYCheckTransactionData;
@class WPYCardTransactionData;
@class WPYAddressInfo;
@class WPYLevelTwoData;

/** 
 * This object contains transaction response information returned from the gateway after sending a payment request
 * to the server
 */
@interface WPYTransactionResponse : WPYDomainObject
/**
 * The ID of the customer associated with the transaction, if any
 */
@property (nonatomic, readonly) NSString *customerId;
/**
 * The date/time of the transaction
 */
@property (nonatomic, readonly) NSDate *date;
/**
 * The authorization code returned from the payment gateway
 */
@property (nonatomic, readonly) NSString *authorizationCode;
/**
 * The amount of the transaction
 */
@property (nonatomic, readonly) NSDecimalNumber *amount;
/**
 * The amount of the gratiuty associated with the transaction
 */
@property (nonatomic, readonly) NSDecimalNumber *gratuityAmount;
/**
 * The credit card specific transaction data associated with the request, if any
 */
@property (nonatomic, readonly) WPYCardTransactionData *card;
/**
 * The check specific transaction data associated with the request, if any
 */
@property (nonatomic, readonly) WPYCheckTransactionData *check;
/**
 * The billing address associated with the payment request
 */
@property (nonatomic, readonly) WPYAddressInfo *billAddress;
/**
 * The email address that is associated with the request 
 */
@property (nonatomic, strong) NSString *email;
/**
 * The payment type associated with the request
 */
@property (nonatomic, readonly) WPYPaymentType paymentType;
/**
 * Additional data that may be associated with the transaction stored as key/value pairs
 */
@property (nonatomic, strong) NSDictionary *additionalData;
/**
 * Response text from the payment processor containing information about the transaction.
 * This will be displayed on the terminal, when possible (See WPYSwiper)
 */
@property (nonatomic, readonly) NSString *responseText;
/**
 * A convenience method to get the WPYTransactionResponse.identifier associated with the transaction
 */
@property (nonatomic, readonly, getter=getTransactionId) NSString *transactionId;
/**
 * This optional parameter contains data that the merchant wishes to pass up to the payment gateway for that specific transaction
 */
@property (nonatomic, strong) WPYLevelTwoData *levelTwoData;
@end
