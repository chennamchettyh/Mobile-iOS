//
//  DetailViewController.m
//  WorldPaySDKDemo
//
//  Copyright (c) 2015 WorldPay. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <WPYSwiperDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) WPYSwiper *swiper;
@property (strong, nonatomic) IBOutlet UITextField *amount;
@property (nonatomic, strong) NSArray *transactionTypes;
@property (strong, nonatomic) IBOutlet UITextField *cashBack;
@property (strong, nonatomic) IBOutlet UITextField *transactionType;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) Class selectedClass;
@property (strong, nonatomic) IBOutlet UISwitch *bluetoothSwitch;
@property (strong, nonatomic) IBOutlet UILabel *bluetoothLabel;
@property (nonatomic) BOOL transactionPending;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;

        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];

    self.transactionTypes = @[[WPYPaymentAuthorize class], [WPYPaymentCharge class], [WPYPaymentCredit class], [WPYPaymentVoid class]];

    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;

    self.transactionType.inputView = self.pickerView;
    self.selectedClass = self.transactionTypes[0];
    self.transactionType.text = NSStringFromClass(self.selectedClass);
    [self.pickerView selectedRowInComponent:0];

    self.cashBack.text = @"0.00";

    self.swiper = [[WorldpayAPI instance] swiperWithDelegate:self];

    if(!self.swiper.audioJackSupported)
    {
        self.bluetoothSwitch.hidden = YES;
        self.bluetoothLabel.hidden = YES;
    }
    else
    {
        [self.bluetoothSwitch setOn:self.swiper.deviceInputType == WPYSwiperInputTypeBluetooth ? YES : NO animated:NO];
    }

    self.cashBack.delegate = self;

    self.amount.delegate = self;
    self.transactionPending = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startTransaction:(id)sender
{
    self.swiper = [[WorldpayAPI instance] swiperWithDelegate:self];

    if(self.swiper.connectionState != WPYSwiperConnected)
    {
        if(self.swiper.isAudioJackSupported && self.bluetoothSwitch.isOn == NO)
        {
            [self.swiper connectSwiperWithInputType:WPYSwiperInputTypeAudio];
        }
        else
        {
            [self.swiper connectSwiperWithInputType:WPYSwiperInputTypeBluetooth];
        }
    }
    else
    {
        [self beginTransaction];
    }
}

- (IBAction)switchTriggered:(id)sender
{
    if(self.bluetoothSwitch.isOn)
    {
        [self.swiper disconnectSwiper];
        [self.swiper connectSwiperWithInputType:WPYSwiperInputTypeBluetooth];
    }
    else
    {
        [self.swiper disconnectSwiper];
        [self.swiper connectSwiperWithInputType:WPYSwiperInputTypeAudio];
    }
}
#pragma mark WPYSwiperDelegate
- (void) swiper:(WPYSwiper *)swiper didFailWithError:(NSString *)error
{
    self.transactionPending = NO;
}

