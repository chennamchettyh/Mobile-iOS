//
//  MasterViewController.m
//  WorldPaySDKDemo
//
//  Copyright (c) 2015 WorldPay. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController () <WPYSwiperDelegate, WPYManualTenderEntryDelegate>
@property (nonatomic, strong) WPYSwiper* swiper;
@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self generateCommandList];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    self.swiper = [[WorldpayAPI instance] swiperWithDelegate:self];

    WPYAuthTokenRequest *authTokenRequest = [[WPYAuthTokenRequest alloc] init];

    authTokenRequest.secureNetId = @"8005860";
    authTokenRequest.secureNetKey = @"0UvyZmcISlcj";
    authTokenRequest.applicationId = @"applicationId";
    authTokenRequest.terminalId = @"445";
    authTokenRequest.terminalVendor = @"4554";

    [[WorldpayAPI instance] generateAuthToken:authTokenRequest withCompletion:^(NSString *result, NSError *error)
     {
         if(error)
         {
             NSLog(@"Error generating AUTH Token: %@", error);
         }
         else
         {
             [self transactionSearch];
         }
     }];


//    WPYManualTenderEntryViewController *tenderViewController = [[WPYManualTenderEntryViewController alloc] initWithDelegate:self tenderType:WPYManualTenderTypeCredit];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tenderViewController];
//
//    navigationController.modalPresentationStyle = tenderViewController.modalPresentationStyle;
//    navigationController.navigationBar.translucent = NO;
//    navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    [self presentViewController:navigationController animated:YES completion:nil];

#ifdef ANYWHERE_NOMAD
    [self.swiper connectSwiperWithInputType:WPYSwiperInputTypeAudio];
#else
    [self.swiper connectSwiperWithInputType:WPYSwiperInputTypeBluetooth];
#endif

    NSLog(@"Audio: %@  Bluetooth: %@", self.swiper.isAudioJackSupported ? @"YES" : @"NO", self.swiper.isBluetoothSupported ? @"YES" : @"NO");
}

- (void)transactionSearch
{
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    //correcting format to include seconds and decimal place
    NSString *input = @"2014-02-07T03:10:59.434Z";
    dateFormat.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    // Always use this locale when parsing fixed format date strings
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormat.locale = posix;

    WPYTransactionSearch *search = [[WPYTransactionSearch alloc] init];


    search.startDate = [dateFormat dateFromString:input];
    search.endDate = [NSDate date];

    [[WorldpayAPI instance] searchTransactions:search withCompletion:^(NSArray <WPYTransactionResponse *> *transactions, NSError *error) {
        NSLog(@"Response: %@ Error: %@", transactions, error);
    }];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self manualEntry];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)generateCommandList
{
    if(self.objects == nil)
    {
        self.objects = [NSMutableArray array];
    }

    for (NSInteger index = 0; index < CommandByRowEndSentinel; index++)
    {
        NSString *rowText = [self rowDescription:index];

        if(rowText != nil)
        {
            [self.objects addObject:rowText];
        }
    }
}

- (void)manualTenderEntryController:(WPYManualTenderEntryViewController *)controller didFinishWithResponse:(WPYPaymentResponse *)tender
{
    if ([tender isKindOfClass:[WPYPaymentResponse class]])
    {
        NSLog(@"Response: %@", tender);
    }
    else
    {
        NSLog(@"Response: %@", tender);
    }
    
    NSLog(@"Done Implementing manual Entry code.");
}


- (void)manualTenderEntryController:(WPYManualTenderEntryViewController *)controller didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
    
}


-(void)manualTenderEntryControllerIsProcessingRequest:(WPYManualTenderEntryViewController *)controller
{
    NSLog(@"Manual Entry is being processed.");
}


