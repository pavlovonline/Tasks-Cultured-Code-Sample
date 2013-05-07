//
//  LookupAddPlaceViewController.h
//  Vee Nation
//
//  Created by Anton Pavlov on 1/5/13.
//  Copyright (c) 2013 Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookupAddPlaceViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *showAroundMeButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end
