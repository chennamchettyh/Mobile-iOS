//
//  TransactionViewController.m
//  WorldPaySDKDemo
//
//  Created by Jonas Whidden on 10/4/16.
//  Copyright © 2016 WorldPay. All rights reserved.
//

#import "TransactionViewController.h"
#import "DropDownTextField.h"
#import "ExtendableView.h"
#import "UIFont+Worldpay.h"
#import "ExtendedInformationView.h"

#define YESINDEX 0
#define NOINDEX 1

#define AUTHORIZEINDEX 0
#define CHARGEINDEX 1
#define CREDITINDEX 2

#define LABELTEXTSIZE 17
#define TEXTFIELDSIZE 14
#define BUTTONTEXTSIZE 15

#define WIDTHCONSTANT 200

@interface TransactionViewController ()

@property (weak, nonatomic) IBOutlet DropDownTextField *transactionTypeDropDown;
@property (weak, nonatomic) IBOutlet UISegmentedControl *cardPresentSegmented;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *cashbackTextField;
@property (strong, nonatomic) WPYSwiper * swiper;
@property (weak, nonatomic) IBOutlet ExtendableView *extendableInfoView;
@property (weak, nonatomic) ExtendedInformationView * extendedInfoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *extendableViewHeightConstraint;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *formLabels;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@end

@implementation TransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(![self.transactionTypeDropDown sharedInitWithOptionList:@[@"Authorize", @"Charge", @"Credit"] initialIndex:0 parentViewController:self title:@"Transaction Type"])
    {
        NSAssert(FALSE, @"%@", @"Drop down failed to initialized properly");
    }
    
    self.swiper = [[WorldpayAPI instance] swiperWithDelegate:self];
    
    [self.extendableInfoView setTitle:@"Extended Information"];
    ExtendedInformationView * infoView = [[ExtendedInformationView alloc] initWithFrame:CGRectMake(0, 0, self.extendableInfoView.frame.size.width, [ExtendedInformationView expectedHeight])];
    
    [self.extendableInfoView setSecondaryViewInContainer:infoView];
    [self.extendableInfoView setHeightConstraint:self.extendableViewHeightConstraint];
    
    self.extendedInfoView = infoView;
    
    [self.amountTextField setFont:[UIFont worldpayPrimaryWithSize: TEXTFIELDSIZE]];
    [self.cashbackTextField setFont:[UIFont worldpayPrimaryWithSize: TEXTFIELDSIZE]];
    [self.cardPresentSegmented setTitleTextAttributes:[UIFont worldpayPrimaryAttributesWithSize: TEXTFIELDSIZE] forState:UIControlStateNormal];
    [self.startButton.titleLabel setFont:[UIFont worldpayPrimaryWithSize: BUTTONTEXTSIZE]];
    
    for(UILabel * label in self.formLabels)
    {
        [label setFont:[UIFont worldpayPrimaryWithSize: LABELTEXTSIZE]];
    }
    
    [self validateCashbackAllowed];
    
    [self.transactionTypeDropDown setSelectionCallback:^(NSUInteger __unused index)
    {
        [self validateCashbackAllowed];
    }];
    
    self.widthConstraint.constant = WIDTHCONSTANT;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.swiper connectSwiperWithInputType:WPYSwiperInputTypeBluetooth];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.swiper disconnectSwiper];
}

- (void) validateCashbackAllowed
{
    [self.cashbackTextField setEnabled: [self cashbackAllowed]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) startTransaction
{
    if([self.cardPresentSegmented selectedSegmentIndex] == YESINDEX && [self.swiper connectionState] != WPYSwiperConnected)
    {
        [self.swiper connectSwiperWithInputType:WPYSwiperInputTypeBluetooth];
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"The swiper has not yet connected to your device, please connect device and try again." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if(!(self.amountTextField.text.doubleValue > 0))
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter a valid amount greater than 0." preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    WPYPaymentRequest * request;
    WPYEMVTransactionType transactionType = WPYEMVTransactionTypeGoods;
    
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
    
    request.amount = [NSDecimalNumber decimalNumberWithString:self.amountTextField.text];
    
    if(self.extendedInfoView.orderDate.text || self.extendedInfoView.purchaseOrder.text || self.extendedInfoView.gratuityAmount.text || self.extendedInfoView.serverName.text || self.extendedInfoView.notes.text)
    {
        WPYExtendedCardData * extendedData = [[WPYExtendedCardData alloc] init];
        
        extendedData.notes = self.extendedInfoView.notes.text;
        
        if(self.extendedInfoView.orderDate.text || self.extendedInfoView.purchaseOrder.text)
        {
            WPYLevelTwoData * level2 = [[WPYLevelTwoData alloc] init];
            
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss a"];
            
            level2.orderDate = [formatter dateFromString:self.extendedInfoView.orderDate.text];
            level2.purchaseOrderNumber = self.extendedInfoView.purchaseOrder.text;
            
            extendedData.levelTwoData = level2;
        }
        
        if(self.extendedInfoView.gratuityAmount || self.extendedInfoView.serverName)
        {
            WPYTenderServiceData * serviceData = [[WPYTenderServiceData alloc] init];
            
            serviceData.gratuityAmount = [NSDecimalNumber decimalNumberWithString:self.extendedInfoView.gratuityAmount.text];
            serviceData.server = self.extendedInfoView.serverName.text;
            
            extendedData.serviceData = serviceData;
        }
        
        request.extendedData = extendedData;
    }
    
    if([self cashbackAllowed] && self.cashbackTextField.text.doubleValue > 0)
    {
        request.amountOther = [NSDecimalNumber decimalNumberWithString:self.cashbackTextField.text];
        transactionType = WPYEMVTransactionTypeCashback;
    }
    
    if([self.cardPresentSegmented selectedSegmentIndex] == NOINDEX)
    {
        WPYManualTenderEntryViewController *tenderViewController = [[WPYManualTenderEntryViewController alloc] initWithDelegate:self tenderType:WPYManualTenderTypeCredit request:request];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tenderViewController];
        
        navigationController.modalPresentationStyle = tenderViewController.modalPresentationStyle;
        navigationController.navigationBar.translucent = NO;
        navigationController.navigationBar.barStyle = UIBarStyleDefault;
        [self presentViewController:navigationController animated:YES completion:nil];
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

#pragma mark - WPYManualTenderEntryDelegate

- (void)manualTenderEntryControllerDidCancelRequest:(WPYManualTenderEntryViewController *)controller
{
    NSLog(@"%@", @"Manual entry cancelled");
}

- (void)manualTenderEntryController:(WPYManualTenderEntryViewController *)controller didFailWithError:(NSError *)error
{
    NSLog(@"%@: %@", @"Manual entry failed with error", error);
}

- (void)manualTenderEntryControllerIsProcessingRequest:(WPYManualTenderEntryViewController *)controller
{
    NSLog(@"%@", @"Manual entry request is being processed");
}

- (void)manualTenderEntryController:(WPYManualTenderEntryViewController *)controller didFinishWithResponse:(WPYPaymentResponse *)tender
{
    NSLog(@"%@: %@", @"Manual entry request finished", tender);
}

@end