- (void)manualEntry
{
    NSLog(@"This is ManualEntryCard View");
    
    WPYPaymentRequest *request = [[WPYPaymentAuthorize alloc] init];
    
    request.amount = [NSDecimalNumber decimalNumberWithString:@"1.00"];
    
    
    request.extendedData = [[WPYExtendedCardData alloc] init];
    
    request.extendedData.terminalData = [[WPYTerminalInfo alloc] init];
    
    request.extendedData.terminalData.terminalId = @"12345";
    request.extendedData.terminalData.pOSTerminalInputCapabilityInd = @"5";
    
    
    WPYManualTenderEntryViewController *tenderViewController = [[WPYManualTenderEntryViewController alloc] initWithDelegate:self tenderType:WPYManualTenderTypeCredit request:request
                                                                ];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tenderViewController];
    
    navigationController.modalPresentationStyle = tenderViewController.modalPresentationStyle;
    navigationController.navigationBar.translucent = NO;
    navigationController.navigationBar.barStyle = UIBarStyleDefault;
    [self presentViewController:navigationController animated:YES completion:nil];
    
    NSLog(@"The ManulTenderViewController is being implemented here");
}

- (NSString *)rowDescription:(NSInteger)row
{
    NSString *rowDescription = nil;

    switch (row)
    {
        case GenerateAuthToken:
            rowDescription = @"Generate Auth Token";
            break;
        case GetCurrentBatch:
            rowDescription = @"Get Current Batch";
            break;
        case CloseCurrentBatch:
            rowDescription = @"Close Current Batch";
            break;
        case GetCustomerDataByID:
            rowDescription = @"Get Customer Data by ID";
            break;
        case CreateCustomer:
            rowDescription = @"Create Customer";
            break;
        case UpdateCustomer:
            rowDescription = @"Update Customer";
            break;
        case GetGiftCardbyID:
            rowDescription = @"Get Gift Card by ID";
            break;
        case UpdateGiftCard:
            rowDescription = @"Update Gift Card";
            break;
        case CreateGiftCard:
            rowDescription = @"Create Gift Card";
            break;
        case DeletePaymentMethod:
            rowDescription = @"Delete Payment Method";
            break;
        case GetPaymentMethodByID:
            rowDescription = @"Get Payment Method by ID";
            break;
        case UpdatePaymentMethod:
            rowDescription = @"Update Payment Method";
            break;
        case CreatePaymentMethod:
            rowDescription = @"Create Payment Method";
            break;
        case AuthorizePayment:
            rowDescription = @"Authorize Payment";
            break;
        case CapturePayment:
            rowDescription = @"Capture Payment";
            break;
        case ChargePayment:
            rowDescription = @"Charge Payment";
            break;
        case VoidPayment:
            rowDescription = @"Void Payment";
            break;
        case RefundPayment:
            rowDescription = @"Refund Payment";
            break;
        case CreditPayment:
            rowDescription = @"Credit Payment";
            break;
        case GetTransactionDetailsByID:
            rowDescription = @"Get Transaction Details by ID";
            break;
        case SearchTransactions:
            rowDescription = @"Search Transactions";
            break;
        case GetTransactionBatch:
            rowDescription = @"Get Transaction Batch";
            break;
        default:
            rowDescription = nil;
            break;
    }

    return rowDescription;
}

