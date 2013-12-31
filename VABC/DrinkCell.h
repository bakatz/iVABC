//
//  DrinkCell.h
//  VABC
//
//  Created by Benjamin Katz on 11/12/13.
//  Copyright (c) 2013 Benjamin Katz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrinkCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *valueRatingLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *fullPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *abvLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *codeLabel;

@end