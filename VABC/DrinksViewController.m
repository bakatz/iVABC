//
//  DrinksViewController.m
//  VABC
//
//  Created by Benjamin Katz on 11/11/13.
//  Copyright (c) 2013 Benjamin Katz. All rights reserved.
//

#import "DrinksViewController.h"
#import "FilterDrinksViewController.h"
#import "DrinkCell.h"

@interface DrinksViewController ()
@property NSArray *drinksArray;
@property NSMutableData *responseData;
@property bool replaceDrinks;
@property NSInteger startRow;
@property NSInteger lastRequestedRow;
@end

@implementation DrinksViewController

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
    
    self.tblView.delegate = self;
    self.tblView.dataSource = self;
    
    self.replaceDrinks = true;
    self.lastRequestedRow = -1;
    self.startRow = 0;
    
    self.sortVal = @"value_score";
    self.numMLVal = @"";
    self.categoryVal = @"";
    self.nameVal = @"";
    // http://bakatz.com/scripts/get_vabc_data.php?type=drinks&limit=100&sort=value_score&num_ml=&category=&name=

    self.responseData = [NSMutableData data];
    [self requestDrinksData:@"value_score":nil:nil:nil];
	// Do any additional setup after loading the view.
}

- (void)requestDrinksData:(NSString *)sort :(NSString *)numML :(NSString *)category :(NSString *)name;
{
    self.title = @"VABC Drinks - Loading ...";
    
    if(sort != nil) {
        self.sortVal = sort;
    }
    
    if(numML != nil) {
        self.numMLVal = numML;
    }
    
    if(category != nil) {
        self.categoryVal = category;
    }
    
    if(name != nil) {
        self.nameVal = name;
    }
    
    NSString *urlParams = [NSString stringWithFormat:@"type=drinks&limit=100&start=%ld&sort=%@&num_ml=%@&category=%@&name=%@", self.startRow, self.sortVal, self.numMLVal, self.categoryVal, self.nameVal];
    
    NSString *urlToSend = [NSString stringWithFormat:@"%@%@", @"http://bakatz.com/scripts/get_vabc_data.php?", [urlParams stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"requestDrinksData - sending request: %@", urlToSend);
    NSURLRequest *request = [NSURLRequest requestWithURL:
    [NSURL URLWithString:urlToSend]];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self drinksArray] count];
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
    
    NSDictionary *cellData = [[self drinksArray] objectAtIndex:[indexPath item]];
    cell.nameLabel.text = [cellData objectForKey:@"name"];
    cell.categoryLabel.text = [[cellData objectForKey:@"category"] capitalizedString];
    
    //cell.categoryShortLabel.text = [cell.categoryLabel.text substringToIndex:2];
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
    
    
    cell.sizeLabel.text = [NSString stringWithFormat:@"%ld mL", lroundf([[cellData objectForKey:@"num_ml"] floatValue])];
    
    NSString* formattedABV = [NSString stringWithFormat:@"%ld%% ABV", lroundf([[cellData objectForKey:@"abv_pct"] floatValue])];
    cell.abvLabel.text = formattedABV;
    
    NSString* formattedValueRating = [NSString stringWithFormat:@"%ld", lroundf([[cellData objectForKey:@"value_score"] floatValue])];
    
    cell.valueRatingLabel.text = formattedValueRating;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == ([[self drinksArray] count] - 1)) { //if we hover over the last row
        if([self lastRequestedRow] == indexPath.row) { // and we haven't already sent a request to get the next set of data
            NSLog(@"We've just requested this data, not requesting it again!");
            return;
        }
        
        self.lastRequestedRow = indexPath.row;
        self.startRow = [[self drinksArray] count];
        self.replaceDrinks = false;
        [self requestDrinksData:nil :nil :nil :nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // TODO: implement if necessary
}
- (IBAction)reloadButtonClicked:(UIBarButtonItem *)sender {
    NSLog(@"reloadButtonClicked");
    self.lastRequestedRow = -1;
    self.startRow = 0;
    [self requestDrinksData:nil :nil :nil :nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSString *errorMsg = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
    NSLog(@"%@", errorMsg);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSArray *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    

    bool scrollToTop = true;
    // case where we need to lazy load more items.
    if (![self replaceDrinks]) {
        if ([self drinksArray] == nil) {
            self.drinksArray = [[NSArray alloc] init];
        }
        
        NSMutableArray *combinedArr = [[NSMutableArray alloc] initWithArray:[self drinksArray]];
        [combinedArr addObjectsFromArray:res];
        
        self.drinksArray = combinedArr;
        self.replaceDrinks = true; // reset to beginning state so that if a filter call is made directly after this, it doesn't add to the irrelevant data already in the tableview.
        scrollToTop = false;
        self.startRow = 0;
    } else { // case where the data is loaded for the first time, or user updates filters.
        self.drinksArray = res;
    }
    
    [[self tblView] reloadData];
    
    if(scrollToTop) {
        NSLog(@"Scrolling to top!!");
        // Scroll to top
        [[self tblView] scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
    self.title = @"VABC Drinks";
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqual: @"FilterDrinksSegue"]) {
        FilterDrinksViewController *fdvc = (FilterDrinksViewController *)[segue destinationViewController];
        fdvc.sortByStr = self.sortVal;
        fdvc.sizeStr = self.numMLVal;
        fdvc.drinkNameStr = self.nameVal;
        fdvc.categoryStr = self.categoryVal;
        fdvc.delegate = self;
    }
}

@end
