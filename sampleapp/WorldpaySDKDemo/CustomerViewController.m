//
//  CustomerViewController.m
//  WorldpaySDKDemo
//
//  Created by Jonas Whidden on 10/13/16.
//  Copyright © 2016 Worldpay. All rights reserved.
//

#import "CustomerViewController.h"

@interface CustomerViewController ()

@property (nonatomic, assign) RESTMode mode;
@property (nonatomic, strong) WPYCustomerRequestData * customer;
@property (nonatomic, weak) IBOutlet UIButton * submitButton;
@property (nonatomic, weak) IBOutlet UIButton * cancelButton;

@end

@implementation CustomerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [Helper styleButtonPrimary:self.submitButton];
    [Helper styleButtonPrimary:self.cancelButton];
    
    if(self.mode == RESTModeCreate)
    {
        self.title = @"Create Customer";
        self.customer = [[WPYCustomerRequestData alloc] init];
        [self.submitButton setTitle:@"Create" forState:UIControlStateNormal];
        [self.submitButton addTarget:self action:@selector(createCustomer) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(self.mode == RESTModeEdit)
    {
        self.title = @"Edit Customer";
        [self syncUIToCustomer];
        [self.submitButton setTitle:@"Save" forState:UIControlStateNormal];
        [self.submitButton addTarget:self action:@selector(saveCustomer) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self enableButtons];
}

- (void) setRESTMode: (RESTMode) mode
{
    self.mode = mode;
}

- (BOOL) setEditableCustomer: (WPYCustomerRequestData *) customer
{
    if(self.mode == RESTModeEdit)
    {
        self.customer = customer;
        
        return true;
    }
    
    return false;
}

- (void) syncUIToCustomer
{
    // Fill in UI with data from model
}

- (void) syncCustomerToUI
{
    // Fill in model with data from UI
}

- (void) createCustomer
{
    [self disableButtons];
    
    [self syncCustomerToUI];
    
    // TODO: Process request and re-enable buttons
}

- (void) saveCustomer
{
    [self disableButtons];
    
    [self syncCustomerToUI];
    
    // TODO: Process request and re-enable buttons
}

- (void) enableButtons
{
    [self.submitButton setEnabled:true];
    [self.cancelButton setEnabled:true];
}

- (void) disableButtons
{
    [self.submitButton setEnabled:false];
    [self.cancelButton setEnabled:false];
}

- (IBAction) cancel:(id)sender
{
    [self disableButtons];
    
    [self.navigationController popViewControllerAnimated:true];
}

@end
