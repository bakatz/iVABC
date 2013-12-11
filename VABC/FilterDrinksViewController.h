//
//  FilterDrinksViewController.h
//  VABC
//
//  Created by Benjamin Katz on 11/18/13.
//  Copyright (c) 2013 Benjamin Katz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrinksViewController.h"

@interface FilterDrinksViewController : UIViewController<UIPickerViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *drinkTypeControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *drinkSizeControl;

// 7 items
@property (strong, nonatomic) IBOutlet UIPickerView *sortByPicker;
@property NSString *sortByStr;

// 6 items
@property (strong, nonatomic) IBOutlet UIPickerView *sizePicker;
@property NSString *sizeStr;

// 16 items
@property (strong, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property NSString *categoryStr;

@property (strong, nonatomic) IBOutlet UITextField *drinkNameText;
@property NSString *drinkNameStr;

@property DrinksViewController *drinksViewController;

@property (assign) id <FilterDrinksViewControllerDelegate> delegate;

@end
