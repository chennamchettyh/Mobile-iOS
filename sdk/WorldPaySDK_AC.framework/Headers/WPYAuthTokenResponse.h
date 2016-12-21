//
//  WPYAuthTokenResponse.h
//  WorldPaySDK
//
//  Copyright © 2016 WorldPay. All rights reserved.
//

#import "WPYResponseObject.h"

@interface WPYAuthTokenResponse : WPYResponseObject
/**
 * The authorization token issued by the server.
 */
@property (nonatomic, readonly, getter=authToken) NSString *authToken;
@end
