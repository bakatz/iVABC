//
//  LocationsViewController.m
//  VABC
//
//  Created by Benjamin Katz on 11/11/13.
//  Copyright (c) 2013 Benjamin Katz. All rights reserved.
//

#import "LocationsViewController.h"

@interface LocationsViewController ()

@end

@implementation LocationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.showsUserLocation = YES;
    [self.mapView.userLocation addObserver:self
                                forKeyPath:@"location"
                                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                                   context:NULL];
    

    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    static bool firstLoc = true;
    
    // Only pan/zoom the map when we get our first location from the GPS, otherwise the map will snap back into place when the user tries to pan around.
    if ([self.mapView showsUserLocation] && firstLoc) {
        
        MKCoordinateSpan span = MKCoordinateSpanMake(0, 360/pow(2, 13)*self.mapView.frame.size.width/256);
        [[self mapView ]setRegion:MKCoordinateRegionMake(self.mapView.userLocation.coordinate, span) animated:YES];
        firstLoc = false;
    }
}

- (void)addLocations
{
    CLLocationCoordinate2D annotationCoord;
    
    annotationCoord.latitude = 47.640071;
    annotationCoord.longitude = -122.129598;
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = @"Microsoft";
    annotationPoint.subtitle = @"Microsoft's headquarters";
    [[self mapView] addAnnotation:annotationPoint];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
