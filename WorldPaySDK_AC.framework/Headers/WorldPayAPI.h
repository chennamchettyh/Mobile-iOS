//
//  WorldpayAPI.h
//  WorldpaySDK
//
//  Copyright (c) 2015 Worldpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPYSwiper.h"

@protocol WPYSwiperDelegate;
@class WPYAuthTokenRequest;
@class WPYTender;
@class WPYCustomerData;
@class WPYPaymentMethod;
@class WPYPaymentMethodRequest;

@class WPYPaymentAuthorize;
@class WPYPaymentCapture;
@class WPYPaymentCharge;
@class WPYPaymentVoid;
@class WPYPaymentRefund;
@class WPYPaymentCredit;
@class WPYTransactionResponse;
@class WPYBatchResponse;
@class WPYGiftCardResponse;
@class WPYPaymentResponse;
@class WPYTransactionSearch;

extern NSString *const WorldpaySDKErrorDomain;

/**
 * This is the error code returned when an NSError is generated due to a missing authentication token.
 * No web service calls can complete (except for the token request) without a valid authorization token
 */
typedef NS_ENUM(NSInteger, WorldpaySDKError)
{
    WorldpaySDKErrorNoAuthToken = 10001,
    WorldpaySDKErrorInvalidRequestTypeForTender = 100002, // Returned if you try to run an auth on a manually entered check, for instance
    WorldpaySDKErrorTerminalConnectionLost = 100003
};


@interface WorldpayAPI : NSObject

/**
 * Tells the WorldpayAPI object to send messages to the test host configured at compile time
 */
@property (nonatomic) BOOL enableTestHost;

/**
 *  The terminal ID set when the auth token request was made
 */
@property (nonatomic, readonly) NSString *terminalId;

/**
 * Returns shared instance pointer of the WorldpayAPI entry point
 *
 * @return instance pointer to singleton class
 */
+ (WorldpayAPI *)instance;

/**
 WorldpayServerErrorDomain is the error domain used when the server attempted to process the response, but could not
 */
extern NSString *const WorldpayServerErrorDomain;

/**
 * Class instance init unavailable.  Use [WorldpayApi instance] to get class instance
 *
 * @return instance of class
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Returns a pointer to a credit card swiper object
 *
 * @param delegate that will listen to swiper events
 *
 * @return WPYSwiper object
 */
- (WPYSwiper *)swiperWithDelegate:(id<WPYSwiperDelegate>)delegate;

#pragma mark authentication

/**
 * Authenticates user credentials against the World Pay server. The token
 * will automatically be saved in the application keychain by the SDK and
 * can be removed by calling: - (void)clearSDKKeychain
 *
 * @param Auth Token Request object containing user credentials
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)generateAuthToken:(WPYAuthTokenRequest *)authTokenRequest withCompletion:(void(^)(NSString *, NSError *))completion;

/**
 * Clears the keychain data out of the application. Completely resets the auth token information
 * and removes it from the application keychain.  A new auth token must be generated in order
 * to make calls to the web APIs after this is executed
 */
- (void)clearSDKKeychain;
#pragma mark batch handling

