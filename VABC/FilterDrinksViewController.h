//
//  FilterDrinksViewController.h
//  VABC
//
//  Created by Benjamin Katz on 11/18/13.
//  Copyright (c) 2013 Benjamin Katz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterDrinksViewController : UIViewController<UIPickerViewDelegate, UITextFieldDelegate>

// 7 items
@property (strong, nonatomic) IBOutlet UIPickerView *sortByPicker;

// 6 items
@property (strong, nonatomic) IBOutlet UIPickerView *sizePicker;

// 16 items
@property (strong, nonatomic) IBOutlet UIPickerView *categoryPicker;

@property (strong, nonatomic) IBOutlet UITextField *drinkNameText;

@end
