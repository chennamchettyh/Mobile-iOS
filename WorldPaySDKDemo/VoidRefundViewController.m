//
//  VoidRefundViewController.m
//  WorldPaySDKDemo
//
//  Created by Harsha Chennamchetty on 10/11/16.
//  Copyright © 2016 WorldPay. All rights reserved.
//

#import "VoidRefundViewController.h"
#import "DropDownTextField.h"

@interface VoidRefundViewController ()

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (weak, nonatomic) IBOutlet DropDownTextField *transactionTypeDropDown;
@property (weak, nonatomic) IBOutlet UITextField *transactionIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation VoidRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // TODO: Set up drop down, set up delegates, style UI as nececessary
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startTransaction:(id)sender
{
    // TODO: Verify transaction id is present, check amount > 0, create void/refund request and send to API, show pop up with results that can direct user to transaction details screen
}

@end
