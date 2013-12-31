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

// 7 items
@property NSString *sortByStr;
@property (strong, nonatomic) IBOutlet UISegmentedControl *drinkSortByControl;

// 7 items
@property NSString *sizeStr;
@property (strong, nonatomic) IBOutlet UISegmentedControl *drinkSizeControl;

// 16 items
@property (strong, nonatomic) IBOutlet UIPickerView *categoryPicker;
@property NSString *categoryStr;

// text field at the top right
@property (strong, nonatomic) IBOutlet UITextField *inventoryCodeText;
@property NSString *inventoryCodeStr;

// text field at the top left
@property (strong, nonatomic) IBOutlet UITextField *drinkNameText;
@property NSString *drinkNameStr;

@property (assign) id <FilterDrinksViewControllerDelegate> delegate;

@end
