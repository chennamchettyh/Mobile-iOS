//
//  ExtendedInformationView.m
//  WorldPaySDKDemo
//
//  Created by Jonas Whidden on 10/7/16.
//  Copyright © 2016 WorldPay. All rights reserved.
//

#import "ExtendedInformationView.h"

#define VIEWHEIGHT 272

@interface ExtendedInformationView ()

@property (nonatomic, strong) IBOutlet UIView * view;

@end

@implementation ExtendedInformationView

- (void) sharedInit
{
    [[NSBundle mainBundle] loadNibNamed:@"ExtendedInformationView" owner:self options:nil];
    [self addSubview: self.view];
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
    {
        [self sharedInit];
    }
    
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    [self sharedInit];
}

+ (CGFloat) expectedHeight
{
    return VIEWHEIGHT;
}


@end
