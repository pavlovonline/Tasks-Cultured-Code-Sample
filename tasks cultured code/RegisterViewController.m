//
//  RegisterViewController.m
//  tasks cultured code
//
//  Created by Anton Pavlov on 5/6/13.
//  Copyright (c) 2013 Anton Pavlov. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface RegisterViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;

@end

@implementation RegisterViewController
@synthesize usernameField=_usernameField;
@synthesize emailField=_emailField;
@synthesize passwordField=_passwordField;
@synthesize registerButton=_registerButton;
@synthesize cancelButton=_cancelButton;
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
    
    self.usernameField.delegate=self;
    self.passwordField.delegate=self;
    self.emailField.delegate=self;
    
    self.gestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    [self.gestureRecognizer setNumberOfTapsRequired:1];
    [self.gestureRecognizer setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:self.gestureRecognizer];
    
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundColor:[UIColor redColor]];
    [self.cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
    CAGradientLayer *noBtnGradient=[CAGradientLayer layer];
    noBtnGradient.frame=self.cancelButton.bounds;
    noBtnGradient.colors=[NSArray arrayWithObjects:(id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:41.0f / 255.0f green:41.0f / 255.0f blue:41.0f / 255.0f alpha:1.0f]CGColor], nil];
    [self.cancelButton.layer insertSublayer:noBtnGradient atIndex:0];
    
    CALayer *noBtnLayer=self.cancelButton.layer;
    [noBtnLayer setMasksToBounds:YES];
    [noBtnLayer setCornerRadius:5.0f];
    [noBtnLayer setBorderWidth:1.0f];
}

#pragma mark - textfield delegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (IBAction)register:(UIButton *)sender {
    
    if ([self.usernameField.text length] && [self.passwordField.text length] && [self.emailField.text length])
    {
        //all field filled in
        
    PFUser *user=[PFUser user];
        user.username=[self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        user.password=[self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        user.email=[self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded)
            {
            [[[UIAlertView alloc]initWithTitle:@"Registered Successfully!" message:@"You have registered successfully and can now use the info to log in." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
            [[[UIAlertView alloc]initWithTitle:@"Trouble Registering" message:@"Please check all the fields and your connection and try again" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
            }
        }];
        
    }
    else
    {
        [[[UIAlertView alloc]initWithTitle:@"Missing Field(s)" message:@"Please fill in all the info and try again" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil]show];
    }
}


- (IBAction)cancel:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tapped:(UITapGestureRecognizer*)sender
{
    CGPoint tap=[sender locationInView:self.view];
    if (!CGRectContainsPoint(self.usernameField.frame, tap) && !CGRectContainsPoint(self.passwordField.frame, tap) && !CGRectContainsPoint(self.emailField.frame, tap))
    {
        [self.usernameField resignFirstResponder];
        [self.emailField resignFirstResponder];
        [self.passwordField resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
