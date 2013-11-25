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
@property NSDictionary *sizeDict;
@property NSArray *categoryArray;
@end

@implementation FilterDrinksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)textFieldChanged:(UITextField *)sender {
    NSLog(@"Changed this mofuggin text field");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // DrinksViewController *dvc = (DrinksViewController *)[[[self parentViewController] parentViewController] parentViewController];
    // doesn't work? [dvc requestDrinksData];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [[self view] addGestureRecognizer:tap];
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"FilterDrinksPickerData" ofType:@"plist"];
    NSDictionary *pickerDataDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    self.categoryArray = [pickerDataDict objectForKey:@"categoryArray"];


    self.sortByDict = [pickerDataDict objectForKey:@"sortByDict"];
    
    self.sizeDict = [pickerDataDict objectForKey:@"sizeDict"];
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
        NSLog(@"sortBy changed!");
        //[[self sortByArray] objectAtIndex:row];
    } else if (pickerView == [self sizePicker]) {
        //[[self sizeArray] objectAtIndex:row];
        NSLog(@"size changed!");
    } else {
        NSLog(@"category changed to %@", [[self categoryArray] objectAtIndex:row]);
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
        dataArray = [[self sizeDict] keysSortedByValueUsingComparator:^(id first, id second) {
            if ([first integerValue] < [second integerValue])
                return (NSComparisonResult)NSOrderedDescending;
            
            if ([first integerValue] > [second integerValue])
                return (NSComparisonResult)NSOrderedAscending;
            return (NSComparisonResult)NSOrderedSame;
        }];
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
