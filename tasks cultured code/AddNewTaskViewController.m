//
//  AddNewTaskViewController.m
//  tasks cultured code
//
//  Created by Anton Pavlov on 5/6/13.
//  Copyright (c) 2013 Anton Pavlov. All rights reserved.
//

#import "AddNewTaskViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>


@interface AddNewTaskViewController () <UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;
@property (nonatomic, strong) NSDate *dateForSaving;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) PFFile *pfImage;
@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) PFGeoPoint *placePoint;
@property (nonatomic, strong) NSString *placeAddress;
@property (nonatomic, strong) UIBarButtonItem *saveButton;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSString *currentEmail;

@end

@implementation AddNewTaskViewController
@synthesize headingLabel=_headingLabel;
@synthesize detailLabel=_detailLabel;
@synthesize photo=_photo;
@synthesize dateLabel=_dateLabel;
@synthesize location=_location;
@synthesize addPhotoButton=_addPhotoButton;
@synthesize addLocationButton=_addLocationButton;
@synthesize toolBar=_toolBar;
@synthesize addDateButton=_addDateButton;
@synthesize gestureRecognizer=_gestureRecognizer;
@synthesize dateForSaving=_dateForSaving;
@synthesize actionSheet=_actionSheet;
@synthesize pfImage=_pfImage;
@synthesize placeName=_placeName;
@synthesize placePoint=_placePoint;
@synthesize placeAddress=_placeAddress;
@synthesize saveButton=_saveButton;
@synthesize spinner=_spinner;
@synthesize currentEmail=_currentEmail;

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
    
//    self.toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//    [self.view addSubview:self.toolBar];
    
    //set up ui
    //title
    UILabel *headerText=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 15)];
    [headerText setText:@"Enter Task Title"];
    [self.view addSubview:headerText];
    
    //header label
    self.headingLabel=[[UITextField alloc]initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-20, 20)];
    [self.headingLabel setBackgroundColor:[UIColor lightGrayColor]];
    self.headingLabel.delegate=self;
    [self.view addSubview:self.headingLabel];
    
    //note title
    UILabel *detailText=[[UILabel alloc]initWithFrame:CGRectMake(10, 55, self.view.frame.size.width-20, 15)];
    [detailText setText:@"Add a note:"];
    [self.view addSubview:detailText];
    
    //note enter field
    self.detailLabel=[[UITextView alloc]initWithFrame:CGRectMake(10, 75, self.view.frame.size.width-20, 35)];
    [self.detailLabel setBackgroundColor:[UIColor lightGrayColor]];
    self.detailLabel.delegate=self;
    [self.view addSubview:self.detailLabel];
    
//date
    //button
    self.addDateButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.addDateButton setFrame:CGRectMake(10, 120, 120, 30)];
    [self.addDateButton addTarget:self action:@selector(showDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.addDateButton setTitle:@"Add Date" forState:UIControlStateNormal];
    [self.addDateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addDateButton setBackgroundColor:[UIColor redColor]];
    [self.addDateButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
    CAGradientLayer *noBtnGradient=[CAGradientLayer layer];
    noBtnGradient.frame=self.addDateButton.bounds;
    noBtnGradient.colors=[NSArray arrayWithObjects:(id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:41.0f / 255.0f green:41.0f / 255.0f blue:41.0f / 255.0f alpha:1.0f]CGColor], nil];
    [self.addDateButton.layer insertSublayer:noBtnGradient atIndex:0];
    
    CALayer *noBtnLayer=self.addDateButton.layer;
    [noBtnLayer setMasksToBounds:YES];
    [noBtnLayer setCornerRadius:5.0f];
    [noBtnLayer setBorderWidth:1.0f];
    [noBtnLayer setBorderColor:[[UIColor darkGrayColor]CGColor]];
    [self.view addSubview:self.addDateButton];
    
    //label
    self.dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(150, 120, 160, 20)];
    [self.dateLabel setBackgroundColor:[UIColor lightGrayColor]];
    [self.dateLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview: self.dateLabel];
    
    
    
