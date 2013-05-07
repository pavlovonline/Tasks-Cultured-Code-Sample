//
//  AddNewTaskViewController.h
//  tasks cultured code
//
//  Created by Anton Pavlov on 5/6/13.
//  Copyright (c) 2013 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewTaskViewController : UIViewController

@property (nonatomic, strong) UITextField *headingLabel;
@property (nonatomic, strong) UITextView *detailLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UILabel *location;
@property (nonatomic, strong) UIButton *addPhotoButton;
@property (nonatomic, strong) UIButton *addLocationButton;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIButton *addDateButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
