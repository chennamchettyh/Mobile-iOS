//
//  BatchTransactionTableViewCell.m
//  WorldPaySDKDemo
//
//  Created by Harsha Chennamchetty on 10/12/16.
//  Copyright © 2016 WorldPay. All rights reserved.
//

#import "BatchTransactionTableViewCell.h"

@interface BatchTransactionTableViewCell ()

@property (strong, nonatomic) WPYTransactionResponse * transaction;
@property (weak, nonatomic) IBOutlet UILabel *transactionIdLabel;

@end

@implementation BatchTransactionTableViewCell

-(instancetype)initWithTransaction: (WPYTransactionResponse *) transaction
{
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"BatchTransactionTableViewCell" owner:self options:nil];
    
    if((self = (BatchTransactionTableViewCell *)[nib objectAtIndex:0]))
    {
        self.transaction = transaction;
        [self configureCell];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCell
{
    self.transactionIdLabel.text = self.transaction.transactionId;
}

@end
