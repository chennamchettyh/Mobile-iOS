//
//  ExtendableView.m
//  WorldPaySDKDemo
//
//  Created by Jonas Whidden on 10/6/16.
//  Copyright © 2016 WorldPay. All rights reserved.
//

#import "ExtendableView.h"

@interface ExtendableView ()

@property (strong, nonatomic) IBOutlet UIView *view;
@property (assign, nonatomic) CGFloat secondaryViewHeightConstant;
@property (weak, nonatomic) UIView * secondaryView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign, nonatomic) BOOL extended;
@property (copy, nonatomic) void (^callback)(CGFloat);
@property (weak, nonatomic) IBOutlet UIView *secondaryContainerView;

@end

@implementation ExtendableView

- (void) sharedInit
{
    self.extended = false;
    [[NSBundle mainBundle] loadNibNamed:@"ExtendableView" owner:self options:nil];
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

- (void) setTitle: (NSString *) title
{
    self.titleLabel.text = title;
}

- (void) setSecondaryViewInContainer: (UIView *) view
{
    for(UIView * view in self.secondaryContainerView.subviews)
    {
        [view removeFromSuperview];
    }
    
    [self.secondaryContainerView addSubview:view];
    self.secondaryView = view;
}

- (IBAction)toggleSecondaryView:(id)sender
{
    CGFloat __block height;
    
    if(self.extended)
    {
        height = -self.secondaryViewHeightConstant;
        
        self.secondaryViewHeightConstant = 0;
    }
    else
    {
        
        height = self.secondaryView.frame.size.height;
        
        self.secondaryViewHeightConstant = height;
    }
    
    if(self.callback)
    {
        self.callback(height);
    }
    
    [self.view layoutIfNeeded];
    
    self.extended = !self.extended;
}

- (void)setHeightCallback:(void (^)(CGFloat))callback
{
    self.callback = callback;
}

@end
