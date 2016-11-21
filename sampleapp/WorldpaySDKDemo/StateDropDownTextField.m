//
//  StateDropDownTextField.m
//  WorldpaySDKDemo
//
//  Created by Jonas Whidden on 11/21/16.
//  Copyright © 2016 Worldpay. All rights reserved.
//

#import "StateDropDownTextField.h"

@implementation StateDropDownTextField

- (BOOL)sharedInitWithOptionList:(NSArray *)optionList initialIndex:(NSUInteger)initialIndex parentViewController:(UIViewController *)parentViewController title:(NSString *)title
{
    return [super sharedInitWithOptionList:@[@"AK", @"AL", @"AR", @"AS", @"AZ", @"CA", @"CO", @"CT", @"DC", @"DE", @"FL", @"FM", @"GA", @"GU", @"HI", @"IA", @"ID", @"IL", @"IN", @"KS", @"KY", @"LA", @"MA", @"MD", @"ME", @"MH", @"MI", @"MN", @"MO", @"MP", @"MS", @"MT", @"NC", @"ND", @"NE", @"NH", @"NJ", @"NM", @"NV", @"NY", @"OH", @"OK", @"OR", @"PA", @"PR", @"PW", @"RI", @"SC", @"SD", @"TN", @"TX", @"UT", @"VA", @"VI", @"VT", @"WA", @"WI", @"WV", @"WY"] initialIndex:initialIndex parentViewController:parentViewController title:@"State"];
}

@end
