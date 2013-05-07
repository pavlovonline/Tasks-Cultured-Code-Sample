//
//  ResultLookupPlaceTableViewController.m
//  Vee Nation
//
//  Created by Anton Pavlov on 1/5/13.
//  Copyright (c) 2013 Pavlov. All rights reserved.
//

#import "ResultLookupPlaceTableViewController.h"
#import <Parse/Parse.h>
#import "AddNewTaskViewController.h"

@interface ResultLookupPlaceTableViewController ()
@property (nonatomic, strong) NSNotification *notification;


@end

@implementation ResultLookupPlaceTableViewController
@synthesize resultsDictionary=_resultsDictionary;
@synthesize searchResults=_searchResults;
@synthesize chosenPlace=_chosenObject;
@synthesize resultsDictionaryFromAroundMe=_resultsDictionaryFromAroundMe;
@synthesize referenceDictionary=_referenceDictionary;
@synthesize notification=_notification;


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
    
    if (self.resultsDictionary)
    {
        NSArray *results=[self.resultsDictionary valueForKeyPath:@"results"];
        
        self.searchResults=results;
        
        self.referenceDictionary=self.resultsDictionary;
        
        NSLog(@"results dicitonary received: %@", results);
    }
    else if (self.resultsDictionaryFromAroundMe)
    {
        NSArray *results=[self.resultsDictionaryFromAroundMe valueForKeyPath:@"results"];
        
        self.searchResults=results;
        self.referenceDictionary=self.resultsDictionaryFromAroundMe;
    }
    
    if (![self.searchResults count])
    {
        [[[UIAlertView alloc]initWithTitle:@"No Results Found" message:@"Please Change Your Search Criteria and Try Again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
    }
    else
    {
        //need to query up google to get the website of a place
        
//        //base url string for google places API
//        NSString *urlAsString=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@ ",[self.referenceDictionary valueForKeyPath:@"results.reference"]];
//        
//        NSLog(@"[self. search results array %@",[[self.searchResults objectAtIndex:0]valueForKey:@"reference"]);
        
//        NSString *escapedString=[urlAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //create nsurl
//        NSURL *url=[NSURL URLWithString:escapedString];
//        
//        dispatch_queue_t jsonGetter=dispatch_queue_create("jsonGetter", NULL);
//        dispatch_async(jsonGetter, ^{
//            NSData *data=[[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil]dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *results;
//            NSError *error=nil;
//            if (data && self.cancelOperation!=[NSNumber numberWithBool:YES])
//            {
//                [timer invalidate];
//                results=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
//                NSLog(@"Results in json %@", results);
//                self.resultsDictionary=results;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self performSegueWithIdentifier:@"show place lookup results" sender:self];
//                    self.navigationItem.rightBarButtonItem=self.nextButton;
//                });
//                
//            }
        
    }


    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"placeResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    //check if there are results, if not, nonobtrusively display message
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell.textLabel setTextColor:[UIColor grayColor]];
    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    

    // Configure the cell...
    
    //used object from dictionary
    NSDictionary *usedObject=[self.searchResults objectAtIndex:indexPath.row];
    
    //nslog(@"used object in cell: %@", usedObject);
    
    if (self.resultsDictionary)
    {
    [cell.textLabel setText:[usedObject objectForKey:@"name"]];
    [cell.detailTextLabel setText:[usedObject objectForKey:@"formatted_address"]];
    }
    
    else if (self.resultsDictionaryFromAroundMe)
    {
        [cell.textLabel setText:[usedObject objectForKey:@"name"]];
        [cell.detailTextLabel setText:[usedObject objectForKey:@"vicinity"]];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    self.chosenPlace=[self.searchResults objectAtIndex:indexPath.row];
    if (self.resultsDictionaryFromAroundMe)
    {
        [self.chosenPlace setValue:[[self.searchResults objectAtIndex:indexPath.row] valueForKey:@"vicinity"] forKey:@"formatted_address"];
    }
    
    self.notification=[NSNotification notificationWithName:@"locationAdded" object:nil userInfo:self.chosenPlace];
    
    [[NSNotificationCenter defaultCenter]postNotification:self.notification];
    
    AddNewTaskViewController *ctrl=[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3];
    [self.navigationController popToViewController:ctrl animated:YES];
}


-(void) dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
