//
//  LoginViewController.m
//  tasks cultured code
//
//  Created by Anton Pavlov on 5/6/13.
//  Copyright (c) 2013 Anton Pavlov. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "MainTabBarControllerViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface LoginViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;


@end

@implementation LoginViewController
@synthesize usernameField=_usernameField;
@synthesize passwordField=_passwordField;
@synthesize loginButton=_loginButton;
@synthesize registerButton=_registerButton;
@synthesize gestureRecognizer=_gestureRecognizer;


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
    
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setBackgroundColor:[UIColor redColor]];
    [self.loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
    CAGradientLayer *noBtnGradient=[CAGradientLayer layer];
    noBtnGradient.frame=self.loginButton.bounds;
    noBtnGradient.colors=[NSArray arrayWithObjects:(id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:41.0f / 255.0f green:41.0f / 255.0f blue:41.0f / 255.0f alpha:1.0f]CGColor], nil];
    [self.loginButton.layer insertSublayer:noBtnGradient atIndex:0];
    
    CALayer *noBtnLayer=self.loginButton.layer;
    [noBtnLayer setMasksToBounds:YES];
    [noBtnLayer setCornerRadius:5.0f];
    [noBtnLayer setBorderWidth:1.0f];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registerButton setBackgroundColor:[UIColor redColor]];
    [self.registerButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
    CAGradientLayer *noBtnGradient=[CAGradientLayer layer];
    noBtnGradient.frame=self.registerButton.bounds;
    noBtnGradient.colors=[NSArray arrayWithObjects:(id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:41.0f / 255.0f green:41.0f / 255.0f blue:41.0f / 255.0f alpha:1.0f]CGColor], nil];
    [self.registerButton.layer insertSublayer:noBtnGradient atIndex:0];
    
    CALayer *noBtnLayer=self.registerButton.layer;
    [noBtnLayer setMasksToBounds:YES];
    [noBtnLayer setCornerRadius:5.0f];
    [noBtnLayer setBorderWidth:1.0f];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //check if the user is already logged in
    if ([PFUser currentUser])
    {
        //user exists
        //instantiate main controller
        [self performSegueWithIdentifier:@"login successful" sender:self];
    }
    else
    {
        //do nothing
        self.gestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
        [self.gestureRecognizer setNumberOfTapsRequired:1];
        [self.gestureRecognizer setCancelsTouchesInView:NO];
        [self.view addGestureRecognizer:self.gestureRecognizer];
    }
}

- (IBAction)login:(UIButton *)sender {
    
    if ([self.usernameField.text length] && [self.passwordField.text length])
    {
    [PFUser logInWithUsernameInBackground:[self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] password:[self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]  block:^(PFUser *user, NSError *error) {
        if (user)
        {

            //login successful
            //instantiate main controller
            UIStoryboard *main=self.storyboard;
            MainTabBarControllerViewController *mainCtrl=[main instantiateViewControllerWithIdentifier:@"MainTabBarControllerViewController"];
            [self presentViewController:mainCtrl animated:NO completion:nil];
        }
        else
        {
            //
            [[[UIAlertView alloc]initWithTitle:@"Login Unsuccessful" message:@"Please double check your user name and password and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        }
    }];
    }
}

-(void)tapped:(UITapGestureRecognizer*)sender
{
    CGPoint tap=[sender locationInView:self.view];
    if (!CGRectContainsPoint(self.usernameField.frame, tap) && !CGRectContainsPoint(self.passwordField.frame, tap))
    {
        [self.usernameField resignFirstResponder];
        [self.passwordField resignFirstResponder];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (IBAction)register:(UIButton *)sender {
    [self performSegueWithIdentifier:@"register" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
