//
//  CustomerViewController.m
//  WorldpaySDKDemo
//
//  Created by Jonas Whidden on 10/13/16.
//  Copyright © 2016 Worldpay. All rights reserved.
//

#import "CustomerViewController.h"

#import "LabeledTextField.h"
#import "CustomerDetailViewController.h"

@interface CustomerViewController ()

@property (nonatomic, assign) RESTMode mode;
@property (nonatomic, strong) WPYCustomerRequestData * customer;
@property (nonatomic, weak) IBOutlet UIButton * submitButton;
@property (nonatomic, weak) IBOutlet UIButton * cancelButton;
@property (nonatomic, weak) IBOutlet LabeledTextField * customerIdField;

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
        [self.customerIdField setEnabled:true];
    }
    else if(self.mode == RESTModeEdit)
    {
        self.title = @"Edit Customer";
        [self syncUIToCustomer];
        [self.submitButton setTitle:@"Save" forState:UIControlStateNormal];
        [self.submitButton addTarget:self action:@selector(saveCustomer) forControlEvents:UIControlEventTouchUpInside];
        [self.customerIdField setEnabled:false];
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
    
    [[WorldpayAPI instance] createCustomer:self.customer withCompletion:^(WPYCustomerResponseData * response, NSError * error)
    {
        [self handleResponse:response error:error];
    }];
}

- (void) saveCustomer
{
    [self disableButtons];
    
    [self syncCustomerToUI];
    
    [[WorldpayAPI instance] updateCustomer:[self.customerIdField text] withData:self.customer andCompletion:^(WPYCustomerResponseData * response, NSError * error)
    {
        [self handleResponse:response error:error];
    }];
}

- (void) handleResponse: (WPYCustomerResponseData *) response error: (NSError *) error
{
    if(![self handleError:error response:response])
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Response" message:[NSString stringWithFormat:@"Customer '%@' was successfully %@", response.identifier, (self.mode == RESTModeCreate ? @"created" : @"saved")] preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"View Details" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            CustomerDetailViewController * customerDetailVC = [[CustomerDetailViewController alloc] initWithCustomer:response];
            
            [self presentViewController:customerDetailVC animated:true completion:nil];
        }]];
        
        [self presentViewController:alert animated:true completion:nil];
        
        [self enableButtons];
    }
}

- (BOOL) handleError: (NSError *) error response: (WPYCustomerResponseData *) response
{
    if(error || response.responseCode == WPYResponseCodeError)
    {
        [self enableButtons];
        
        NSLog(@"Error: %@",error);
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"%@ customer failed with an error.%@", (self.mode == RESTModeCreate ? @"Create" : @"Save"),(response.responseMessage.length > 0 ? [NSString stringWithFormat: @"\n\nMessage: %@", response.responseMessage] : @"")] preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alert animated:true completion:nil];
        
        return true;
    }
    
    return false;
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
