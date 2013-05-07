//
//  LookupAddPlaceViewController.m
//  Vee Nation
//
//  Created by Anton Pavlov on 1/5/13.
//  Copyright (c) 2013 Pavlov. All rights reserved.
//

#import "LookupAddPlaceViewController.h"
#import "ResultLookupPlaceTableViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface LookupAddPlaceViewController () <UITextFieldDelegate>
@property (nonatomic, strong) NSDictionary *resultsDictionary;
@property (nonatomic, strong) NSDictionary *resultsDictionaryFromAroundMe;
@property (nonatomic, strong) NSNumber *cancelOperation;

@end

@implementation LookupAddPlaceViewController
@synthesize addressField=_addressField;
@synthesize nextButton=_nextButton;
@synthesize resultsDictionary=_resultsDictionary;
@synthesize resultsDictionaryFromAroundMe=_resultsDictionaryFromAroundMe;
@synthesize cancelOperation=_cancelOperation;
@synthesize showAroundMeButton=_showAroundMeButton;
@synthesize searchButton=_searchBUtton;

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
    self.addressField.delegate=self;
    self.navigationItem.rightBarButtonItem=self.nextButton;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateBadge:) name:UIApplicationDidBecomeActiveNotification object:nil];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text length])
    {
        [textField resignFirstResponder];
        [self showLookupResults:nil];
        return YES;
    }
    else {
        return NO;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.addressField resignFirstResponder];
    
    //show around me
    [self.showAroundMeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.showAroundMeButton setBackgroundColor:[UIColor redColor]];
    [self.showAroundMeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
    CAGradientLayer *noBtnGradient=[CAGradientLayer layer];
    noBtnGradient.frame=self.showAroundMeButton.bounds;
    noBtnGradient.colors=[NSArray arrayWithObjects:(id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:41.0f / 255.0f green:41.0f / 255.0f blue:41.0f / 255.0f alpha:1.0f]CGColor], nil];
    [self.showAroundMeButton.layer insertSublayer:noBtnGradient atIndex:0];
    
    CALayer *noBtnLayer=self.showAroundMeButton.layer;
    [noBtnLayer setMasksToBounds:YES];
    [noBtnLayer setCornerRadius:5.0f];
    [noBtnLayer setBorderWidth:1.0f];
    [noBtnLayer setBorderColor:[[UIColor darkGrayColor]CGColor]];
    
    //search button
    [self.searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.searchButton setBackgroundColor:[UIColor redColor]];
    [self.searchButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
    CAGradientLayer *searchButGradient=[CAGradientLayer layer];
    searchButGradient.frame=self.searchButton.bounds;
    searchButGradient.colors=[NSArray arrayWithObjects:(id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:41.0f / 255.0f green:41.0f / 255.0f blue:41.0f / 255.0f alpha:1.0f]CGColor], nil];
    [self.searchButton.layer insertSublayer:searchButGradient atIndex:0];
    
    CALayer *srchLayer=self.searchButton.layer;
    [srchLayer setMasksToBounds:YES];
    [srchLayer setCornerRadius:5.0f];
    [srchLayer setBorderWidth:1.0f];
    [srchLayer setBorderColor:[[UIColor darkGrayColor]CGColor]];

}




