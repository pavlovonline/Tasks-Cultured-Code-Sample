//
//  TaskViewController.m
//  tasks cultured code
//
//  Created by Anton Pavlov on 5/7/13.
//  Copyright (c) 2013 Anton Pavlov. All rights reserved.
//

#import "TaskViewController.h"
#import "MapPlaceResultsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TaskViewController ()

@end

@implementation TaskViewController
@synthesize  object=_object;
@synthesize taskTitle=_taskTitle;
@synthesize taskLocation=_taskLocation;
@synthesize taskNote=_taskNote;
@synthesize taskDate=_taskDate;
@synthesize taskPhoto=_taskPhoto;
@synthesize completeButton=_completeButton;

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
    
    if (self.object)
    {
        [self.completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.completeButton setBackgroundColor:[UIColor redColor]];
        [self.completeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        
        CAGradientLayer *noBtnGradient=[CAGradientLayer layer];
        noBtnGradient.frame=self.completeButton.bounds;
        noBtnGradient.colors=[NSArray arrayWithObjects:(id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:41.0f / 255.0f green:41.0f / 255.0f blue:41.0f / 255.0f alpha:1.0f]CGColor], nil];
        [self.completeButton.layer insertSublayer:noBtnGradient atIndex:0];
        
        CALayer *noBtnLayer=self.completeButton.layer;
        [noBtnLayer setMasksToBounds:YES];
        [noBtnLayer setCornerRadius:5.0f];
        [noBtnLayer setBorderWidth:1.0f];
        
        
        [self.taskTitle setText:[self.object valueForKey:@"taskTitle"]];
        
        self.title=[self.object valueForKey:@"taskTitle"];
        
        if ([self.object valueForKey:@"date"])
        {
            NSDate *dateValue=[self.object valueForKey:@"date"];
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM/dd/yyyy at mm:hha"];
            [self.taskDate setText:[NSString stringWithFormat:@"Due on %@", [formatter stringFromDate:dateValue]]];
        }
        
        if ([self.object valueForKey:@"location"])
        {
            [self.taskLocation.titleLabel setNumberOfLines:0];
            [self.taskLocation.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [self.taskLocation.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [self.taskLocation setTitle:[self.object valueForKey:@"place"] forState:UIControlStateNormal];
        }
        
        if ([self.object valueForKey:@"taskNote"])
        {
            [self.taskNote setText:[self.object valueForKey:@"taskNote"]];
        }
        
        if ([[self.object valueForKey:@"complete"]isEqualToNumber:[NSNumber numberWithBool:YES]])
        {
            [self.completeButton setTitle:@"Mark Not Complete" forState:UIControlStateNormal];
        }
        else if ([[self.object valueForKey:@"complete"]isEqualToNumber:[NSNumber numberWithBool:YES]])
        {
            [self.completeButton setTitle:@"Complete" forState:UIControlStateNormal];
        }
        
        if ([self.object valueForKey:@"image"])
        {
            self.taskPhoto.file=[self.object objectForKey:@"image"];
            [self.taskPhoto loadInBackground];
        }
    }
}

- (IBAction)clickedLocation:(UIButton *)sender {
    
    if ([self.object valueForKey:@"location"])
    {
        
        NSString *trimmedAddress=[[self.object valueForKey:@"address"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        CLGeocoder *geoCoder=[[CLGeocoder alloc]init];
        
        [geoCoder geocodeAddressString:trimmedAddress completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error || ![placemarks count])
            {
                [[[UIAlertView alloc]initWithTitle:@"Error" message:@"Could not find this address, please check the spelling or use more a more detailed address." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
            }
            else
            {
                //there was no error, we have a placemark
                //take the cllocation out of the first placemark
                CLPlacemark *placeMark=[placemarks objectAtIndex:0];
                //get CLLocation
                
                MapPlaceResultsViewController *mapView=[self.storyboard instantiateViewControllerWithIdentifier:@"MapPlaceResultsViewController"];
                MKPlacemark *mkPlaceMark=[[MKPlacemark alloc]initWithPlacemark:placeMark];
                [mapView setMkPlaceMark:mkPlaceMark];
                [mapView setName:[self.object valueForKey:@"placeName"]];
                [mapView setAddress:[self.object valueForKey:@"address"]];
                [mapView setFeaturedObject:self.object];
                [self.navigationController pushViewController:mapView animated:YES];
                
            }
        }];
        
    }
}


- (IBAction)completeTask:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"Complete"])
    {
        [sender setTitle:@"Mark Not Complete" forState:UIControlStateNormal];
        
        PFQuery *query=[PFQuery queryWithClassName:@"Task"];
        [query whereKey:@"objectId" equalTo:[self.object objectId]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *objectFound, NSError *error) {
            if (objectFound)
            {
                [objectFound setValue:[NSNumber numberWithBool:YES] forKey:@"complete"];
                [objectFound saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                }];
            }
            else
            {
            }
        }];
    }
    else if ([sender.titleLabel.text isEqualToString:@"Mark Not Complete"])
    {
        [sender setTitle:@"Complete" forState:UIControlStateNormal];

        PFQuery *query=[PFQuery queryWithClassName:@"Task"];
        [query whereKey:@"objectId" equalTo:[self.object objectId]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *objectFound, NSError *error) {
            if (objectFound)
            {
                [objectFound setValue:[NSNumber numberWithBool:NO] forKey:@"complete"];
                [objectFound saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                }];
            }
            else
            {
            }
        }];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
