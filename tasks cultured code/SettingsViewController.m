//
//  SettingsViewController.m
//  tasks cultured code
//
//  Created by Anton Pavlov on 5/7/13.
//  Copyright (c) 2013 Anton Pavlov. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>

@interface SettingsViewController () <UIAlertViewDelegate>

@end

@implementation SettingsViewController
@synthesize autoEmailSwitch=_autoEmailSwitch;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //check if auto-emailing
    PFQuery *query=[PFUser query];
    [query whereKey:@"objectId" equalTo:[[PFUser currentUser]objectId]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object)
        {
            if (![object valueForKey:@"autoEmail"])
            {
                [self.autoEmailSwitch setOn:NO];
            }
            else if ([[object valueForKey:@"autoEmail"]isEqualToNumber:[NSNumber numberWithBool:YES]])
            {
                [self.autoEmailSwitch setOn:YES];
            }
            else if ([[object valueForKey:@"autoEmail"]isEqualToNumber:[NSNumber numberWithBool:NO]])
            {
                [self.autoEmailSwitch setOn:NO];
            }
        }
    }];
}

- (IBAction)switchAction:(UISwitch *)sender {
    if (sender.on==YES)
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
    else if (sender.on==NO)
    {
        //user wants autoemail
        PFQuery *query=[PFUser query];
        [query whereKey:@"objectId" equalTo:[[PFUser currentUser]objectId]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (object)
            {
                [object setValue:[NSNumber numberWithBool:NO] forKey:@"autoEmail"];
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                }];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];

            UILabel *logout=(UILabel*)[cell viewWithTag:1];
            if ([logout.text isEqualToString:@"Log Out"])
            {
                [[[UIAlertView alloc]initWithTitle:@"Log out?" message:@"Are you sure you want to log out" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil]show];
            }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle=[alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Yes"])
    {
        [PFUser logOut];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if ([buttonTitle isEqualToString:@"No"])
    {
        //do nothing
    }

}

@end