- (WPYDomainObject *)commandClassForRow:(NSInteger)row
{
    Class domainClass = nil;
    switch (row)
    {
        case GenerateAuthToken:
            domainClass = [WPYAuthTokenRequest class];
            break;
        case GetCurrentBatch:
            domainClass = nil;
            break;
        case CloseCurrentBatch:
            domainClass = nil;
            break;
        case GetCustomerDataByID:
            domainClass = nil;
            break;
        case CreateCustomer:
            domainClass = [WPYCustomerData class];
            break;
        case UpdateCustomer:
            domainClass = [WPYCustomerData class];
            break;
        case GetGiftCardbyID:
            domainClass = nil;
            break;
        case UpdateGiftCard:
            domainClass = nil;
            break;
        case CreateGiftCard:
            domainClass = nil;
            break;
        case DeletePaymentMethod:
            domainClass = [WPYPaymentMethod class];
            break;
        case GetPaymentMethodByID:
            domainClass = nil;
            break;
        case UpdatePaymentMethod:
            domainClass = [WPYPaymentMethodRequest class];
            break;
        case CreatePaymentMethod:
            domainClass = [WPYPaymentMethodRequest class];
            break;
        case AuthorizePayment:
            domainClass = [WPYPaymentAuthorize class];
            break;
        case CapturePayment:
            domainClass = [WPYPaymentCapture class];
            break;
        case ChargePayment:
            domainClass = [WPYPaymentCharge class];
            break;
        case VoidPayment:
            domainClass = [WPYPaymentVoid class];
            break;
        case RefundPayment:
            domainClass = [WPYPaymentRefund class];
            break;
        case CreditPayment:
            domainClass = [WPYPaymentCredit class];
            break;
        case GetTransactionDetailsByID:
            domainClass = nil;
            break;
        case SearchTransactions:
            domainClass = nil;
            break;
        case GetTransactionBatch:
            domainClass = nil;
            break;
        default:
            domainClass = nil;
            break;
    }

    if(domainClass != nil)
    {
        return [[domainClass alloc] init];
    }

    return nil;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.domainObject = [self commandClassForRow:indexPath.row];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = self.objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

#pragma mark WPYSwiperDelegate
- (void) swiper:(WPYSwiper *)swiper didReceiveCardData:(WPYTenderedCard *)cardData
{
    NSLog(@"Card received: %@", [cardData jsonDictionary]);

    if(cardData.iccCardSwiped)
    {
        if([self.swiper swiperCanDisplayText])
        {
            [self.swiper displayText:@"Please Insert Card"];
        }
    }
    else
    {
        WPYPaymentAuthorize *request = [[WPYPaymentAuthorize alloc] init];

        request.amount = [NSDecimalNumber decimalNumberWithString:@"1.0"];
        request.card = cardData;

        [[WorldpayAPI instance] paymentAuthorize:request withCompletion:^(WPYPaymentResponse *response, NSError *error) {
            NSLog(@"Response: %@ Error: %@", [response jsonDictionary], error);
        }];
    }
}
- (void) didConnectSwiper:(WPYSwiper *)swiper
{
    self.swiper = swiper;

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

    // The Miura driver does not discover devices like the Anywhere Commerce driver.
    // It uses a known list of paired devices and returns the device list almost instantly -
    // before the application finishes loading in this case.
#ifdef ANYWHERE_NOMAD
    [self presentViewController:alert animated:YES completion:nil];
#else
    [self performSelector:@selector(miuraDelayedAlertView:) withObject:alert afterDelay:3];
#endif

}

- (void)miuraDelayedAlertView:(UIAlertController *)controller
{
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)swiper:(WPYSwiper *)swiper didFailRequest:(WPYPaymentRequest *)request withError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Transaction Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

    [alert show];
}

#pragma mark WPYManualTenderEntryDelegate

- (void)manualTenderEntryViewController:(WPYManualTenderEntryViewController *)controller didFinishWithTender:(WPYTender *)tender
{
    if ([tender isKindOfClass:[WPYTenderedCard class]])
    {
        WPYPaymentAuthorize *request = [[WPYPaymentAuthorize alloc] init];

        request.amount = [NSDecimalNumber decimalNumberWithString:@"1.0"];
        request.card = (WPYTenderedCard *)tender;

        [[WorldpayAPI instance] paymentAuthorize:request withCompletion:^(WPYPaymentResponse *response, NSError *error) {
            NSLog(@"Response: %@ Error: %@", [response jsonDictionary], error);
        }];
    }
    else
    {
        WPYPaymentCharge *request = [[WPYPaymentCharge alloc] init];

        request.amount = [[NSDecimalNumber alloc] initWithString:@"1.0"];
        request.check = (WPYTenderedCheck *)tender;

        [[WorldpayAPI instance] paymentCharge:request withCompletion:^(WPYPaymentResponse *response, NSError *error) {
            NSLog(@"Response: %@ Error: %@", response, error);
        }];
    }
}

- (void)manualTenderEntryControllerDidCancelRequest:(WPYManualTenderEntryViewController *)controller
{
    NSLog(@"Did Cancel");
}
@end