/**
 * Gets the current batch identifier
 *
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)getCurrentBatchWithCompletion:(void(^)(WPYBatchResponse *, NSError *))completion;

/**
 * Closes the current batch
 *
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)closeCurrentBatchWithCompletion:(void(^)(WPYBatchResponse *, NSError *))completion;

#pragma mark Stored Customer Info

/**
 * Gets customer data from the server
 *
 * @param Customer ID that reqpresents the desired customer
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)getCustomerDataForCustomerId:(NSString *)customerId withCompletion:(void(^)(WPYCustomerData *, NSError *))completion;

/**
 * Creates a new customer object to be stored on the server
 *
 * @param the customer data that should be saved on the server
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)createCustomer:(WPYCustomerData *)customerData withCompletion:(void(^)(WPYCustomerData *, NSError *))completion;

/**
 * Updates an existing customer on the server
 *
 * @param the customer data that should be updated
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)updateCustomer:(WPYCustomerData *)customerData withCompletion:(void(^)(WPYCustomerData *, NSError *))completion;

#pragma mark Gift Card
/**
 * Get Gift Card from server
 *
 * @param identifier for gift card
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)getGiftCard:(NSString *)identifier withCompletion:(void(^)(WPYGiftCardResponse *, NSError *))completion;

/**
 * Update gift card stored on the server
 *
 * param identifier for the card to be updated
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)updateGiftCard:(NSString *)identifer withCompletion:(void(^)(WPYGiftCardResponse *, NSError *))completion;

/**
 * Create a new gift card to be stored on the serfver
 *
 * @param identifier of the card to be stored on the server
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)createGiftCard:(NSString *)identifier withCompletion:(void(^)(WPYGiftCardResponse *, NSError *))completion;

#pragma mark customer stored payment methods
/**
 * Delete a payment method being stored on the server
 *
 * @param payment method to be deleted on the server
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)deletePaymentMethod:(WPYPaymentMethod *)paymentMethod withCompletion:(void(^)(NSError *))completion;

/**
 * Get payment method from the server
 *
 * @param identifier of the payment method stored on the server
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)getPaymentMethod:(NSString *)identifier withCompletion:(void(^)(WPYPaymentMethod *, NSError *))completion;

/**
 * Update an existing payment method on the server
 *
 * @param Request object containing the new payment method information
 * @param the existing payment method that is to be updated
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)updatePaymentMethod:(WPYPaymentMethodRequest *)request paymentMethod:(WPYPaymentMethod *)paymentMethod withCompletion:(void(^)(WPYPaymentMethod *, NSError *))completion;

/**
 * Create a new payment method on the server
 *
 * @param Request object containing the payment method information
 * @param The customer ID for the new payment method
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)createPaymentMethod:(WPYPaymentMethodRequest *)request customerId:(NSString *)customerId withCompletion:(void(^)(WPYPaymentMethod *, NSError *))completion;

#pragma mark payment processing
/**
 * Request Authorization of a payment
 *
 * @param payment authorize request object with the appropriate payment information
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)paymentAuthorize:(WPYPaymentAuthorize *)request withCompletion:(void(^)(WPYPaymentResponse *, NSError *))completion;

/**
 * Capture an authorized payment
 *
 * @param payment capture request object with the information about the authorized request
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)paymentCapture:(WPYPaymentCapture *)request withCompletion:(void(^)(WPYPaymentResponse *, NSError *))completion;

/**
 * Immediately charge payment using the requested payment type
 *
 * @param payment charge request object containing all of the information needed to charge a payment
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)paymentCharge:(WPYPaymentCharge *)request withCompletion:(void(^)(WPYPaymentResponse *, NSError *))completion;

/**
 * Void an authorized payment
 *
 * @param Payment Void request object that contains the needed information to void an authorized transaction
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)paymentVoid:(WPYPaymentVoid *)request withCompletion:(void(^)(WPYPaymentResponse *, NSError *))completion;

/**
 * Refund a payment that has been captured
 *
 * @param PaymentRefund request object needed to refund a captured payment
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)paymentRefund:(WPYPaymentRefund *)request withCompletion:(void(^)(WPYPaymentResponse *, NSError *))completion;

/**
 * Request a credit to the tender in the request object
 *
 * @param Payment Credit request object containing the tender info needed to apply a credit
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)paymentCredit:(WPYPaymentCredit *)request withCompletion:(void(^)(WPYPaymentResponse *, NSError *))completion;

#pragma mark transactions
/**
 * Get details for a transaction by identifier
 *
 * @param transaction identifier
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)getTransactionDetails:(NSString *)transactionId withCompletion:(void(^)(WPYTransactionResponse *, NSError *))completion;

/**
 * Search transactions
 *
 * @param search parameters include the start and end date for the search
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)searchTransactions:(WPYTransactionSearch *)searchParams withCompletion:(void(^)(NSArray<WPYTransactionResponse *> *, NSError *))completion;

/**
 * Get transactions in the current batch
 *
 * @param batch identifier for transactions
 * @param completion handler used to notify the caller of any server results or errors
 */
- (void)getTransactionsInBatch:(NSString *)batchId withCompletion:(void(^)(NSArray<WPYTransactionResponse *> *, NSError *))completion;
@end


@interface WPYLogger : NSObject
+ (void)logMessage:(NSString *)message, ...;
@end