//photo
    //button
    self.addPhotoButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.addPhotoButton setFrame:CGRectMake(10, 220, 120, 30)];
    [self.addPhotoButton addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.addPhotoButton setTitle:@"Add Photo" forState:UIControlStateNormal];
    [self.addPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addPhotoButton setBackgroundColor:[UIColor redColor]];
    [self.addPhotoButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
    CAGradientLayer *photoBtnGradient=[CAGradientLayer layer];
    photoBtnGradient.frame=self.addDateButton.bounds;
    photoBtnGradient.colors=[NSArray arrayWithObjects:(id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:41.0f / 255.0f green:41.0f / 255.0f blue:41.0f / 255.0f alpha:1.0f]CGColor], nil];
    [self.addPhotoButton.layer insertSublayer:photoBtnGradient atIndex:0];
    
    CALayer *photoBtnLayer=self.addPhotoButton.layer;
    [photoBtnLayer setMasksToBounds:YES];
    [photoBtnLayer setCornerRadius:5.0f];
    [photoBtnLayer setBorderWidth:1.0f];
    [photoBtnLayer setBorderColor:[[UIColor darkGrayColor]CGColor]];
    [self.view addSubview:self.addPhotoButton];
    
    //photo
    self.photo=[[UIImageView alloc]initWithFrame:CGRectMake(180, 190, 100, 100)];
    [self.view addSubview:self.photo];
    
    
//Location
    //button
    self.addLocationButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.addLocationButton setFrame:CGRectMake(10, 320, 120, 30)];
    [self.addLocationButton addTarget:self action:@selector(addLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.addLocationButton setTitle:@"Add Location" forState:UIControlStateNormal];
    [self.addLocationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addLocationButton setBackgroundColor:[UIColor redColor]];
    [self.addLocationButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    
    CAGradientLayer *locagionBtnGradient=[CAGradientLayer layer];
    locagionBtnGradient.frame=self.addLocationButton.bounds;
    locagionBtnGradient.colors=[NSArray arrayWithObjects:(id)[[UIColor colorWithRed:102.0f / 255.0f green:102.0f / 255.0f blue:102.0f / 255.0f alpha:1.0f] CGColor], (id)[[UIColor colorWithRed:41.0f / 255.0f green:41.0f / 255.0f blue:41.0f / 255.0f alpha:1.0f]CGColor], nil];
    [self.addLocationButton.layer insertSublayer:locagionBtnGradient atIndex:0];
    
    CALayer *locationBtnLayer=self.addLocationButton.layer;
    [locationBtnLayer setMasksToBounds:YES];
    [locationBtnLayer setCornerRadius:5.0f];
    [locationBtnLayer setBorderWidth:1.0f];
    [locationBtnLayer setBorderColor:[[UIColor darkGrayColor]CGColor]];
    [self.view addSubview:self.addLocationButton];
    
    //location field
    self.location=[[UILabel alloc] initWithFrame:CGRectMake(150, 310, 160, 45)];
    [self.location setBackgroundColor:[UIColor lightGrayColor]];
    [self.location setNumberOfLines:0];
    [self.location setLineBreakMode:NSLineBreakByWordWrapping];
    [self.location setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview: self.location];
    
    //gesture recognizer
    self.gestureRecognizer=[[UITapGestureRecognizer alloc]init];
    [self.gestureRecognizer addTarget:self action:@selector(tapped:)];
    [self.gestureRecognizer setNumberOfTapsRequired:1];
    [self.gestureRecognizer setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:self.gestureRecognizer];
    
    //register for notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationPosted:) name:@"locationAdded" object:nil];
    
    self.saveButton=[[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveTask:)];
    self.navigationItem.rightBarButtonItem=self.saveButton;

    
    //check if auto-emailing
    PFQuery *query=[PFUser query];
    [query whereKey:@"objectId" equalTo:[[PFUser currentUser]objectId]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object)
        {
            if (![object valueForKey:@"autoEmail"])
            {
            [[[UIAlertView alloc]initWithTitle:@"Email Reminders?" message:@"Would you like to be auto sent reminders for tasks? You can disable it later in settings." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil]show];
            }
            self.currentEmail=[object valueForKey:@"email"];
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Email Reminders?"])
    {
        NSString *buttonTitle=[alertView buttonTitleAtIndex:buttonIndex];
        
        if ([buttonTitle isEqualToString:@"Yes"])
        {
            //user wants autoemail
            PFQuery *query=[PFUser query];
            [query whereKey:@"objectId" equalTo:[[PFUser currentUser]objectId]];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (object)
                {
                    [object setValue:[NSNumber numberWithBool:YES] forKey:@"autoEmail"];
                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    }];
                }
            }];
        }
    }
}

