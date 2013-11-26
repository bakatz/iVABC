//
//  LocationAnnotation.h
//  VABC
//
//  Created by Benjamin Katz on 11/26/13.
//  Copyright (c) 2013 Benjamin Katz. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface LocationAnnotation : MKPointAnnotation
@property NSString *phoneNo;
@property NSString *city;
@end
