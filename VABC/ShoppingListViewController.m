//
//  ShoppingListViewController.m
//  VABC
//
//  Created by Benjamin Katz on 3/7/14.
//  Copyright (c) 2014 Benjamin Katz. All rights reserved.
//

#import "ShoppingListViewController.h"
#import "DrinkCell.h"
#import "AppDelegate.h"

@interface ShoppingListViewController ()
@property AppDelegate *appDelegate;
@property NSDictionary *selectedDrink;
@property NSIndexPath *selectedDrinkIdx;
@end

@implementation ShoppingListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self updateTitle];
}

- (void)updateTitle
{
    self.navigationItem.title = [NSString stringWithFormat:@"Shopping List ($%.2f)", self.appDelegate.totalPrice];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self tableView] reloadData];
    [self updateTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self appDelegate] shoppingListArray] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    DrinkCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[DrinkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *cellData = [[[self appDelegate] shoppingListArray] objectAtIndex:[indexPath item]];
    cell.nameLabel.text = [cellData objectForKey:@"name"];
    cell.categoryLabel.text = [[cellData objectForKey:@"category"] capitalizedString];
    cell.priceLabel.text = [NSString stringWithFormat:@"$%@", [cellData objectForKey:@"price"]];
    
    float fullPrice = [[cellData objectForKey:@"full_price"] floatValue];
    float price = [[cellData objectForKey:@"price"] floatValue];
    
    NSInteger age = [[cellData objectForKey:@"age"] integerValue];
    
    if(age > 0) {
        cell.ageLabel.text = [NSString stringWithFormat:@"Aged %ld years", (long)age];
    } else {
        cell.ageLabel.text = @"Not aged";
    }
    
    // if we have a sale item, show the full price with a strikethrough effect.
    if(price < fullPrice) {
        
        NSDictionary *strikethroughAttributes = @{
                                                  NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                                  };
        
        NSString *formattedFullPrice = [NSString stringWithFormat:@"$%@", [cellData objectForKey:@"full_price"]];
        
        NSAttributedString *strikethroughAttrText = [[NSAttributedString alloc] initWithString:formattedFullPrice attributes:strikethroughAttributes];
        cell.fullPriceLabel.text = formattedFullPrice;
        cell.fullPriceLabel.attributedText = strikethroughAttrText;
        cell.fullPriceLabel.hidden = NO;
    } else {
        cell.fullPriceLabel.hidden = YES;
    }
    
    long formattedSize = lroundf([[cellData objectForKey:@"num_ml"] floatValue]);
    
    if(formattedSize == 1750.0F) {
        cell.sizeLabel.text = @"Handle";
    } else if (formattedSize == 750.0F) {
        cell.sizeLabel.text = @"Fifth";
    } else if (formattedSize == 1000.0F) {
        cell.sizeLabel.text = @"1L";
    } else if (formattedSize == 2000.0F) {
        cell.sizeLabel.text = @"2L";
    } else {
        cell.sizeLabel.text = [NSString stringWithFormat:@"%ldmL", formattedSize];
    }
    
    NSString* formattedABV = [NSString stringWithFormat:@"%ld%% ABV", lroundf([[cellData objectForKey:@"abv_pct"] floatValue])];
    cell.abvLabel.text = formattedABV;
    
    NSString* formattedValueRating = [NSString stringWithFormat:@"%ld", lroundf([[cellData objectForKey:@"value_score"] floatValue])];
    cell.valueRatingLabel.text = formattedValueRating;
    
    long reviewScore = lroundf([[cellData objectForKey:@"review_score"] floatValue]);
    NSString* formattedReview = nil;
    if(reviewScore == 0) {
        cell.reviewLabel.font = [UIFont systemFontOfSize:13];
        formattedReview = @"N/A";
    } else {
        cell.reviewLabel.font = [UIFont systemFontOfSize:18];
        formattedReview = [NSString stringWithFormat:@"%ld", reviewScore];
    }
    
    cell.reviewLabel.text = formattedReview;
    cell.codeLabel.text = [NSString stringWithFormat:@"#%@", [cellData objectForKey:@"code"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *cellData = [[[self appDelegate] shoppingListArray] objectAtIndex:[indexPath item]];
    NSString *drinkNameMessage = [NSString stringWithFormat:@"The full name of the drink you selected is \"%@.\" Remove this drink from the shopping list?",[cellData objectForKey:@"name"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Remove From Shopping List"
                                                    message:drinkNameMessage
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    self.selectedDrink = cellData;
    self.selectedDrinkIdx = indexPath;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Yes"]) {
        NSLog(@"Yes button clicked, REMOVE");
        [[[self appDelegate] shoppingListArray] removeObjectAtIndex:[self.selectedDrinkIdx item]];
        [[self tableView] deleteRowsAtIndexPaths:@[self.selectedDrinkIdx] withRowAnimation:UITableViewRowAnimationAutomatic];
        self.appDelegate.totalPrice -= [[[self selectedDrink] objectForKey:@"price"] doubleValue];
        [self updateTitle];
        self.selectedDrinkIdx = nil;
    }
}


@end