#pragma mark - button methods
-(void)showDatePicker:(UIButton*)sender
{
    if ([sender.titleLabel.text isEqualToString:@"Add Date"])
    {
        self.datePicker.hidden=NO;
        [self.addDateButton setTitle:@"Done" forState:UIControlStateNormal];
        [self.addLocationButton setHidden:YES];
        [self.location setHidden:YES];
        [self.addPhotoButton setHidden:YES];
        [self.photo setHidden:YES];
        
        if (![self.dateLabel.text length])
        {
        NSDate *date=[NSDate date];
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"hh:mma MM/dd/yyyy"];
        NSString *dateString=[formatter stringFromDate:date];
        [self.dateLabel setText:dateString];
        }
        else
        {
            [self.dateLabel setText:@""];

        }
        
    }
    else if ([sender.titleLabel.text isEqualToString:@"Done"])
    {
        [self.datePicker setHidden:YES];
        [self.addLocationButton setHidden:NO];
        [self.location setHidden:NO];
        [self.addPhotoButton setHidden:NO];
        [self.photo setHidden:NO];
        [self.addDateButton setTitle:@"Add Date" forState:UIControlStateNormal];
    }

}


-(void)addLocation:(UIButton*)sender
{
    if ([self.location.text length])
    {
        [self.location setText:@""];
    }
    [self performSegueWithIdentifier:@"add location" sender:self];
}

-(void)notificationPosted:(NSNotification*)notification
{
    NSDictionary *dictionary=notification.userInfo;
    NSLog(@"dictionary %@",dictionary);
    
    self.placeAddress=[dictionary objectForKey:@"formatted_address"];
    self.placeName=[dictionary objectForKey:@"name"];
    self.placePoint=[PFGeoPoint geoPointWithLatitude:[[dictionary valueForKeyPath:@"geometry.location.lat"] doubleValue] longitude:[[dictionary valueForKeyPath:@"geometry.location.lon"] doubleValue]];
    
    [self.location setText:[NSString stringWithFormat:@"%@, %@", self.placeName, self.placeAddress]];
}

- (IBAction)addDate:(UIDatePicker *)sender {
    
    self.dateForSaving=[NSDate date];
    
    if ([self.datePicker isHidden]==NO)
    {
        self.dateForSaving=[sender date];
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"hh:mma MM/dd/yyyy"];
        NSString *dateString=[formatter stringFromDate:self.dateForSaving];
        [self.dateLabel setText:dateString];
    }
    else if ([self.datePicker isHidden]==YES)
    {
// do nothing
    }
}

