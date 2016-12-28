//
//  WPYDomainObject.h
//  WorldpaySDK
//
//  Copyright © 2015 Worldpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/// To Be Documented
typedef NS_ENUM(NSInteger, WPYPaymentMethodDuplicateCheckType)
{
    /// To Be Documented
    WPYPaymentMethodDuplicateCheckTypeUnset = -1,
    /// To Be Documented
    WPYPaymentMethodDuplicateCheckTypeNone = 0,
    /// To Be Documented
    WPYPaymentMethodDuplicateCheckTypeCustomer = 1,
    /// To Be Documented
    WPYPaymentMethodDuplicateCheckTypeAllCustomersUnderId = 2,
    /// To Be Documented
    WPYPaymentMethodDuplicateCheckTypeAllCustomersUnderGroup = 3
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
