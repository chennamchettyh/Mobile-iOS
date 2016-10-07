//
//  TransactionDetailViewController.m
//  WorldPaySDKDemo
//
//  Created by Harsha Chennamchetty on 10/4/16.
//  Copyright © 2016 WorldPay. All rights reserved.
//

#import "TransactionDetailViewController.h"
#import "TransactionDetailCell.h"
#import "CardDataCell.h"
#import "BillingAddressCell.h"
#import "CustomerCell.h"


#define TRANSACTIONCELL @"TransactionCell"
#define CARDCELL @"CardCell"
#define BILLINGADDRESSCELL @"BillingAddress"
#define CUSTOMERCELL @"CustomerCell"

#define TRANSACTIONSECTION 0
#define CARDSECTION 1
#define BILLINGADDRESSSECTION 2
#define CUSTOMERSECTION 3


@interface TransactionDetailViewController()

@property (strong, nonatomic) WPYTransactionResponse *transactionResponse;

@end

@implementation TransactionDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier;
    UITableViewCell *cell;
    
    
    switch (indexPath.section) {
        case TRANSACTIONSECTION:
            simpleTableIdentifier = TRANSACTIONCELL;
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                cell = [[TransactionDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
                
            }
            
            [(TransactionDetailCell *)cell assignValues: self.transactionResponse];

            break;
        case CARDSECTION:
            simpleTableIdentifier = CARDCELL;
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                cell = [[CardDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            
            [(CardDataCell *)cell assignValues: self.transactionResponse];

            break;
        case BILLINGADDRESSSECTION:
            simpleTableIdentifier = BILLINGADDRESSCELL;
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                cell = [[BillingAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
                
            }
            
            [(BillingAddressCell *)cell assignValues: self.transactionResponse];


            break;
        case CUSTOMERSECTION:
            simpleTableIdentifier = CUSTOMERCELL;
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                cell = [[CustomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            
            [(CustomerCell *)cell assignValues: self.transactionResponse];

            break;
        default:
            break;
    }
    
    return cell;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
