//
//  Helper.m
//  WorldPaySDKDemo
//
//  Created by Harsha Chennamchetty on 10/7/16.
//  Copyright © 2016 WorldPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Helper.h"


@implementation Helper



+(NSString *)getPaymentType: (WPYPaymentType)paymentType {
    
    NSString * result;
    
    switch (paymentType) {
        case WPYPaymentTypeUnknown:
            result = @"Unknown Payment Type";
            break;
        case WPYPaymentTypeCheck:
            result = @"Check Payment Type";
            break;
        case WPYPaymentTypeDebitCard:
            result = @"Debit Payment Type";
            break;
        case WPYPaymentTypeCreditCard:
            result = @"Credit Payment Type";
            break;
        case WPYPaymentTypeStoredValue:
            result  = @"Stored Vault Payment Type";
            break;
        default:
            break;
    }
    
    return result;
    
}




@end



/*
 
 WPYPaymentType:
 
 WPYPaymentTypeUnknown = 0,
 WPYPaymentTypeCheck = 1,
 WPYPaymentTypeDebitCard = 2,
 WPYPaymentTypeCreditCard = 3,
 WPYPaymentTypeStoredValue = 4,
 
 
 
 
 */
