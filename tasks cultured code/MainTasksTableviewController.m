//
//  MainTasksTableviewController.m
//  tasks cultured code
//
//  Created by Anton Pavlov on 5/6/13.
//  Copyright (c) 2013 Anton Pavlov. All rights reserved.
//

#import "MainTasksTableviewController.h"
#import "TaskViewController.h"

@interface MainTasksTableviewController ()

@property (nonatomic, strong) UIBarButtonItem *addTaskButton;

@end

@implementation MainTasksTableviewController
@synthesize addTaskButton=_addTaskButton;
@synthesize selectedObject=_selectedObject;

-(void)viewDidLoad
{
    [super viewDidLoad];

    //add barbuttonitem
    self.addTaskButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNew:)];
    self.navigationItem.rightBarButtonItem=self.addTaskButton;
    
    NSLog(@"pfuser %@", [PFUser currentUser]);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadObjects];
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // This table displays items in the Todo class
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query whereKey:@"complete" equalTo:[NSNumber numberWithBool:NO]];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

-(void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    
       UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tasks"];
    
    //determine the height of title text
    CGFloat expTitleHeight=0.0f;
        //set proper size of the detail label
    CGSize titleSize=CGSizeMake(240, FLT_MAX);
    CGSize expectedTitleSize=[[NSString stringWithFormat:@"%@", [object valueForKey:@"taskTitle"]] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:titleSize lineBreakMode:NSLineBreakByWordWrapping];
    expTitleHeight=expectedTitleSize.height;
    
    //button
    UIButton *doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setFrame:CGRectMake(10, 10, 50, 50)];
    [doneButton setBackgroundColor:[UIColor grayColor]];
    [doneButton setTitle:@">>" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneTask:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:doneButton];
    
    //title
    UILabel *heading=[[UILabel alloc]initWithFrame:CGRectMake(70, 10, 260, expTitleHeight+5)];
    [heading setNumberOfLines:0];
    [heading setFont:[UIFont boldSystemFontOfSize:15]];
    [heading setLineBreakMode:NSLineBreakByWordWrapping];
    [heading setFont:[UIFont systemFontOfSize:15]];
    [cell addSubview:heading];
    
    //date
    //determine the height of date text
    CGFloat expDateHeight=0.0f;
    //set proper size of the detail label
    CGSize dateSize=CGSizeMake(180, FLT_MAX);
    CGSize expectedDateSize=[[NSString stringWithFormat:@"%@", [object valueForKey:@"date"]] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:dateSize lineBreakMode:NSLineBreakByWordWrapping];
    expDateHeight=expectedDateSize.height;
    
    //date 
    UILabel *date=[[UILabel alloc]initWithFrame:CGRectMake(70, 15+expTitleHeight, 180, expDateHeight)];
    [date setNumberOfLines:0];
    [date setTextColor:[UIColor grayColor]];
    [date setFont:[UIFont systemFontOfSize:12]];
    [cell addSubview:date];
    
    //note
    //determine the height of note text
    CGFloat expNoteHeight=0.0f;
    //set proper size of the detail label
    CGSize noteSize=CGSizeMake(180, FLT_MAX);
    CGSize expectedNoteSize=[[NSString stringWithFormat:@"%@", [object valueForKey:@"taskNote"]] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:noteSize lineBreakMode:NSLineBreakByWordWrapping];
    expNoteHeight=expectedNoteSize.height;
    
    UILabel *note=[[UILabel alloc]initWithFrame:CGRectMake(70, 15+expTitleHeight+expDateHeight, 200, expNoteHeight)];
    [note setNumberOfLines:0];
    [note setTextColor:[UIColor lightGrayColor]];
    [note setFont:[UIFont systemFontOfSize: 12]];
    [note setLineBreakMode:NSLineBreakByWordWrapping];
    [note setFont:[UIFont systemFontOfSize:15]];
    [cell addSubview:note];
    
    //location
    //determine the height of note text
    CGFloat expLocationHeight=0.0f;
    //set proper size of the detail label
    CGSize locationSize=CGSizeMake(180, FLT_MAX);
    CGSize expectedLocationSize=[[NSString stringWithFormat:@"%@", [object valueForKey:@"place"]] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:locationSize lineBreakMode:NSLineBreakByWordWrapping];
    expLocationHeight=expectedLocationSize.height;
    
    UILabel *location=[[UILabel alloc]initWithFrame:CGRectMake(70, 15+expTitleHeight+expDateHeight+expNoteHeight, 180, expLocationHeight)];
    [location setNumberOfLines:0];
    [location setLineBreakMode:NSLineBreakByWordWrapping];
    [location setFont:[UIFont systemFontOfSize:12]];
    [location setTextColor:[UIColor lightGrayColor]];
    [cell addSubview:location];
    
    
    //photo
    PFImageView *photo=[[PFImageView alloc]initWithFrame:CGRectMake(260, 25+expTitleHeight, 50, 50)];
    [cell addSubview:photo];
    
    //setup

    [heading setText:[object valueForKey:@"taskTitle"]];
    
    if ([object valueForKey:@"date"])
    {
        NSDate *dateValue=[object valueForKey:@"date"];
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM/dd/yyyy, hh:mm a"];
        [date setText:[NSString stringWithFormat:@"Due on %@", [formatter stringFromDate:dateValue]]];
    }
    
    if ([object valueForKey:@"taskNote"])
    {
        [note setText:[object valueForKey:@"taskNote"]];
    }
    
    if ([object valueForKey:@"location"])
    {
        [location setText:[NSString stringWithFormat:@"At location: %@",[object valueForKey:@"place"]]];
    }
    
    if ([object valueForKey:@"image"])
    {
        photo.file=[object valueForKey:@"image"];
        [photo loadInBackground];
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object=[self.objects objectAtIndex:indexPath.row];
    
    CGFloat expNoteHeight=0.0f;
    CGFloat expTitleHeight=0.0f;
    CGFloat expLocationHeight=0.0f;
    CGFloat expDateHeight=0.0f;


    //determine the height of title text
    //set proper size of the detail label
    CGSize titleSize=CGSizeMake(260, FLT_MAX);
    CGSize expectedTitleSize=[[NSString stringWithFormat:@"%@", [object valueForKey:@"taskTitle"]] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:titleSize lineBreakMode:NSLineBreakByWordWrapping];
    expTitleHeight=expectedTitleSize.height;
    
    if ([object valueForKey:@"date"])
    {
        //date
        //determine the height of date text
        //set proper size of the detail label
        CGSize dateSize=CGSizeMake(180, FLT_MAX);
        CGSize expectedDateSize=[[NSString stringWithFormat:@"%@", [object valueForKey:@"date"]] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:dateSize lineBreakMode:NSLineBreakByWordWrapping];
        expDateHeight=expectedDateSize.height;
    }
    
    if ([object valueForKey:@"taskNote"])
    {
        //determine the height of note text
        //set proper size of the detail label
        CGSize noteSize=CGSizeMake(180, FLT_MAX);
        CGSize expectedNoteSize=[[NSString stringWithFormat:@"%@", [object valueForKey:@"taskNote"]] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:noteSize lineBreakMode:NSLineBreakByWordWrapping];
        expNoteHeight=expectedNoteSize.height;
    }
    
    if ([object valueForKey:@"location"])
    {
        //location
        //determine the height of note text
        //set proper size of the detail label
        CGSize locationSize=CGSizeMake(180, FLT_MAX);
        CGSize expectedLocationSize=[[NSString stringWithFormat:@"%@", [object valueForKey:@"location"]] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:locationSize lineBreakMode:NSLineBreakByWordWrapping];
        expLocationHeight=expectedLocationSize.height;
    }

    CGFloat imageCheck=expTitleHeight+expDateHeight+expNoteHeight+expLocationHeight+50;
    
    if([object valueForKey:@"image"])
    {
        if (imageCheck<100)
            imageCheck=100.0f;
    }
    
    return imageCheck;
}

#pragma mark-done button
-(void)doneTask:(UIButton*)sender
{
    PFTableViewCell *cell=(PFTableViewCell*)[sender superview];
    NSIndexPath *indexPath=[self.tableView indexPathForCell:cell];
    PFObject *object=[self.objects objectAtIndex:indexPath.row];
    
    [cell setBackgroundColor:[UIColor grayColor]];
    
    PFQuery *query=[PFQuery queryWithClassName:@"Task"];
    [query whereKey:@"objectId" equalTo:[object objectId]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *objectFound, NSError *error) {
        if (objectFound)
        {
            [objectFound setValue:[NSNumber numberWithBool:YES] forKey:@"complete"];
            [objectFound saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            }];
            [self loadObjects];
        }
        else
        {
            [cell setBackgroundColor:[UIColor whiteColor]];

        }
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedObject=[self.objects objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"show task" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show task"])
    {
        [segue.destinationViewController setObject:self.selectedObject];
    }
}

- (void)addNew:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"add new task" sender:self];
}

@end
