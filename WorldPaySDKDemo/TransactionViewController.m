//
//  TransactionViewController.m
//  WorldPaySDKDemo
//
//  Created by Jonas Whidden on 10/4/16.
//  Copyright © 2016 WorldPay. All rights reserved.
//

#import "TransactionViewController.h"
#import "DropDownTextField.h"

#define YESINDEX 0

#define AUTHORIZEINDEX 0
#define CHARGEINDEX 1
#define CAPTUREINDEX 2

@interface TransactionViewController ()

@property (weak, nonatomic) IBOutlet DropDownTextField *transactionTypeDropDown;
@property (weak, nonatomic) IBOutlet DropDownTextField *cardPresentDropDown;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (strong, nonatomic) WPYSwiper * swiper;

@end

@implementation TransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(![self.cardPresentDropDown sharedInitWithOptionList:@[@"Yes", @"No"] initialIndex:0 parentViewController:self title:@"Card Present"])
    {
        NSAssert(FALSE, @"%@", @"Drop down failed to initialized properly");
    }
    
    if(![self.transactionTypeDropDown sharedInitWithOptionList:@[@"Authorize", @"Charge", @"Capture"] initialIndex:0 parentViewController:self title:@"Transaction Type"])
    {
        NSAssert(FALSE, @"%@", @"Drop down failed to initialized properly");
    }
    
    self.swiper = [[WorldpayAPI instance] swiperWithDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) startTransaction
{
    // TODO: Create request dynamically based on selected index
    
    // TODO: Set amount / other required fields for all transaction types here
    
    if([self.cardPresentDropDown selectedIndex] != YESINDEX)
    {
        // TODO: Populate request manually for card not present
    }
    else
    {
        [self.swiper connectSwiperWithInputType:WPYSwiperInputTypeBluetooth];
    }
    
    switch([self.transactionTypeDropDown selectedIndex])
    {
        case AUTHORIZEINDEX:
        {
            WPYPaymentAuthorize * authorize = [WPYPaymentAuthorize new];
            
            authorize.amount = [NSDecimalNumber decimalNumberWithString:self.amountTextField.text];
            
            [self.swiper beginEMVTransactionWithRequest:authorize transactionType:WPYEMVTransactionTypeGoods];
            
            break;
        }
    }
    
    if([self.cardPresentDropDown selectedIndex] == YESINDEX)
    {
        // TODO: When requests are dynamic, begin EMV transaction here
    }
    else
    {
        // TODO: When requests are dynamic, begin API call here
    }
}

#pragma mark - WPYSwiperDelegate

- (void)didConnectSwiper:(WPYSwiper *)swiper
{
    NSLog(@"%@", @"Swiper connected");
}

- (void)didDisconnectSwiper:(WPYSwiper *)swiper
{
    NSLog(@"%@", @"Swiper disconnected");
}

- (void)didFailToConnectSwiper:(WPYSwiper *)swiper
{
    NSLog(@"%@", @"Swiper failed to connect");
}

- (void)willConnectSwiper:(WPYSwiper *)swiper
{
    NSLog(@"%@", @"Swiper will connect");
}

- (void)swiper:(WPYSwiper *)swiper didFailWithError:(NSString *)error
{
    NSLog(@"%@: %@", @"Swiper did fail with error", error);
}

- (void)swiper:(WPYSwiper *)swiper didFinishTransactionWithResponse:(WPYPaymentResponse *)response
{
    NSLog(@"%@: %@", @"Swiper finished transaction with response", response);
}

- (void)swiper:(WPYSwiper *)swiper didFailRequest:(WPYPaymentRequest *)request withError:(NSError *)error
{
    NSLog(@"%@: %@", @"Swiper failed request with error", error);
}


@end
