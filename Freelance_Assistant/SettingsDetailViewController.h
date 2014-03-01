//
//  SettingsDetailViewController.h
//  Freelance_Assistant
//
//  Created by Richard Allen on 30/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsDetailViewController : UITableViewController
//Section 1
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;

//Section 2
@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankDetialsLabel;


//Dropbox Stuff
@property (strong, nonatomic) IBOutlet UISwitch *dropboxSwitch;
- (IBAction)dropboxChanged:(id)sender;


@end
