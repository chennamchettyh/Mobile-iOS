//
//  WPYPaymentCharge.h
//  WorldpaySDK
//
//  Copyright © 2015 Worldpay. All rights reserved.
//

#import "WPYPaymentRequest.h"

@class WPYTenderedCard;
@class WPYTenderedCheck;
@class WPYExtendedCardData;

/**
 * This requests immediate authorization and capture of the tendered check or card.  Inherits the following properties from WPYPaymentRequest:
 * amount, amountOther, card, extendedData (for card processing)
 */
@interface WPYPaymentCharge : WPYPaymentRequest
/**
 * If the merchant is presenting a check instead of a card, this parameter should be supplied at the time of the transaction
 */
@property (nonatomic, strong) WPYTenderedCheck *check;
@end
