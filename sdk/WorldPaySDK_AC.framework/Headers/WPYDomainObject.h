//
//  WPYDomainObject.h
//  WorldpaySDK
//
//  Copyright © 2015 Worldpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef NS_ENUM(NSInteger, WPYPaymentMethodDuplicateCheckType)
{
    WPYPaymentMethodDuplicateCheckTypeUnset = -1,
    WPYPaymentMethodDuplicateCheckTypeNone = 0,
    WPYPaymentMethodDuplicateCheckTypeCustomer = 1,
    WPYPaymentMethodDuplicateCheckTypeAllCustomersUnderId = 2,
    WPYPaymentMethodDuplicateCheckTypeAllCustomersUnderGroup = 3
};

/**
 * Gateway Response code indicating whether the request was approved, declined, or resulted in a server error.
 * The response code is set on all parent response objects being returned from the gateway
 */
typedef NS_ENUM(NSInteger, WPYResponseCode)
{
    WPYResponseCodeApproved = 0x01,
    WPYResponseCodeDeclined,
    WPYResponseCodeError
};

@interface WPYDomainObject : NSObject <NSCopying>
/**
 * The server returns object ID's as "id", which is a protected word in Objective-C.  This property 
 * contains the id returned by the server for any object returned by the server
 */
@property (nonatomic, readonly) NSString *identifier;


- (NSMutableDictionary *)jsonDictionary;
- (instancetype)initWithDictionary:(NSDictionary *)jsonDictionary;
@end