#pragma mark - Photo Choosing
-(void)addPhoto:(UIButton*)sender
{
    self.actionSheet=[[UIActionSheet alloc]initWithTitle:@"Add Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
    
    if (self.photo.image!=nil)
    {
        [self.photo setImage:nil];
    }
        [self.actionSheet showFromTabBar:self.tabBarController.tabBar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.delegate=self;
    picker.allowsEditing=YES;

    
    NSString *buttonTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Camera"])
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
               [self presentViewController:picker animated:YES completion:nil];
        }
        else
        {
            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
               [self presentViewController:picker animated:YES completion:nil];
        }
    }
    else if ([buttonTitle isEqualToString:@"Photo Library"])
    {
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
           [self presentViewController:picker animated:YES completion:nil];
    }    
 
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *resizedImage;
    
    if ([[UIScreen mainScreen]scale]==1.0f)
        resizedImage=[self resizeImage:image toSize:650.0f];
    else
        resizedImage=[self resizeImage:image toSize:325.0f];
        
    self.pfImage=[PFFile fileWithData:UIImageJPEGRepresentation(resizedImage, 1.0)];
    [self.photo setImage:resizedImage];
    
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

-(UIImage*)resizeImage:(UIImage*)image toSize:(CGFloat)size
{
    //I may be getting an image that has width bigger than height
    CGFloat width=image.size.width;
    CGFloat height=image.size.height;
    
    if (width>height)
    {
        //we need to change dimensions appropriately to keep the aspect ratio
        
        CGImageRef cropped=CGImageCreateWithImageInRect([image CGImage], CGRectMake((0+width/2-height/2), 0, height, height));
        UIImage *croppedImage=[UIImage imageWithCGImage:cropped];
        
        CGSize newSize=CGSizeMake(size, size);
        NSLog(@"newSize w=%f, newSize h=%f", newSize.height, newSize.width);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [croppedImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
        
    }
    else if (height>width)
    {
        
        CGImageRef cropped=CGImageCreateWithImageInRect([image CGImage], CGRectMake((0+height/2-width/2), 0, width, width));
        UIImage *croppedImage=[UIImage imageWithCGImage:cropped];
        
        CGSize newSize=CGSizeMake(size, size);
        NSLog(@"newSize w=%f, newSize h=%f", newSize.height, newSize.width);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [croppedImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    else
    {
        CGSize newSize=CGSizeMake(size, size);
        NSLog(@"newSize w=%f, newSize h=%f", newSize.height, newSize.width);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
}


#pragma mark - Gesture Recognizer
-(void)tapped:(UITapGestureRecognizer *)recognizer
{
    CGPoint tap=[recognizer locationInView:self.view];
    
    if (!CGRectContainsPoint(self.headingLabel.frame, tap) && !CGRectContainsPoint(self.detailLabel.frame, tap))
    {
        [self.headingLabel resignFirstResponder];
        [self.detailLabel resignFirstResponder];
    }
}

-(void)saveTask:(UIBarButtonItem *)sender
{
    self.spinner=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.spinner setHidden:NO];
    [self.spinner startAnimating];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:self.spinner];
    
    if ([self.headingLabel.text length])
    {
        //can proceed
        
        //create object
        PFObject *taskObject=[PFObject objectWithClassName:@"Task"];
        [taskObject setValue:[self.headingLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"taskTitle"];
        [taskObject setValue:[NSNumber numberWithBool:NO] forKey:@"complete"];
        
        if ([self.detailLabel.text length])
        [taskObject setValue:[self.detailLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"taskNote"];
        
        if (self.photo.image !=nil)
            [taskObject setObject:self.pfImage forKey:@"image"];
        
            if ([self.dateLabel.text length])
        {   if (self.dateForSaving==nil)
            {
                self.dateForSaving=[NSDate date];
            }
            [taskObject setObject:self.dateForSaving forKey:@"date"];
        }
        
        if ([self.location.text length])
        {
            [taskObject setObject:[self.location.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"place"];
            [taskObject setObject:self.placePoint forKey:@"location"];
            [taskObject setValue:self.placeAddress forKey:@"address"];
            [taskObject setValue:self.placeName forKey:@"placeName"];
        }
        
        
        
        [taskObject setObject:[PFUser currentUser] forKey:@"user"];
        
        //set up acl
        PFACL *acl=[PFACL ACLWithUser:[PFUser currentUser]];
        [acl setPublicReadAccess:YES];
        [acl setPublicWriteAccess:NO];
        taskObject.ACL=acl;
        
        //save
        [taskObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded)
            {
                //check if auto-emailing
                PFQuery *query=[PFUser query];
                [query whereKey:@"objectId" equalTo:[[PFUser currentUser]objectId]];
                 [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    if (object)
                    {
                        if ([[object valueForKey:@"autoEmail"]isEqualToNumber:[NSNumber numberWithBool:YES]])
                        {
                          
                        MFMailComposeViewController *mailComposer=[[MFMailComposeViewController alloc]init];
                        mailComposer.mailComposeDelegate=self;
                        [mailComposer setSubject:[NSString stringWithFormat:@"Reminder! %@", self.headingLabel.text]];
                        [mailComposer setToRecipients:[NSArray arrayWithObject:[[PFUser currentUser]valueForKey:@"email"]]];
                        if (self.photo.image !=nil)
                        {
                            [mailComposer addAttachmentData:UIImageJPEGRepresentation(self.photo.image, 1) mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"image%@", [NSDate date]]];
                        }

                        [mailComposer setMessageBody:[NSString stringWithFormat:@"%@", self.headingLabel.text] isHTML:NO];
                       
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self presentViewController:mailComposer animated:YES completion:^{
                            }];

                        });
                        
                            
                        }
                        else
                        {
                            [self.navigationController popToRootViewControllerAnimated:YES ];
                        }
                    }
                }];
                
                [self.spinner setHidden:YES];
                [self.spinner stopAnimating];
                self.navigationItem.rightBarButtonItem=self.saveButton;
                
                //pop controller
            }
            else
            {
                [[[UIAlertView alloc]initWithTitle:@"Connection Issues" message:@"Looks like there are connection issues. Please check your network and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
                
                
                [self.spinner setHidden:YES];
                [self.spinner stopAnimating];
                self.navigationItem.rightBarButtonItem=self.saveButton;
            }
        }];
    }
    else
    {
        [[[UIAlertView alloc]initWithTitle:@"No title" message:@"Please enter a title for the task." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
        
        
        [self.spinner setHidden:YES];
        [self.spinner stopAnimating];
        self.navigationItem.rightBarButtonItem=self.saveButton;
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    if (error && result==MFMailComposeResultFailed)
    {
        [[[UIAlertView alloc]initWithTitle:@"Couldn't Send Message" message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
    else if (!error && result==MFMailComposeResultSent)
    {
//        [[[UIAlertView alloc]initWithTitle:@"Message Sent" message:@"Your message has been sent successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
    else
    {
        
    }
}

-(void)dismissAfterEmail
{
    [self.navigationController popToRootViewControllerAnimated:YES];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
