//
//  WPYDomainObject.h
//  WorldpaySDK
//
//  Copyright © 2015 Worldpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/**
 * Indicates how (and whether) the method should check for duplicate accounts. Defaults to 1.
 *
 * 0 - Does not check for Duplicate Card Number for specified Customer ID
 * 1 - Checks for Duplicate Card Number for specified Customer ID
 * 2 - Checks for Duplicate Card Number for All Customer IDs for specified SecureNet ID
 * 3 - Checks for Duplicate Card Number for All Customer IDs for specified Group ID
 */
typedef NS_ENUM(NSInteger, WPYPaymentMethodDuplicateCheckType)
{
    WPYPaymentMethodDuplicateCheckTypeUnset = -1,
    WPYPaymentMethodDuplicateCheckTypeNone = 0,
    WPYPaymentMethodDuplicateCheckTypeCustomer = 1,
    WPYPaymentMethodDuplicateCheckTypeAllCustomersUnderId = 2,
    WPYPaymentMethodDuplicateCheckTypeAllCustomersUnderGroup = 3
};

/**
 * Indicates how checks for duplicate transactions should behave. Duplicates are evaluated on the basis of
 * amount, card number, and order ID; these evaluation criteria can be extended to also include customer ID,
 * invoice number, or a user-defined field. Valid values for this parameter are:
 *
 * 0 - No duplicate check
 * 1 - Exception code is returned in case of duplicate
 * 2 - Previously existing transaction is returned in case of duplicate
 * 3 - Check is performed as above but without using order ID, and exception code is returned in case of
 * duplicate
 *
 * The transactionDuplicateCheckIndicator parameter must be enabled in the Virtual Terminal under Tools
 * -> Duplicate Transactions. Duplicates are checked only for APPROVED transactions.
 */
typedef NS_ENUM(NSInteger, WPYTransactionDuplicateCheckType)
{
    WPYTransactionDuplicateCheckTypeUnset = -1,
    WPYTransactionDuplicateCheckTypeNone = 0,
    WPYTransactionDuplicateCheckTypeException = 1,
    WPYTransactionDuplicateCheckTypePreviousTransaction = 2,
    WPYTransactionDuplicateCheckTypeExceptionNoOrderId = 3
};

/**
 * Gateway Response code indicating whether the request was approved, declined, or resulted in a server error.
 * The response code is set on all parent response objects being returned from the gateway
 */
typedef NS_ENUM(NSInteger, WPYResponseCode)
{
    /// Self-explanatory
    WPYResponseCodeApproved = 0x01,
    /// Self-explanatory
    WPYResponseCodeDeclined,
    /// Self-explanatory
    WPYResponseCodeError,
    /// Self-explanatory
    WPYResponseCodeTransactionTerminated,
    /// Self-explanatory
    WPYResponseCodeReversal,
};

/// Base class for most of the objects within Worldpay Total
@interface WPYDomainObject : NSObject <NSCopying>
/**
 * The server returns object ID's as "id", which is a protected word in Objective-C.  This property 
 * contains the id returned by the server for any object returned by the server
 */
@property (nonatomic, readonly) NSString *identifier;

/**
 * The json string used in interacting with the server
 */
- (NSMutableDictionary *)jsonDictionary;
/**
 * Initiatilize the internal jsonDictionary with a provided json string
 * @param jsonDictionary Json string used to initialize the object
 */
- (instancetype)initWithDictionary:(NSDictionary *)jsonDictionary;
@end
