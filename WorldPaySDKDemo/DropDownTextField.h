//
//  DropDownTextField.h
//  WorldPaySDKDemo
//
//  Created by Jonas Whidden on 10/4/16.
//  Copyright © 2016 WorldPay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownTextField : UITextField <UITextFieldDelegate>

- (NSString *) selectedValue;
- (NSUInteger) selectedIndex;

- (BOOL) sharedInitWithOptionList: (NSArray *) optionList initialIndex: (NSUInteger) initialIndex parentViewController: (UIViewController *) parentViewController title: (NSString *) title;

@end