- (void) swiper:(WPYSwiper *)swiper didReceiveCardData:(WPYTenderedCard *)cardData
{
    NSLog(@"Card received: %@", [cardData jsonDictionary]);

    WPYPaymentRequest *request = [[self.selectedClass alloc] init];

    request.amount = [NSDecimalNumber decimalNumberWithString:self.amount.text];
    request.card = cardData;

    request.extendedData = [[WPYExtendedCardData alloc] init];

    request.extendedData.terminalData = [[WPYTerminalInfo alloc] init];

    request.extendedData.terminalData.terminalId = @"12345";
    request.extendedData.terminalData.pOSTerminalInputCapabilityInd = @"5";
    request.extendedData.terminalData.kernelVersionNo = [self.swiper getFirmwareVersion];

#ifdef ANYWHERE_NOMAD
    NSDecimalNumber *cashBack = [NSDecimalNumber decimalNumberWithString:self.cashBack.text];

    if(cashBack.doubleValue > 0.0)
    {
        request.amount = [request.amount decimalNumberByAdding:cashBack];
    }

    request.amountOther = cashBack;
#endif

    if([self.swiper swiperCanDisplayText])
    {
        [self.swiper displayText:@"Processing\nPlease Wait"];
    }

    PaymentCompletion completion = ^(WPYPaymentResponse * response, NSError *error)
    {
        NSLog(@"Response: %@ Error: %@", [response jsonDictionary], error);
        if(error)
        {
            self.detailDescriptionLabel.text = error.localizedDescription;

            if([self.swiper swiperCanDisplayText])
            {
                [self.swiper displayText:error.localizedDescription];
            }
        }
        else
        {
            self.detailDescriptionLabel.text = response.transaction.responseText;

            if([self.swiper swiperCanDisplayText])
            {
                [self.swiper displayText:response.transaction.responseText];
            }

            [self.swiper performSelector:@selector(swiperClearDisplay) withObject:nil afterDelay:15.0];
        }
    };

    if([request isKindOfClass:[WPYPaymentAuthorize class]])
    {
        [[WorldpayAPI instance] paymentAuthorize:(WPYPaymentAuthorize *)request withCompletion:completion];
    }
    else if([request isKindOfClass:[WPYPaymentCharge class]])
    {
        [[WorldpayAPI instance] paymentCharge:(WPYPaymentCharge *)request withCompletion:completion];
    }
    else if([request isKindOfClass:[WPYPaymentCredit class]])
    {
        [[WorldpayAPI instance] paymentCredit:(WPYPaymentCredit *)request withCompletion:completion];
    }

    self.transactionPending = NO;
}
- (void) didConnectSwiper:(WPYSwiper *)swiper
{
    self.swiper = swiper;
    NSLog(@"Did connect");
}

- (void)beginTransaction
{
    self.transactionPending = YES;
    WPYPaymentRequest *request = [[self.selectedClass alloc] init];

    request.amount = [NSDecimalNumber decimalNumberWithString:self.amount.text];

//    request.extendedData = [[WPYExtendedCardData alloc] init];
//    request.extendedData.terminalData = [[WPYTerminalInfo alloc] init];
//
//    request.extendedData.terminalData.terminalId = @"EricTest";

    // The Anywhere Commerce device requires cash back info prior to the start of the transaction.
    // The Miura driver will check to see if cash back is even available based on the Application
    // Usaged Control data stored on the card and will prompt the user to enter the cash back amount
    // if applicable.
#ifdef ANYWHERE_NOMAD
    NSDecimalNumber *cashBack = [NSDecimalNumber decimalNumberWithString:self.cashBack.text];

    if([cashBack isEqualToNumber:[NSDecimalNumber notANumber]])
    {
        cashBack = [NSDecimalNumber decimalNumberWithString:@"0"];
    }

    request.amountOther = cashBack;

    if(cashBack.doubleValue > 0.0)
    {
        request.amount = [request.amount decimalNumberByAdding:cashBack];
        [self.swiper beginEMVTransactionWithRequest:request transactionType:WPYEMVTransactionTypeCashback];

        return;
    }
#endif
    WPYEMVTransactionType type = WPYEMVTransactionTypeGoods;

    if([request isKindOfClass:[WPYPaymentCredit class]])
    {
        type = WPYEMVTransactionTypeRefund;
    }

    [self.swiper beginEMVTransactionWithRequest:request transactionType:type];
}
- (void) didDisconnectSwiper:(WPYSwiper *)swiper
{
    NSLog(@"Did disconnect");
}
- (void) didFailToConnectSwiper:(WPYSwiper *)swiper
{
    NSLog(@"Connect failed");
}

- (void) willConnectSwiper:(WPYSwiper *)swiper
{
    NSLog(@"Will Connect");
}

- (void)swiper:(WPYSwiper *)swiper didFailRequest:(WPYPaymentRequest *)request withError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Transaction Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

    [alert show];

    self.transactionPending = NO;
}

- (void)swiper:(WPYSwiper *)swiper didRequestSelectEMVApplication:(NSArray *)applications
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Application" message:@"" preferredStyle:UIAlertControllerStyleAlert];

    for (NSString *application in applications)
    {
        [alert addAction:[UIAlertAction actionWithTitle:application style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.swiper selectEMVCardApplication:(NSInteger)[applications indexOfObject:application]];
        }]];
    }

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)selectDevice:(NSArray *)devices forSwiper:(WPYSwiper *)swiper completion:(void (^)(int))completion
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Device" message:@"" preferredStyle:UIAlertControllerStyleAlert];

    for (NSString *device in devices)
    {
        [alert addAction:[UIAlertAction actionWithTitle:device style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           completion([devices indexOfObject:device]);
        }]];
    }

    [self presentViewController:alert animated:YES completion:nil];
}

