//
//  LoginViewController.h
//  tasks cultured code
//
//  Created by Anton Pavlov on 5/6/13.
//  Copyright (c) 2013 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end