#define ACCEPTABLE_CHARECTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789#"
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *acceptedInput=[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS];
    
    if ([string rangeOfCharacterFromSet:acceptedInput.invertedSet].location!=NSNotFound)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[[event allTouches]anyObject];
    if ([self.addressField isFirstResponder]&&[touch view]!=self.addressField)
    {
        [self.addressField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)showPlacesAroundMe:(UIButton *)sender {
    UIActivityIndicatorView *spinner=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    [spinner setHidden:NO];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:spinner];
    
    //first need to get user's location
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (error)
        {
            //nslog(@"error getting current location in add place lookup around me %@", error);
            [[[UIAlertView alloc]initWithTitle:@"Opps!" message:@"Couldn't find your current location. Please make sure you are connected to the internet and your location services are enabled" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
            self.navigationItem.rightBarButtonItem=self.nextButton;
        }
        else
        {
            //we have the current geopoint, now can do google query
            
     NSString *urlAsString=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyALZK-4o-9JmrPWHMYeEDGyMNaIwqYP3_I&location=%f,%f&sensor=false&types=bakery|bar|cafe|food|florist|grocery_or_supermarket|restaurant&rankby=distance",geoPoint.latitude, geoPoint.longitude];
            
            NSString *escapedString=[urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            //create nsurl
            NSURL *url=[NSURL URLWithString:escapedString];
            
            dispatch_queue_t jsonGetter=dispatch_queue_create("jsonGetter", NULL);
            dispatch_async(jsonGetter, ^{
                NSData *data=[[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil]dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *results;
                NSError *error=nil;
                if (data)
                {
                    results=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
                    NSLog(@"Results in json %@", results);
                    self.resultsDictionaryFromAroundMe=results;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self performSegueWithIdentifier:@"show place lookup results" sender:self];
                        self.navigationItem.rightBarButtonItem=self.nextButton;
                    });
                    
                }
                else
                {
                    NSLog(@"no data");
                    self.navigationItem.rightBarButtonItem=self.nextButton;
                }
                
            });
            
            
        }

    }];
    
    
}

//#define PLACES_API_KEY @"AIzaSyAVEzvl-skrgaKY_A5iboV05GNLglpnrzY"

- (IBAction)showLookupResults:(id)sender {
    
    if (![self.addressField.text length])
    {
        //nothing entered
    }
    else
    {
    UIActivityIndicatorView *spinner=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [spinner startAnimating];
    [spinner setHidden:NO];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:spinner];
    
    
    NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(handleTimeout:) userInfo:nil repeats:NO];
    //do google query with entered address
    
    //first get the address from the text field
    NSString *query=self.addressField.text;
    //trim it
    query=[query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    query=[query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//    NSString *key=@"AIzaSyAVEzvl-skrgaKY_A5iboV05GNLglpnrzY";
    //sensor parameter
//    NSString *sensor=@"false";


    //base url string for google places API
    NSString *urlAsString=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?key=AIzaSyAVEzvl-skrgaKY_A5iboV05GNLglpnrzY&query=%@&sensor=false",query];
    NSString *escapedString=[urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //create nsurl
    NSURL *url=[NSURL URLWithString:escapedString];
    
    dispatch_queue_t jsonGetter=dispatch_queue_create("jsonGetter", NULL);
    dispatch_async(jsonGetter, ^{
        NSData *data=[[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil]dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *results;
        NSError *error=nil;
        if (data && self.cancelOperation!=[NSNumber numberWithBool:YES])
        {
            [timer invalidate];
            results=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
            NSLog(@"Results in json %@", results);
            self.resultsDictionary=results;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"show place lookup results" sender:self];
                self.navigationItem.rightBarButtonItem=self.nextButton;
            });
 
        }
        else
        {
            [timer invalidate];
            NSLog(@"no data");
            self.navigationItem.rightBarButtonItem=self.nextButton;
        }
    
    });

}//something entered in address field
}
                    
-(void)handleTimeout:(NSTimer*)timer
{
    self.cancelOperation=[NSNumber numberWithBool:YES];
    [[[UIAlertView alloc]initWithTitle:@"Connection Timeout" message:@"Seems like there are some connection issues. Please check your internet connection and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    self.navigationItem.rightBarButtonItem=self.nextButton;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show place lookup results"])
    {
        if (self.resultsDictionary)
        [segue.destinationViewController setResultsDictionary:self.resultsDictionary];
        else if (self.resultsDictionaryFromAroundMe)
        {
        [segue.destinationViewController setResultsDictionaryFromAroundMe:self.resultsDictionaryFromAroundMe];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateBadge:(NSNotification *)notification
{
    //set badges for feed
    if ([PFInstallation currentInstallation])
    {
        NSNumber *badgeNumber=[[PFInstallation currentInstallation] valueForKey:@"badge"];
        if ([badgeNumber intValue]>0)
        {
            UITabBarController *feedTabBarController=[self.tabBarController.viewControllers lastObject];
            [feedTabBarController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%i", [badgeNumber intValue]]];
        }
    }
}

- (void)viewDidUnload {
    [self setAddressField:nil];
    [self setNextButton:nil];
    [self setShowAroundMeButton:nil];
    [super viewDidUnload];
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
