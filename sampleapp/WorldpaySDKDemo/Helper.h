//
//  NSObject_Helper.h
//  WorldpaySDKDemo
//
//  Created by Harsha Chennamchetty on 10/7/16.
//  Copyright © 2016 Worldpay. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef ANYWHERE_NOMAD
#import <WorldPaySDK_AC/WorldPaySDK.h>
#else
#import <WorldPaySDK_Miura/WorldPaySDK.h>
#endif

@interface Helper: NSObject

+(NSString *)getPaymentType: (WPYPaymentType)paymentType;

@end



