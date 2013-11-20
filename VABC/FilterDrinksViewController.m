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
@property NSArray *sortByArray;
@property NSArray *sizeArray;
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

    self.sortByArray = [NSArray arrayWithObjects:@"Best Value", @"Price", @"Size", @"ABV", @"Age", @"Name", @"Category Name", nil];
    self.sizeArray = [NSArray arrayWithObjects:@"(All Sizes)", @"Handle (1.75L)", @"1L", @"Fifth (750mL)", @"375mL", @"50mL", nil];
    self.categoryArray = [NSArray arrayWithObjects:@"(All Types)", @"Vodka", @"Tequila", @"Specialty", @"Bourbon", @"Scotch", @"Whiskey", @"Rum", @"Rock-Rye", @"Gin", @"Eggnog", @"Cognac", @"Cocktails", @"Brandy", @"Moonshine", @"Vermouth", nil];
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
        [[self sortByArray] objectAtIndex:row];
    } else if (pickerView == [self sizePicker]) {
        [[self sizeArray] objectAtIndex:row];
        NSLog(@"size changed!");
    } else {
        NSLog(@"category changed to %@", [[self categoryArray] objectAtIndex:row]);
    }
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == [self sortByPicker]) {
        return 7;
    } else if(pickerView == [self sizePicker]) {
        return 6;
    } else {
        return 16;
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
        dataArray = [self sortByArray];
    } else if(pickerView == [self sizePicker]) {
        dataArray = [self sizeArray];
    } else {
        dataArray = [self categoryArray];
    }
    title = [@"" stringByAppendingFormat:@"%@", [dataArray objectAtIndex:row]];//row];
    
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 165;
}

@end
