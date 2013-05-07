//
//  MainTasksTableviewController.h
//  tasks cultured code
//
//  Created by Anton Pavlov on 5/6/13.
//  Copyright (c) 2013 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MainTasksTableviewController : PFQueryTableViewController

@property (nonatomic, strong) PFObject *selectedObject;

@end
