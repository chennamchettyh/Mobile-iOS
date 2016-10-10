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
#import "UIColor+Worldpay.h"
#import "ExtendedInformationView.h"
#import "TransactionDetailViewController.h"
#import "SignatureViewController.h"
#import "LandscapeNavigationController.h"

#define YESINDEX 0
#define NOINDEX 1

#define AUTHORIZEINDEX 0
#define CHARGEINDEX 1
#define CREDITINDEX 2

#define LABELTEXTSIZE 17
#define TEXTFIELDSIZE 14
#define BUTTONTEXTSIZE 15

#define WIDTHCONSTANT 200
#define EXTENDEDHEIGHT 272
#define MAGICMARGIN 28

@interface TransactionViewController ()

@property (weak, nonatomic) IBOutlet DropDownTextField *transactionTypeDropDown;
@property (weak, nonatomic) IBOutlet UISegmentedControl *cardPresentSegmented;
@property (weak, nonatomic) IBOutlet UISegmentedControl *addToVaultSegmented;
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
@property (strong, nonatomic) UIAlertController * swiperAlert;
@property (weak, nonatomic) UITextField * activeTextField;
@property (strong, nonatomic) WPYTransactionResponse * lastResponse;

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
    
    self.amountTextField.delegate = self;
    self.cashbackTextField.delegate = self;
    
    [self.extendableInfoView setTitle:@"Extended Information"];

    ExtendedInformationView * infoView = [[ExtendedInformationView alloc] initWithFrame:CGRectMake(0, 0, self.extendableInfoView.frame.size.width+MAGICMARGIN, [ExtendedInformationView expectedHeight])];
    
    self.extendedInfoView = infoView;
    
    infoView.translatesAutoresizingMaskIntoConstraints = false;
    
    [infoView setTextFieldDelegate:self];
    
    [self.extendableInfoView setSecondaryViewInContainer:infoView];
    [self.extendableInfoView setSecondaryHeight: EXTENDEDHEIGHT];
    [self.extendableInfoView setHeightConstraint:self.extendableViewHeightConstraint];
    [self.extendableInfoView setHeightCallback:^(CGFloat height)
    {
        [self removeFocusFromTextField:nil];
        
        if(height < 0)
        {
            for(UITextField * textField in self.extendedInfoView.textFields)
            {
                textField.text = @"";
            }
        }
    }];
    
    [self.extendableInfoView addConstraint:[NSLayoutConstraint constraintWithItem:self.extendableInfoView.secondaryContainerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:infoView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self.extendableInfoView addConstraint:[NSLayoutConstraint constraintWithItem:self.extendableInfoView.secondaryContainerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:infoView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.extendableInfoView addConstraint:[NSLayoutConstraint constraintWithItem:self.extendableInfoView.secondaryContainerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:infoView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.extendableInfoView addConstraint:[NSLayoutConstraint constraintWithItem:self.extendableInfoView.secondaryContainerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:infoView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    UITapGestureRecognizer *recognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFocusFromTextField:)];
    [recognizer1 setNumberOfTapsRequired:1];
    [recognizer1 setNumberOfTouchesRequired:1];
    [self.scrollView addGestureRecognizer:recognizer1];
    
    UITapGestureRecognizer *recognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFocusFromTextField:)];
    [recognizer2 setNumberOfTapsRequired:1];
    [recognizer2 setNumberOfTouchesRequired:1];
    [self.extendedInfoView addGestureRecognizer:recognizer2];
    
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
        [self removeFocusFromTextField:nil];
        [self validateCashbackAllowed];
    }];
    
    self.widthConstraint.constant = WIDTHCONSTANT;
    
    self.startButton.backgroundColor = [UIColor worldpayMist];
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

- (IBAction)segmentedTouched:(id)sender
{
    [self removeFocusFromTextField:nil];
}

