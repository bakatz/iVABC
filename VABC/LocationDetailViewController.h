//
//  LocationDetailViewController.h
//  VABC
//
//  Created by Benjamin Katz on 11/11/13.
//  Copyright (c) 2013 Benjamin Katz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationAnnotation.h"

@interface LocationDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *streetLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityStateLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *openCloseTimeLabel;

@property LocationAnnotation *locationAnnotation;

@end
