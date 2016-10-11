//
//  VoidRefundViewController.m
//  WorldPaySDKDemo
//
//  Created by Harsha Chennamchetty on 10/11/16.
//  Copyright © 2016 WorldPay. All rights reserved.
//

#import "VoidRefundViewController.h"
#import "DropDownTextField.h"
#import "UIColor+WorldPay.h"

@interface VoidRefundViewController ()

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (weak, nonatomic) IBOutlet DropDownTextField *transactionTypeDropDown;
@property (weak, nonatomic) IBOutlet UITextField *transactionIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) UITextField *activeTextField;

@end

@implementation VoidRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(![self.transactionTypeDropDown sharedInitWithOptionList:@[@"Void", @"Refund"] initialIndex:0 parentViewController:self title:@"Transaction Type"])
    {
        NSAssert(FALSE, @"%@", @"Drop down failed to initialized properly");
    }
    
    for(UITextField * textField in self.textFields)
    {
        textField.delegate = self;
    }
    
    UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFocusFromTextField:)];
    [recognizer1 setNumberOfTapsRequired:1];
    [recognizer1 setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:recognizer1];
    
    [self.transactionTypeDropDown setSelectionCallback:^(NSUInteger __unused index)
    {
        [self removeFocusFromTextField:nil];
    }];
    
    self.startButton.backgroundColor = [UIColor worldpayMist];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startTransaction:(id)sender
{
    // TODO: Verify transaction id is present, check amount > 0, create void/refund request and send to API, show pop up with results that can direct user to transaction details screen
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
