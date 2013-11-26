//
//  LocationsViewController.m
//  VABC
//
//  Created by Benjamin Katz on 11/11/13.
//  Copyright (c) 2013 Benjamin Katz. All rights reserved.
//

#import "LocationsViewController.h"
#import "LocationDetailViewController.h"
#import "LocationAnnotation.h"

@interface LocationsViewController ()
@property NSArray *locationsArray;
@property NSMutableData *responseData;
@property NSMutableDictionary *locationsDict;
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
    
    self.responseData = [NSMutableData data];
    
    [self requestLocationsData];
    

    
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

- (void)requestLocationsData
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:@"http://bakatz.com/scripts/get_vabc_data.php?type=establishments"]];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)addLocationsToMap
{
    int i = 0;
    for (NSDictionary *locationData in [self locationsArray]) {
        CLLocationCoordinate2D locationCoords;
        
        locationCoords.latitude = [[locationData objectForKey:@"lat"] floatValue];
        locationCoords.longitude = [[locationData objectForKey:@"lon"] floatValue];
        
        LocationAnnotation *locationMarker = [[LocationAnnotation alloc] init];
        
        locationMarker.coordinate = locationCoords;
        locationMarker.city = [locationData objectForKey:@"city"];
        locationMarker.phoneNo = [locationData objectForKey:@"phone_number"];
        locationMarker.title = [locationData objectForKey:@"street"];//[NSString stringWithFormat:@"VABC Store #%d", ++i];
        locationMarker.subtitle = [NSString stringWithFormat:@"Tap to view details about VABC Store #%d", ++i];
        [[self mapView] addAnnotation:locationMarker];
    }
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"LocationDetailSegue" sender:view];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.pinColor = MKPinAnnotationColorRed;
            pinView.calloutOffset = CGPointMake(0, 32);

            // Add a detail disclosure button to the callout.
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.rightCalloutAccessoryView = rightButton;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqual: @"LocationDetailSegue"]) {
        LocationDetailViewController *ldvc = [segue destinationViewController];
        MKPinAnnotationView *senderPin = (MKPinAnnotationView *)sender;
        LocationAnnotation *senderAnno = (LocationAnnotation *)senderPin.annotation;
        
        ldvc.locationAnnotation = senderAnno;
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"LVC - didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"LVC - didFailWithError");
    NSString *errorMsg = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
    NSLog(@"%@", errorMsg);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"LVC - connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSArray *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    self.locationsArray = res;
    [self addLocationsToMap];
    self.title = @"VABC Locations";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
