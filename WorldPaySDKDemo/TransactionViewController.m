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
#define NOINDEX 1

#define AUTHORIZEINDEX 0
#define CHARGEINDEX 1
#define CREDITINDEX 2

@interface TransactionViewController ()

@property (weak, nonatomic) IBOutlet DropDownTextField *transactionTypeDropDown;
@property (weak, nonatomic) IBOutlet DropDownTextField *cardPresentDropDown;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *cashbackTextField;
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
    
    if(![self.transactionTypeDropDown sharedInitWithOptionList:@[@"Authorize", @"Charge", @"Credit"] initialIndex:0 parentViewController:self title:@"Transaction Type"])
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
    WPYPaymentRequest * request;
    WPYEMVTransactionType transactionType = WPYEMVTransactionTypeGoods;
    
    // TODO: Any customization needed here?
    
    switch([self.transactionTypeDropDown selectedIndex])
    {
        case AUTHORIZEINDEX:
            request = [WPYPaymentAuthorize new];
            break;
        case CHARGEINDEX:
            request = [WPYPaymentCharge new];
            break;
        case CREDITINDEX:
            request = [WPYPaymentCredit new];
            break;
        default:
            request = [WPYPaymentAuthorize new];
    }
    
    // TODO: Set amount / other fields for all transaction types here
    
    request.amount = [NSDecimalNumber decimalNumberWithString:self.amountTextField.text];
    
    if([self cashbackAllowed] && self.cashbackTextField.text.doubleValue > 0)
    {
        request.amountOther = [NSDecimalNumber decimalNumberWithString:self.cashbackTextField.text];
        transactionType = WPYEMVTransactionTypeCashback;
    }
    
    if([self.cardPresentDropDown selectedIndex] == NOINDEX)
    {
        // TODO: Populate request manually for card not present
    }
    else
    {
        [self.swiper connectSwiperWithInputType:WPYSwiperInputTypeBluetooth];
    }
    
    if([self.cardPresentDropDown selectedIndex] == NOINDEX)
    {
        // TODO: When requests are dynamic, begin API call here
    }
    else
    {
        [self.swiper beginEMVTransactionWithRequest:request transactionType:WPYEMVTransactionTypeGoods];
    }
}

- (BOOL) cashbackAllowed
{
#ifdef ANYWHERE_NOMAD
    switch([self.transactionTypeDropDown selectedIndex])
    {
        case AUTHORIZEINDEX:
        case CHARGEINDEX:
            return YES;
        case CREDITINDEX:
            return NO;
        default:
            return YES;
    }
#else
    return NO;
#endif
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

- didrecieve

@end
