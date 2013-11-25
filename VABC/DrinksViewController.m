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
    
    NSString *urlParams = [NSString stringWithFormat:@"type=drinks&limit=100&sort=%@&num_ml=%@&category=%@&name=%@", self.sortVal, self.numMLVal, self.categoryVal, self.nameVal];
    
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
    cell.categoryShortLabel.text = [cell.categoryLabel.text substringToIndex:2];
    cell.priceLabel.text = [NSString stringWithFormat:@"$%@", [cellData objectForKey:@"price"]];
    cell.sizeLabel.text = [NSString stringWithFormat:@"%@ mL", [[cellData objectForKey:@"num_ml"] stringValue]];
    
    NSString* formattedABV = [NSString stringWithFormat:@"%.03f%% ABV", [[cellData objectForKey:@"abv_pct"] floatValue]];
    cell.abvLabel.text = formattedABV;
    
    NSString* formattedValueRating = [NSString stringWithFormat:@"%.03f value rating", [[cellData objectForKey:@"value_score"] floatValue]];
    
    cell.valueRatingLabel.text = formattedValueRating;
    return cell;
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
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSArray *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    self.drinksArray = res;
    
    [[self tblView] reloadData];
    self.title = @"VABC Drinks";
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"GOT SEGUE!!");
    
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
