//
//  CustomerCell.m
//  WorldPaySDKDemo
//
//  Created by Harsha Chennamchetty on 10/6/16.
//  Copyright © 2016 WorldPay. All rights reserved.
//

#import "CustomerCell.h"
#import "UIFont+Worldpay.h"


#define LABELTEXTSIZE 17


@interface CustomerCell()


@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *formLabels;

@property (weak, nonatomic) IBOutlet UILabel *customerIdValue;
@property (weak, nonatomic) IBOutlet UILabel *customerEmailValue;

@end

@implementation CustomerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    for(UILabel * label in self.formLabels)
    {
        [label setFont:[UIFont worldpayPrimaryWithSize: LABELTEXTSIZE]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)assignValues: (WPYTransactionResponse *)response {
    
    self.customerIdValue.text = response.customerId;
    self.customerEmailValue.text = response.email;
    
}


@end
