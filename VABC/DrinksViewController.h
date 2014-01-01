//
//  DrinksViewController.h
//  VABC
//
//  Created by Benjamin Katz on 11/11/13.
//  Copyright (c) 2013 Benjamin Katz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterDrinksViewControllerDelegate.h"

@interface DrinksViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, NSURLConnectionDataDelegate,FilterDrinksViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tblView;
@property NSString *sortVal;
@property NSString *numMLVal;
@property NSString *categoryVal;
@property NSString *nameVal;
@property NSString *inventoryCodeVal;
@end
