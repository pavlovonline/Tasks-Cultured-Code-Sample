//
//  MapPlaceResultsViewController.m
//  Vee Nation
//
//  Created by Anton Pavlov on 1/6/13.
//  Copyright (c) 2013 Pavlov. All rights reserved.
//

#import "MapPlaceResultsViewController.h"
#import "PlaceMapAnnotation.h"

@interface MapPlaceResultsViewController ()
@property (nonatomic, strong) PlaceMapAnnotation *placeAnnotation;
//@property (nonatomic, strong) NSArray *objects;
@property (nonatomic, strong) PFObject *chosenObject;

@end

@implementation MapPlaceResultsViewController
@synthesize placeAnnotation=_placeAnnotation;
@synthesize geoPoint=_geoPoint;
@synthesize objects=_objects;
@synthesize annotations=_annotations;
@synthesize chosenObject=_chosenObject;
@synthesize users=_users;
@synthesize mkPlaceMark=_mkPlaceMark;
@synthesize featuredObject=_featuredObject;
@synthesize mkLocationMark=_mkLocationMark;
@synthesize name=_name;
@synthesize address=_address;
@synthesize actionSheet=_actionSheet;


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
	// Do any additional setup after loading the view.
    
    self.mapView.delegate=self;
    
    self.title=self.name;
    
    if (self.mkPlaceMark)
    {
        
        if (self.name.length && self.address.length)
        {
            self.placeAnnotation=[[PlaceMapAnnotation alloc]initWithLocation:self.mkPlaceMark.coordinate withObject:self.featuredObject withTitle:self.name withSubtitle:self.address];
        }
        else{
            self.placeAnnotation=[[PlaceMapAnnotation alloc]initWithLocation:self.mkPlaceMark.coordinate withObject:self.featuredObject withTitle:[self.featuredObject valueForKey:@"name"] withSubtitle:[self.featuredObject valueForKey:@"address"]];
        }
        
        [self.mapView addAnnotation:self.placeAnnotation];
                
    }
    
    if (self.mkLocationMark)
    {
        
        
        PlaceMapAnnotation *annotation=[[PlaceMapAnnotation alloc]initWithLocation:self.mkLocationMark.coordinate withObject:self.featuredObject withTitle:[self.featuredObject valueForKey:@"locationName"] withSubtitle:[self.featuredObject valueForKey:@"address"]];
        
        [self.mapView addAnnotation:annotation];
        
        MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(self.mkPlaceMark.coordinate, 500, 500);
        
        [self.mapView setRegion:region];
        
        [self.mapView selectAnnotation:annotation animated:YES];
    }
}

-(void)addAnnotationForShow
{
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(self.mkPlaceMark.coordinate, 500, 500);
    
    [self.mapView setRegion:region animated:YES];
    
    [self.mapView selectAnnotation:self.placeAnnotation animated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.mkPlaceMark)
    {
        UIBarButtonItem *openMapButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openMapsButtonPressed:)];
        [self.navigationItem setRightBarButtonItem:openMapButton];
    }
    
    if (!self.featuredObject)
    {
        MKMapRect zoomRect=MKMapRectNull;
        for (id<MKAnnotation> annotation in self.mapView.annotations)
        {
            MKMapPoint annotationPoint=MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect=MKMapRectMake(annotationPoint.x, annotationPoint.y, .1, .1);
            
            if (MKMapRectIsNull(zoomRect))
            {
                zoomRect=pointRect;
            }
            else
            {
                zoomRect=MKMapRectUnion(zoomRect, pointRect);
            }
        }
        [self.mapView setVisibleMapRect:zoomRect animated:YES];
    }
    
    [self performSelector:@selector(addAnnotationForShow) withObject:nil afterDelay:1.0];

}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView=[mapView dequeueReusableAnnotationViewWithIdentifier:@"place"];
    
    if (!aView)
    {
        aView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"place"];
        aView.canShowCallout=YES;
        UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:@selector(showSinglePlace) forControlEvents:UIControlEventTouchUpInside];
        if (self.featuredObject)
            aView.rightCalloutAccessoryView=nil;
        else
            aView.rightCalloutAccessoryView=rightButton;
    }
    
    aView.annotation=annotation;
    return aView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    PlaceMapAnnotation *pma=(PlaceMapAnnotation *)view.annotation;
    self.chosenObject=pma.object;
    NSLog(@"selected annotation object %@", self.chosenObject);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}

-(void)openMapsButtonPressed:(UIBarButtonItem *)sender
{
    self.actionSheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil  otherButtonTitles:@"Open in Maps", nil];
    [self.actionSheet showFromTabBar:self.tabBarController.tabBar];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Open in Maps"])
    {
        MKMapItem *mapItem=[[MKMapItem alloc]initWithPlacemark:self.mkPlaceMark];
        
        if ([[[UIDevice currentDevice]systemVersion] floatValue]>=6.0)
        {
            [mapItem openInMapsWithLaunchOptions:nil];
        }
        else
        {
            //under ios6
            NSString *url=[NSString stringWithFormat:@"http://maps.google.com/maps?center=%f,%f", self.mkPlaceMark.location.coordinate.latitude, self.mkPlaceMark.location.coordinate.longitude];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
        }
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex]isEqualToString:@"Cancel"])
    {
        [self.actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
    else
    {
        //nothing
    }
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
