//
//  WPYPaymentAuthorize.h
//  WorldpaySDK
//
//  Copyright © 2015 Worldpay. All rights reserved.
//

#import "WPYPaymentRequest.h"

@class WPYTenderedCard;
@class WPYExtendedCardData;
@class WPYPaymentToken;

/**
 * This requests authorization of the provided token or Tendered Card.  Inherits the following properties from WPYPaymentRequest: 
 * amount, amountOther, card, extendedData (for card processing)
 */
@interface WPYPaymentAuthorize : WPYPaymentRequest
/**
 * If using a payment token instead of a presented card or check, this property should be set
 */
@property (nonatomic, strong) WPYPaymentToken *token;
@end
