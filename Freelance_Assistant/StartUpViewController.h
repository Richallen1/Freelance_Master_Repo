//
//  StartUpViewController.h
//  Freelance_Assistant
//
//  Created by Richard Allen on 31/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StartUpViewController;
@protocol StartUpDelegate
@optional
- (void)Done;


@end

@interface StartUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *postField;
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) id <StartUpDelegate> delegate;

- (IBAction)doneButton:(id)sender;
- (IBAction)whyEmailAlert:(id)sender;

@end
