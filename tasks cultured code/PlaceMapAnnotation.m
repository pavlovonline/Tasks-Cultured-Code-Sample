//
//  PlaceMapAnnotation.m
//  Vee Nation
//
//  Created by Anton Pavlov on 1/7/13.
//  Copyright (c) 2013 Pavlov. All rights reserved.
//

#import "PlaceMapAnnotation.h"

@implementation PlaceMapAnnotation
@synthesize coordinate=_coordinate;
@synthesize  title=_title;
@synthesize subtitle=_subtitle;
@synthesize object=_object;
@synthesize geoPoint=_geoPoint;
@synthesize annotationObjectId=_annotationObjectId;

-(id)initWithLocation:(CLLocationCoordinate2D)coordinate
           withObject:(PFObject *)object
            withTitle:(NSString *)title
         withSubtitle:(NSString *)subtitle
{
    self.object=object;
    self.title=title;
    self.subtitle=subtitle;
    self.coordinate=coordinate;
    return self;
}

+(PlaceMapAnnotation *)annotationForPlace:(PFObject*)place atPoint:(PFGeoPoint*)point
{
    PlaceMapAnnotation *annotation=[[PlaceMapAnnotation alloc]init];
    
    annotation.object=place;
    annotation.geoPoint=point;

//    PFQuery *likesQuery=[PFQuery queryWithClassName:@"Activity"];
//    [likesQuery whereKey:@"place" equalTo:place];
//    [likesQuery whereKey:@"type" equalTo:@"like"];
//    [likesQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
//        if (error)
//        {
//            //nslog(@"counting number of likes for map annotation error %@", error);
//        }
//        else
//        {
//            //assign received int to a variable (possibly nsnumber)
//        }
//    }];
    
    NSLog(@"place (object) in mkmapannotation %@", annotation.object);
    
    return annotation;
}
//
//-(CLLocationCoordinate2D)coordinate
//{
//    CLLocationCoordinate2D coordinate;
//    coordinate.latitude=self.geoPoint.latitude;
//    coordinate.longitude=self.geoPoint.longitude;
//    
//    return coordinate;
//}
//
//-(NSString *)title
//{
//    NSString *title=[self.object valueForKey:@"name"];
//    return title;
//}
//
//-(NSString *)subtitle
//{
//    NSString *subtitle=[self.object valueForKey:@"address"];
//    return subtitle;
//}
//
//-(NSString *)annotationObjectId
//{
//    NSString *string=[self.object valueForKey:@"objectId"];
//    return string;
//}


@end
