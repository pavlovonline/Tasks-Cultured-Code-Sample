//
//  ResultLookupPlaceTableViewController.h
//  Vee Nation
//
//  Created by Anton Pavlov on 1/5/13.
//  Copyright (c) 2013 Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultLookupPlaceTableViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *resultsDictionary;
@property (nonatomic, strong) NSDictionary *resultsDictionaryFromAroundMe;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) NSDictionary *chosenPlace;
@property (nonatomic, strong) NSDictionary *referenceDictionary;

@end
