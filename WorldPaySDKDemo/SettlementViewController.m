//
//  SettlementViewController.m
//  WorldPaySDKDemo
//
//  Created by Harsha Chennamchetty on 10/12/16.
//  Copyright © 2016 WorldPay. All rights reserved.
//

#import "SettlementViewController.h"
#import "UIColor+Worldpay.h"
#import "BatchDetailTableViewController.h"

@interface SettlementViewController ()
@property (weak, nonatomic) IBOutlet UIButton *getBatchButton;
@property (weak, nonatomic) IBOutlet UIButton *closeBatchButton;
@property (weak, nonatomic) UITextField * activeTextField;
@property (weak, nonatomic) IBOutlet UITextField *batchIdTextField;

@end

@implementation SettlementViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        self.title = @"Settlement";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.getBatchButton setBackgroundColor: [UIColor worldpayMist]];
    [self.closeBatchButton setBackgroundColor: [UIColor worldpayMist]];
    
    self.batchIdTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showTransactionsInBatch:(NSString *) batchId
{
    [[WorldpayAPI instance] getTransactionsInBatch:batchId withCompletion:^(NSArray<WPYTransactionResponse *> * transactions, NSError * error)
    {
        if(error != nil)
        {
            NSLog(@"%@",error);
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"An error occurred." preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        }
        else
        {
            BatchDetailTableViewController * batchDetailTableVC = [[BatchDetailTableViewController alloc] initWithTransactions:transactions];
            
            [self.navigationController pushViewController:batchDetailTableVC animated:true];
        }
    }];
}

- (IBAction)getBatch:(id)sender
{
    if([self.batchIdTextField.text isEqualToString:@""])
    {
        [[WorldpayAPI instance] getCurrentBatchWithCompletion:^(WPYBatchResponse * response, NSError * error)
        {
            if(error != nil)
            {
                NSLog(@"%@",error);
                
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"An error occurred." preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            }
            else
            {
                [self showTransactionsInBatch:response.identifier];
            }
        }];
    }
    else
    {
        [self showTransactionsInBatch:self.batchIdTextField.text];
    }
}

- (IBAction)closeBatch:(id)sender
{
    [[WorldpayAPI instance] closeCurrentBatchWithCompletion:^(WPYBatchResponse * response, NSError * error)
    {
        if(error != nil)
        {
            NSLog(@"%@",error);
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"An error occurred." preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        }
        else
        {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Response" message:@"Batch was successfully closed." preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"View Transactions" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
            {
                [self showTransactionsInBatch:response.identifier];
            }]];
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (void) removeFocusFromTextField: (UITextField * __unused) textField
{
    if(self.activeTextField)
    {
        [self.activeTextField resignFirstResponder];
        self.activeTextField = nil;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self removeFocusFromTextField:textField];
    
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self removeFocusFromTextField:textField];
}

@end
