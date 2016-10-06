//
//  DropDownTextField.m
//  WorldPaySDKDemo
//
//  Created by Jonas Whidden on 10/4/16.
//  Copyright © 2016 WorldPay. All rights reserved.
//

#import "DropDownTextField.h"

@interface DropDownTextField ()

@property (nonatomic, assign) NSUInteger _selectedIndex;
@property (nonatomic, strong) NSArray * _optionList;
@property (nonatomic, strong) UIAlertController * _actionSheet;
@property (nonatomic, weak) UIViewController * _parentViewController;

@end

@implementation DropDownTextField

- (BOOL) sharedInitWithOptionList: (NSArray *) optionList initialIndex: (NSUInteger) initialIndex parentViewController: (UIViewController *) parentViewController title: (NSString *) title
{
    if(!(optionList.count > 0))
    {
        return NO; // Must have atleast one option
    }
    
    if(initialIndex > optionList.count - 1)
    {
        return NO; // Initial index must be in option list bounds
    }
    
    if(parentViewController == nil)
    {
        return NO; // parentViewController cannot be nil
    }
    
    for (id option in optionList)
    {
        if(![option isKindOfClass:[NSString class]])
        {
            return NO;
        }
    }
    
    self._optionList = optionList;
    [self setSelectedIndex:initialIndex];
    self._parentViewController = parentViewController;
    self.delegate = self;
    
    self._actionSheet = [UIAlertController alertControllerWithTitle:title message: nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSString * option in optionList)
    {
        [self._actionSheet addAction:[UIAlertAction actionWithTitle:option style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            [self performSelectorOnMainThread:@selector(setSelectedObjectIndex:) withObject:@([[self._actionSheet actions] indexOfObject:action]) waitUntilDone:NO];
            [self._actionSheet dismissViewControllerAnimated:YES completion:nil];
        }]];
    }
    
    return YES;
}

-(instancetype)initWithFrame:(CGRect)frame optionList: (NSArray *) optionList initialIndex: (NSUInteger) initialIndex parentViewController: (UIViewController *) parentViewController title: (NSString *) title
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        if([self sharedInitWithOptionList:optionList initialIndex:initialIndex parentViewController:parentViewController title:title] ==  NO)
        {
            return nil;
        }
    }
    
    return self;
}

- (void) setSelectedIndex: (NSUInteger) selectedIndex
{
    self._selectedIndex = selectedIndex;
    self.text = [self selectedValue];
}

- (void) setSelectedObjectIndex: (NSNumber *) index
{
    [self setSelectedIndex:index.unsignedIntegerValue];
}

- (void) showDropDown
{
    [self._parentViewController presentViewController:self._actionSheet animated:YES completion:nil];
}

- (NSUInteger) selectedIndex
{
    return self._selectedIndex;
}

- (NSString *) selectedValue
{
    return self._optionList[self._selectedIndex];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self showDropDown];
    
    return NO;
}

@end
