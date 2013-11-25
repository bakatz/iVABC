//
//  FilterDrinksViewController.m
//  VABC
//
//  Created by Benjamin Katz on 11/18/13.
//  Copyright (c) 2013 Benjamin Katz. All rights reserved.
//

#import "FilterDrinksViewController.h"
#import "DrinksViewController.h"

@interface FilterDrinksViewController ()
@property NSDictionary *sortByDict;
@property NSArray *sortByArray;
@property NSDictionary *sizeDict;
@property NSArray *sizeArray;
@property NSArray *categoryArray;
@end

@implementation FilterDrinksViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)textFieldChanged:(UITextField *)sender {
    [[self delegate] requestDrinksData :nil:nil:nil:[sender text]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [[self view] addGestureRecognizer:tap];
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"FilterDrinksPickerData" ofType:@"plist"];
    NSDictionary *pickerDataDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    self.categoryArray = [pickerDataDict objectForKey:@"categoryArray"];


    self.sortByDict = [pickerDataDict objectForKey:@"sortByDict"];
    self.sortByArray = [[self sortByDict] keysSortedByValueUsingComparator:^(id first, id second) {
        NSDictionary *firstDict = (NSDictionary *)first;
        NSDictionary *secondDict = (NSDictionary *)second;
        
        NSInteger firstIdx = [[firstDict objectForKey:@"index"] integerValue];
        NSInteger secondIdx = [[secondDict objectForKey:@"index"] integerValue];

        if (firstIdx > secondIdx)
            return (NSComparisonResult)NSOrderedDescending;
        
        if (firstIdx < secondIdx)
            return (NSComparisonResult)NSOrderedAscending;
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    self.sizeDict = [pickerDataDict objectForKey:@"sizeDict"];
    self.sizeArray = [[self sizeDict] keysSortedByValueUsingComparator:^(id first, id second) {
        if ([first integerValue] < [second integerValue])
            return (NSComparisonResult)NSOrderedDescending;
        
        if ([first integerValue] > [second integerValue])
            return (NSComparisonResult)NSOrderedAscending;
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    [self setUpPickers];
}

- (void)setUpPickers {
    
    [self sortByPicker];
    [self sizePicker];
    [self categoryPicker];
    
    NSLog(@"Going to restore these values: name=%@ category=%@ size=%@ sortby=%@", self.drinkNameStr, self.categoryStr, self.sizeStr, self.sortByStr);
    
}

- (void)dismissKeyboard {
    [[self drinkNameText] resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.drinkNameText) {
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if(pickerView == [self sortByPicker]) {
        NSString *key = [[self sortByArray] objectAtIndex:row];
        NSDictionary *sortByDictData = [[self sortByDict] objectForKey:key];
        NSString *internalID = [sortByDictData objectForKey:@"id"];
        NSLog(@"sortBy changed to %@", internalID);
        [[self delegate] requestDrinksData :internalID:nil:nil:nil];
        //[[self drinksViewController] requestDrinksData];
    } else if (pickerView == [self sizePicker]) {
        NSString *key = [[self sizeArray] objectAtIndex:row];
        NSString *size = [[self sizeDict] objectForKey:key];
        
        // (All Sizes) case
        if([size isEqualToString:@"9999"]) {
            size = @"";
        }
        
        NSLog(@"size changed to %@", size);
        [[self delegate] requestDrinksData :nil:size:nil:nil];
    } else {
        NSString *category = [[[self categoryArray] objectAtIndex:row] lowercaseString];
        NSLog(@"category changed to %@", category);
        [[self delegate] requestDrinksData :nil:nil:category:nil];
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == [self sortByPicker]) {
        return [[self sortByDict] count];
    } else if(pickerView == [self sizePicker]) {
        return [[self sizeDict] count];
    } else {
        return [[self categoryArray] count];
    }
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title;
    NSArray *dataArray = nil;
    if (pickerView == [self sortByPicker]) {
        dataArray = [[self sortByDict] allKeys];
    } else if(pickerView == [self sizePicker]) {
        dataArray = [self sizeArray];
    } else {
        dataArray = [self categoryArray];
    }
    
    title = [@"" stringByAppendingFormat:@"%@", [dataArray objectAtIndex:row]];
    
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 165;
}

@end
