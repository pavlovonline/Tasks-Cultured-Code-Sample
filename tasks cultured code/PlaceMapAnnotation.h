//
//  PlaceMapAnnotation.h
//  Vee Nation
//
//  Created by Anton Pavlov on 1/7/13.
//  Copyright (c) 2013 Pavlov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface PlaceMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;

@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFGeoPoint *geoPoint;
@property (nonatomic, strong) NSString *annotationObjectId;

+(PlaceMapAnnotation *)annotationForPlace:(PFObject*)place atPoint:(PFGeoPoint*)point;

-(id)initWithLocation:(CLLocationCoordinate2D)coordinate
           withObject:(PFObject *)object
            withTitle:(NSString *)title
         withSubtitle:(NSString *)subtitle;

@end
