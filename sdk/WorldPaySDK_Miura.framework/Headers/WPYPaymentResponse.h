//
//  WPYPaymentResponse.h
//  WorldpaySDK
//
//  Copyright © 2015 Worldpay. All rights reserved.
//

#import "WPYDomainObject.h"
#import "WPYSwiper.h"

@class WPYEMVData;
@class WPYTransaction;
@class WPYReceiptObject;

/**
 * This object is returned by the server upon completion of a payment request
 */
@interface WPYPaymentResponse : WPYDomainObject
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
 * This object contains the transaction data from the server
 */
@property (nonatomic, readonly) WPYTransaction *transaction;
/**
 * This object contains information to help create a proper receipt. See Worldpay's receipt
 * guide for more information
 */
@property (nonatomic, strong) WPYReceiptObject *receiptData;
/**
 * This contains information about the result of a terminal based transaction. The result code is the terminal response
 * for a transaction and indicates whether or not the terminal considers the transaction approved, declined, reversed, or
 * if there was some error on the terminal in attempting to process the request.
 */
@property (nonatomic) WPYTransactionResult resultCode;
@end