- (void) swiper:(WPYSwiper *)swiper didFinishTransactionWithResponse:(WPYPaymentResponse *)response
{
    NSLog(@"Result: %ld Response: %@", (long)response.result, [response jsonDictionary]);

    if(response.result == WPYTransactionResultReversal)
    {
        self.detailDescriptionLabel.text = @"Decline - Reversal";

        if([self.swiper swiperCanDisplayText])
        {
            [self.swiper displayText:@"Decline - Reversal"];
        }
    }
    else if(response != nil && response.transaction != nil)
    {
        self.detailDescriptionLabel.text = response.transaction.responseText;
    }
    else if(response == nil)
    {
        self.detailDescriptionLabel.text = [NSString stringWithFormat:@"Transaction Terminated: %ld", (long)response.result];
    }

    NSString *transactionStatus = nil;

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

    if(response.receiptData.cardHolderVerificationMethod == WPYCVMethodSignature)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signature" message:[NSString stringWithFormat:@"This card requires a signature. Status: %@ Receipt Data: %@", transactionStatus, [response.receiptData jsonDictionary]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signature" message:[NSString stringWithFormat:@"This card DOES NOT require signature. Status: %@ Receipt Data: %@", transactionStatus, [response.receiptData jsonDictionary]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

        [alert show];
    }

    self.transactionPending = NO;
}

- (void)swiperDidRequestFinalConfirmation:(WPYSwiper *)swiper
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [swiper confirmTransaction:YES];
    });
}

- (void)swiper:(WPYSwiper *)swiper didRequestDevicePromptText:(WPYDevicePrompt)prompt completion:(void (^)(NSString *))completion
{
    NSString *defaultPrompt = nil;

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
            defaultPrompt = [NSString stringWithFormat:@"Confirm Total: %@", self.amount.text];
#else
        {
            NSNumberFormatter *currencyFormatter = [NSNumberFormatter new];
            currencyFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *number = [currencyFormatter numberFromString:self.amount.text];
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
            break;
        case WPYDevicePromptEmvReaderError:
            defaultPrompt = @"IC Card Reader Error";
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
            break;
        case WPYDevicePromptCallBank:
            defaultPrompt = @"Declined - Please Call Bank";
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

    self.detailDescriptionLabel.text =  defaultPrompt;

    if(completion != nil)
    {
        completion(defaultPrompt);
    }
}

- (void)swiper:(WPYSwiper *)swiper didRequestAccountTypeSelection:(NSArray<NSNumber *> *)accountTypes
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Card Type" message:@"" preferredStyle:UIAlertControllerStyleAlert];

    for (NSNumber *accountType in accountTypes)
    {
        NSString *title = nil;

        switch (accountType.unsignedIntegerValue)
        {
            case WPYCardAccountTypeCredit:
                title = @"Credit";
                break;
            case WPYCardAccountTypeDebit:
                title = @"Debit";
                break;
            default:
                title = @"Unknown";
                break;
        }
        [alert addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.swiper selectAccountType:accountType.unsignedIntegerValue];
        }]];
    }

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)swiper:(WPYSwiper *)swiper didReceiveCardEvent:(WPYCardEvent)eventType
{
    if(eventType == WPYCardEventRemoved && self.transactionPending == NO)
    {
        [self.swiper swiperClearDisplay];
    }

    NSLog(@"Received Card Event: %lu", (unsigned long)eventType);
}


-(void)dismissKeyboard
{
    [self.view endEditing:YES];
    self.navigationItem.rightBarButtonItem = nil;
}


#pragma mark UITextField
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard)];

    self.navigationItem.rightBarButtonItem = doneButton;
}

#pragma mark UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.transactionTypes.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Class class = self.transactionTypes[row];

    return NSStringFromClass(class);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedClass = self.transactionTypes[row];
    self.transactionType.text = NSStringFromClass(self.selectedClass);
    [self.transactionType resignFirstResponder];
}
@end
