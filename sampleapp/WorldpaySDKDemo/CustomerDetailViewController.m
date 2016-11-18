//
//  CustomerDetailViewController.m
//  WorldpaySDKDemo
//
//  Created by Jonas Whidden on 10/13/16.
//  Copyright © 2016 Worldpay. All rights reserved.
//

#import "CustomerDetailViewController.h"

@interface CustomerDetailViewController ()

@property (nonatomic, strong) WPYCustomerResponseData * customer;

@end

@implementation CustomerDetailViewController

- (instancetype) initWithCustomer: (WPYCustomerResponseData *) customer
{
    if((self = [super initWithNibName:nil bundle:nil]))
    {
        self.customer = customer;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Customer Details";
    
    // TODO: Start with logic from customer list view controller to finish off this screen
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