- (IBAction) startTransaction
{
    [self removeFocusFromTextField: nil];
    
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
    
    WPYExtendedCardData * extendedData = [[WPYExtendedCardData alloc] init];
    
    extendedData.addToVault = self.addToVaultSegmented.selectedSegmentIndex == YESINDEX;
    
    extendedData.notes = self.extendedInfoView.notes.text;
    
    if(![self.extendedInfoView.orderDate.text isEqualToString:@""] || ![self.extendedInfoView.purchaseOrder.text isEqualToString:@""])
    {
        WPYLevelTwoData * level2 = [[WPYLevelTwoData alloc] init];
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss a"];
        
        level2.orderDate = [formatter dateFromString:self.extendedInfoView.orderDate.text];
        level2.purchaseOrderNumber = self.extendedInfoView.purchaseOrder.text;
        
        extendedData.levelTwoData = level2;
    }
    
    if(self.extendedInfoView.gratuityAmount.text.doubleValue > 0 || ![self.extendedInfoView.serverName.text  isEqualToString: @""])
    {
        WPYTenderServiceData * serviceData = [[WPYTenderServiceData alloc] init];
        
        serviceData.gratuityAmount = [NSDecimalNumber decimalNumberWithString:self.extendedInfoView.gratuityAmount.text];
        serviceData.server = self.extendedInfoView.serverName.text;
        
        extendedData.serviceData = serviceData;
    }
    
    request.extendedData = extendedData;
    
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

- (void) displayAlert: (UIAlertController *) alert
{
    if(self.swiperAlert.viewIfLoaded != nil)
    {
        [self dismissViewControllerAnimated:true completion:^
         {
             [self presentViewController:alert animated:true completion:nil];
         }];
    }
    else
    {
        [self presentViewController:alert animated:true completion:nil];
    }
    
    self.swiperAlert = alert;
}

- (void) dismissSignature
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) captureSignature
{
    // TODO: Actually capture signature
    
    [self dismissViewControllerAnimated:YES completion:^
     {
         [self showTransactionDetails];
     }];
}

- (void) showTransactionDetails
{
    TransactionDetailViewController * detailController = [[TransactionDetailViewController alloc] initWithNibName:nil bundle:nil];
    
    detailController.transactionResponse = self.lastResponse;
    
    [self.navigationController pushViewController:detailController animated:YES];
}

- (void)  showSignatureScreen
{
    SignatureViewController * signatureVC = [[SignatureViewController alloc] initWithNibName:nil bundle:nil];
    
    UIBarButtonItem * cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(dismissSignature)];
    
    UIBarButtonItem * reset = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStyleDone target:signatureVC action:@selector(reset)];
    
    [signatureVC.navigationItem setLeftBarButtonItems:@[cancel,reset]];
    
    UIBarButtonItem * done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(captureSignature)];
    
    [signatureVC.navigationItem setRightBarButtonItem: done];
    
    LandscapeNavigationController * nav = [[LandscapeNavigationController alloc] initWithRootViewController:signatureVC];
    
    [self presentViewController:nav animated:YES completion:nil];
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
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Swiper device failed with an error." preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    
    [self displayAlert:alert];
}

