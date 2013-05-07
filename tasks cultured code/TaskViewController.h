//
//  TaskViewController.h
//  tasks cultured code
//
//  Created by Anton Pavlov on 5/7/13.
//  Copyright (c) 2013 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface TaskViewController : UIViewController

@property (nonatomic, strong) PFObject *object; //model
@property (weak, nonatomic) IBOutlet UILabel *taskTitle;
@property (weak, nonatomic) IBOutlet UILabel *taskDate;
@property (weak, nonatomic) IBOutlet UIButton *taskLocation;
@property (weak, nonatomic) IBOutlet UITextView *taskNote;
@property (weak, nonatomic) IBOutlet PFImageView *taskPhoto;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;

@end
