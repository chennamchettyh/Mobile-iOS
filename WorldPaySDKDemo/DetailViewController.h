//
//  DetailViewController.h
//  WorldPaySDKDemo
//
//  Copyright (c) 2015 WorldPay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@class WPYDomainObject;

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, strong) WPYDomainObject *domainObject;
@property (nonatomic) CommandByRow command;
@end
