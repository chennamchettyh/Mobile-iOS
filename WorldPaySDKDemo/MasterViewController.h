//
//  MasterViewController.h
//  WorldPaySDKDemo
//
//  Copyright (c) 2015 WorldPay. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifdef ANYWHERE_NOMAD
#import <WorldPaySDK_AC/WorldPaySDK.h>
#else
#import <WorldPaySDK_Miura/WorldPaySDK.h>
#endif

typedef NS_ENUM(NSInteger, CommandByRow)
{
    GenerateAuthToken = 0,
    GetCurrentBatch,
    CloseCurrentBatch,
    GetCustomerDataByID,
    CreateCustomer,
    UpdateCustomer,
    GetGiftCardbyID,
    UpdateGiftCard,
    CreateGiftCard,
    DeletePaymentMethod,
    GetPaymentMethodByID,
    UpdatePaymentMethod,
    CreatePaymentMethod,
    AuthorizePayment,
    CapturePayment,
    ChargePayment,
    VoidPayment,
    RefundPayment,
    CreditPayment,
    GetTransactionDetailsByID,
    SearchTransactions,
    GetTransactionBatch,
    CommandByRowEndSentinel
};

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;


@end
