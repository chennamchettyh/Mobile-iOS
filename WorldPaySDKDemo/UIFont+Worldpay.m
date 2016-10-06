//
//  UIFont+Worldpay.m
//  WorldPaySDKDemo
//
//  Created by Jonas Whidden on 10/6/16.
//  Copyright © 2016 WorldPay. All rights reserved.
//

#import "UIFont+Worldpay.h"

#define PRIMARYFONTNAME @"ArialMT"

@implementation UIFont (Worldpay)

+ (UIFont *) worldpayPrimaryWithSize: (CGFloat) size
{
    return [self fontWithName: PRIMARYFONTNAME size: size];
    
    // Primary should be Adelle Sans, but we don't have the font files at the moment
    // Secondary should be Calibri, but it's a Microsoft font
    // Tertiary should be Arial, but it's our only option
}

+ (NSDictionary *) worldpayPrimaryAttributesWithSize: (CGFloat) size
{
    return @{NSFontAttributeName : [self worldpayPrimaryWithSize: size]};
}

@end
