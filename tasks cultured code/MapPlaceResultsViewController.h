//
//  MapPlaceResultsViewController.h
//  Vee Nation
//
//  Created by Anton Pavlov on 1/6/13.
//  Copyright (c) 2013 Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface MapPlaceResultsViewController : UIViewController <MKMapViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) PFGeoPoint *geoPoint;
@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic, strong) NSArray *objects;
@property (nonatomic, strong) NSDictionary *users;
@property (nonatomic, strong) MKPlacemark *mkPlaceMark;
@property (nonatomic, strong) MKPlacemark *mkLocationMark;
@property (nonatomic, strong) PFObject *featuredObject;
@property (nonatomic, strong) UIActionSheet *actionSheet;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;

@end
