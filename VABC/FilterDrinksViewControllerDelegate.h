//
//  FilterDrinksViewControllerDelegate.h
//  VABC
//
//  Created by Benjamin Katz on 11/18/13.
//  Copyright (c) 2013 Benjamin Katz. All rights reserved.
//

@protocol FilterDrinksViewControllerDelegate <NSObject>
- (void)requestDrinksData:(NSString *)sort :(NSString *)numML :(NSString *)category :(NSString *)name;
@end