//
//  LocationDetailViewController.m
//  VABC
//
//  Created by Benjamin Katz on 11/11/13.
//  Copyright (c) 2013 Benjamin Katz. All rights reserved.
//

#import "LocationDetailViewController.h"

@interface LocationDetailViewController ()

@end

@implementation LocationDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)callStoreClicked:(UIButton *)sender {
    UIDevice *device = [UIDevice currentDevice];
    
    if ([[device model] isEqualToString:@"iPhone"] ) {
        
        NSString *phoneNumber = [@"tel:" stringByAppendingString:[[self locationAnnotation] phoneNo]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        
    } else {
        
        UIAlertView *warning =[[UIAlertView alloc] initWithTitle:@"Note" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [warning show];
    }
}
- (IBAction)navigateToStoreClicked:(UIButton *)sender {
    // Check for iOS 6
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        
        // Create an MKMapItem to pass to the Maps app
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:[[self locationAnnotation] coordinate]
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:@"VABC Store"];
        
        // Set the directions mode to "Driving"
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
}

- (void)calculateHours
{
    NSDate *now = [NSDate date];
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorianCal setFirstWeekday:2]; // Sunday == 1, Saturday == 7
    NSDateComponents *dateComps = [gregorianCal components: (NSHourCalendarUnit | NSMinuteCalendarUnit)
                                                  fromDate: now];
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat:@"EEEE"];
    NSString *dayOfWeek = [myFormatter stringFromDate:now];
    
    int m = [dateComps minute];
    int h = [dateComps hour];
    UIColor *redColor = [UIColor redColor];
    UIColor *greenColor = [UIColor greenColor];
    
    // Sunday -- 1 pm to 6 pm
    if ([dayOfWeek isEqualToString:@"Sunday"]) {
        if (h < 13 || h > 18) {
            self.statusLabel.text = @"CLOSED";
            [self.statusLabel setTextColor:redColor];
            int mins = 60 - m;
            int hours = (h >= 18 ? 33 - h : 12 - h) + (mins == 60 ? 1 : 0);
            
            self.openCloseTimeLabel.text = [NSString stringWithFormat:@"This store will open in %d hours and %d minutes.", hours, mins];
            return;
        } else {
            self.statusLabel.text = @"OPEN";
            [self.statusLabel setTextColor:greenColor];
            int mins = 60 - m;
            int hours = 20 - h + (mins == 60 ? 1 : 0);
            mins %= 60;
            
            self.openCloseTimeLabel.text = [NSString stringWithFormat:@"This store will close in %d hours and %d minutes.", hours, mins];
            return;
        }
    } else { // All other days -- 10 am to 9 pm
        if (h < 10 || h >= 21) {
            self.statusLabel.text = @"CLOSED";
            [self.statusLabel setTextColor:redColor];
            int mins = 60 - m;
            int hours = (h >= 21 ? 33 - h : 9 - h) + (mins == 60 ? 1 : 0);
            mins %= 60;
            
            self.openCloseTimeLabel.text = [NSString stringWithFormat:@"This store will open in %d hours and %d minutes.", hours, mins];
            return;
        } else {
            self.statusLabel.text = @"OPEN";
            [self.statusLabel setTextColor:greenColor];
            int mins = 60 - m;
            int hours = 20 - h + (mins == 60 ? 1 : 0);
            mins %= 60;
            self.openCloseTimeLabel.text = [NSString stringWithFormat:@"This store will close in %d hours and %d minutes.", hours, mins];
            return;
        }
    }

}

- (void)formatPhoneNumber
{
    NSString *rawPhoneNo = [[self locationAnnotation] phoneNo];
    NSString *formattedPhoneNo = [NSString stringWithFormat:@"(%@) %@-%@", [rawPhoneNo substringWithRange:NSMakeRange(0, 3)], [rawPhoneNo substringWithRange:NSMakeRange(3, 3)], [rawPhoneNo substringWithRange:NSMakeRange(6, 4)]];
    self.phoneNumberLabel.text = formattedPhoneNo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.streetLabel.text = [[self locationAnnotation] title];
    self.cityStateLabel.text = [NSString stringWithFormat:@"%@, VA", [[self locationAnnotation] city]];
    [self formatPhoneNumber];
    [self calculateHours];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
