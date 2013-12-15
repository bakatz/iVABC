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
- (IBAction)selectedSegmentChanged:(UISegmentedControl *)sender {
    
    if (sender == [self drinkSizeControl]) {
        NSString *key = [[self sizeArray] objectAtIndex:[sender selectedSegmentIndex]];
        NSString *size = [[self sizeDict] objectForKey:key];
        
        // (All Sizes) case
        if([size isEqualToString:@"9999"]) {
            size = @"";
        }
        
        NSLog(@"size changed to %@", size);
        [[self delegate] requestDrinksData :nil:size:nil:nil];
    } else {
        NSString *key = [[self sortByArray] objectAtIndex:[sender selectedSegmentIndex]];
        NSDictionary *sortByDictData = [[self sortByDict] objectForKey:key];
        NSString *internalID = [sortByDictData objectForKey:@"id"];
        NSLog(@"sortBy changed to %@", internalID);
        [[self delegate] requestDrinksData :internalID:nil:nil:nil];
    }
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
    
    UIFont *font = [UIFont boldSystemFontOfSize:8.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:UITextAttributeFont];
    [self.drinkSortByControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    [self.drinkSizeControl setTitleTextAttributes:attributes
                                         forState:UIControlStateNormal];
    
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
    
    
    NSInteger sortByIdx = NSNotFound;
    NSInteger categoryIdx = NSNotFound;
    NSInteger sizeIdx = NSNotFound;
    
    if ([self categoryStr] != nil && [[self categoryStr] length] > 0) {
        categoryIdx = [[self categoryArray] indexOfObject:[[self categoryStr] capitalizedString]];
    }
    if ([self sortByStr] != nil && [[self sortByStr] length] > 0) {
        NSArray *keys = [[self sortByDict] allKeys];
        for (NSString *key in keys) {
            if ([[[[self sortByDict] objectForKey:key] objectForKey:@"id"] isEqualToString:self.sortByStr]) {
                sortByIdx = [[self sortByArray] indexOfObject:key];
                break;
            }
        }
    }
    
    if ([self sizeStr] != nil && [[self sizeStr] length] > 0) {
        NSArray *keys = [[self sizeDict] allKeys];
        for (NSString *key in keys) {
            if ([[[self sizeDict] objectForKey:key] isEqualToString:self.sizeStr]) {
                sizeIdx = [[self sizeArray] indexOfObject:key];
                break;
            }
        }
    }
    
    NSUInteger len = [[self sortByArray] count];
    for (int i = 0; i < len; i++) {
        [[self drinkSortByControl] setTitle:[[self sortByArray] objectAtIndex:i] forSegmentAtIndex:i];
    }
    
    len = [[self sizeArray] count];
    for (int i = 0; i < len; i++) {
        [[self drinkSizeControl] setTitle:[[self sizeArray] objectAtIndex:i] forSegmentAtIndex:i];
    }
    //[segmentedControl setTitle:<YourLocalizedString> forSegmentAtIndex:0];


    
    NSLog(@"Trying to restore these values: name=%@ category=%@ size=%@ sortby=%@", self.drinkNameStr, self.categoryStr, self.sizeStr, self.sortByStr);
    
    if ([self drinkNameStr] != nil && [[self drinkNameStr] length] > 0) {
        NSLog(@"Restored drinkName");
        self.drinkNameText.text = self.drinkNameStr;
    }
    
    if(sortByIdx != NSNotFound) {
        NSLog(@"Restored sortBy");
        self.drinkSortByControl.selectedSegmentIndex = sortByIdx;
        //[[self sortByPicker] selectRow:sortByIdx inComponent:0 animated:YES];
    }
    
    if(categoryIdx != NSNotFound) {
        NSLog(@"Restored category");
        [[self categoryPicker] selectRow:categoryIdx inComponent:0 animated:YES];
    }
    
    if(sizeIdx != NSNotFound) {
        NSLog(@"Restored size");
        self.drinkSizeControl.selectedSegmentIndex = sizeIdx;
        //[[self sizePicker] selectRow:sizeIdx inComponent:0 animated:YES];
    }
    
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

- (IBAction)resetButtonClicked:(UIButton *)sender {
    self.drinkSortByControl.selectedSegmentIndex = 0;
    [[self categoryPicker] selectRow:0 inComponent:0 animated:YES];
    self.drinkSizeControl.selectedSegmentIndex = 0;
    
    self.drinkNameText.text = @"";
    self.drinkNameStr = @"";
    self.sortByStr = @"value_score";
    self.categoryStr = @"";
    self.sizeStr = @"";
    
    [[self delegate] requestDrinksData :self.sortByStr:self.sizeStr:self.categoryStr:self.drinkNameStr];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    NSString *category = [[[self categoryArray] objectAtIndex:row] lowercaseString];
        
    //(All Categories) case - clear the category filter.
    if ([category characterAtIndex:0] == '(') {
        category = @"";
    }
    NSLog(@"category changed to %@", category);
    [[self delegate] requestDrinksData :nil:nil:category:nil];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[self categoryArray] count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [@"" stringByAppendingFormat:@"%@", [[self categoryArray] objectAtIndex:row]];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 165;
}

@end