- (void)swiper:(WPYSwiper *)swiper didFinishTransactionWithResponse:(WPYPaymentResponse *)response
{
    NSLog(@"%@: %@", @"Swiper finished transaction with response", [response jsonDictionary]);
    
    NSString * responseMessage;
    
    UIAlertAction * secondaryAction;
    
    NSString *transactionStatus = nil;
    
    BOOL approved = response.resultCode;
    
    NSString * signatureNeeded = @"";
    
    switch ((NSInteger)response.result)
    {
        case WPYTransactionResultApproved:
            transactionStatus = @"Approved";
            break;
        case WPYTransactionResultDeclined:
            transactionStatus = @"Declined";
            break;
        case WPYTransactionResultTerminated:
            transactionStatus = @"Terminated";
            break;
        case WPYTransactionResultCardBlocked:
            transactionStatus = @"Card Blocked";
            break;
        default:
            transactionStatus = @"Other - see logs";
            break;
    }
    
    if(response == nil)
    {
        responseMessage = [NSString stringWithFormat:@"Transaction Terminated: %ld", (long)response.result];
    }
    else
    {
        
        if(response.transaction != nil)
        {
            self.lastResponse = response.transaction;
            
            secondaryAction = [UIAlertAction actionWithTitle:@"View Details" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
            {
                [self showTransactionDetails];
            }];
            
            responseMessage = response.transaction.responseText;
        }
        
        if(response.resultCode == WPYTransactionResultReversal)
        {
            // TODO: In demo, this result had its own message, wondering if response.transaction.responseText is fine?
            
            if([self.swiper swiperCanDisplayText])
            {
                [self.swiper displayText:@"Decline - Reversal"];
            }
        }
        
        if(approved && response.receiptData.cardHolderVerificationMethod == WPYCVMethodSignature)
        {
            signatureNeeded = @"This card requires a signature.";
            
            secondaryAction = [UIAlertAction actionWithTitle:@"Sign" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
            {
                [self showSignatureScreen];
            }];
        }
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Prompt" message:[NSString stringWithFormat:@"Status: %@\r\nResponse:\r\n%@\r\n%@", transactionStatus, responseMessage, signatureNeeded] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    
    if(secondaryAction)
    {
        [alert addAction:secondaryAction];
    }
    
    [self displayAlert:alert];
}

- (void)swiper:(WPYSwiper *)swiper didFailRequest:(WPYPaymentRequest *)request withError:(NSError *)error
{
    NSLog(@"%@: %@", @"Swiper failed request with error", error);
}

- (void)swiper:(WPYSwiper *)swiper didRequestDevicePromptText:(WPYDevicePrompt)prompt completion:(void (^)(NSString *))completion
{
    NSString *defaultPrompt = nil;
    UIAlertAction * action;
    
    switch (prompt)
    {
        case WPYDevicePromptInsertCard:
            defaultPrompt = @"Insert Card";
            break;
        case WPYDevicePromptInsertOrSwipe:
            defaultPrompt = @"Insert or Swipe Card";
            break;
        case WPYDevicePromptChipCardSwiped:
            defaultPrompt = @"Chip Card Detected\nPlease Insert Card";
            break;
        case WPYDevicePromptSwipeError:
#ifdef ANYWHERE_NOMAD
            defaultPrompt = @"Card Swipe Error Please Try Again";
#else
            defaultPrompt = @"Card Swipe Error\nPlease Try Again";
#endif
            break;
        case WPYDevicePromptConfirmAmount:
#ifdef ANYWHERE_NOMAD
            defaultPrompt = [NSString stringWithFormat:@"Confirm Total: %@", self.amountTextField.text];
#else
        {
            NSNumberFormatter *currencyFormatter = [NSNumberFormatter new];
            currencyFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *number = [currencyFormatter numberFromString:self.amountTextField.text];
            currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
            defaultPrompt = [NSString stringWithFormat:@"Confirm Total: \n%@", [currencyFormatter stringFromNumber:number]];
        }
#endif
            break;
        case WPYDevicePromptNonICCard:
            defaultPrompt = @"Non IC Card Inserted";
            break;
        case WPYDevicePromptApproved:
            defaultPrompt = @"Transaction Approved\nPlease Remove Card";
            break;
        case WPYDevicePromptDeclined:
            defaultPrompt = @"Transaction Declined\nPlease Remove Card";
            break;
        case WPYDevicePromptCanceled:
            defaultPrompt = @"Transaction Canceled\nPlease Remove Card";
            action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            break;
        case WPYDevicePromptRetry:
#ifdef ANYWHERE_NOMAD
            defaultPrompt = @"Please remove and reinsert card";
#else
            defaultPrompt = @"Please remove and \nreinsert card";
#endif
            break;
        case WPYDevicePromptTransactionTimedOut:
            defaultPrompt = @"Transaction Timed Out";
            action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            break;
        case WPYDevicePromptNfcErrorCardInserted:
            defaultPrompt = @"Error. Card Inserted";
            break;
        case WPYDevicePromptNfcErrorCardSwiped:
            defaultPrompt = @"Error. Card Swipe Detected";
            break;
        case WPYDevicePromptNfcErrorUseICCard:
            defaultPrompt = @"Please Insert Card Instead";
            break;
        case WPYDevicePromptNfcErrorUseICCOrMSR:
            defaultPrompt = @"Please Swipe or Insert Card";
            break;
        case WPYDevicePromptNfcHardwareError:
            defaultPrompt = @"Contactless Hardware Error";
            action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            break;
        case WPYDevicePromptEmvReaderError:
            defaultPrompt = @"IC Card Reader Error";
            action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            break;
        case WPYDevicePromptEmvMSRFallback:
#ifdef ANYWHERE_NOMAD
            defaultPrompt = @"Card Not Supported Please swipe instead";
#else
            defaultPrompt = @"Card Not Supported\nPlease swipe instead";
#endif
            break;
        case WPYDevicePromptEmvInvalidCard:
#ifdef ANYWHERE_NOMAD
            defaultPrompt = @"Card Blocked. Use another card.";
#else
            defaultPrompt = @"Card Blocked\nUse another card";
#endif
            break;
        case WPYDevicePromptProcessing:
#ifdef ANYWHERE_NOMAD
            defaultPrompt = @"Processing. Do Not Remove Card.";
#else
            defaultPrompt = @"Processing. \nDo Not Remove Card.";
#endif
            break;
        case WPYDevicePromptEmvRemoveCard:
            defaultPrompt = @"Please Remove Card";
            break;
        case WPYDevicePromptTapCardAgain:
            defaultPrompt = @"Please Tap Card Again";
            break;
        case WPYDevicePromptReversal:
            defaultPrompt = @"Transaction Declined - Reversal";
            action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            break;
        case WPYDevicePromptCallBank:
            defaultPrompt = @"Declined - Please Call Bank";
            action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            break;
        case WPYDevicePromptNotAccepted:
            defaultPrompt = @"Not Accepted";
            break;
        case WPYDevicePromptRemoveCard:
            defaultPrompt = @"Remove Card";
            break;
        case WPYDevicePromptMultipleCardsDetected:
            defaultPrompt = @"Multiple Cards Detected";
            break;
        case WPYDevicePromptTapCard:
            defaultPrompt = @"Tap Card";
            break;
        default:
            defaultPrompt = nil;
            break;
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Prompt" message:defaultPrompt preferredStyle:UIAlertControllerStyleAlert];
    
    if(action)
    {
        [alert addAction: action];
    }
    
    [self displayAlert:alert];

    if(completion != nil)
    {
        completion(defaultPrompt);
    }
}

#pragma mark - WPYManualTenderEntryDelegate

- (void)manualTenderEntryControllerDidCancelRequest:(WPYManualTenderEntryViewController *)controller
{
    NSLog(@"%@", @"Manual entry cancelled");
}

- (void)manualTenderEntryController:(WPYManualTenderEntryViewController *)controller didFailWithError:(NSError *)error
{
    NSLog(@"%@: %@", @"Manual entry failed with error", error);
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Manual entry failed with an error" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    
    [self displayAlert:alert];
}

- (void)manualTenderEntryControllerIsProcessingRequest:(WPYManualTenderEntryViewController *)controller
{
    NSLog(@"%@", @"Manual entry request is being processed");
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Processing..." message:@"Manual entry request is being processed" preferredStyle:UIAlertControllerStyleAlert];
    
    [self displayAlert:alert];
}

- (void)manualTenderEntryController:(WPYManualTenderEntryViewController *)controller didFinishWithResponse:(WPYPaymentResponse *)tender
{
    NSLog(@"%@: %@", @"Manual entry request finished", tender);
    
    [self swiper:nil didFinishTransactionWithResponse:tender];
}

@end
