//
//  iPhoneSettingsTableViewController.h
//  Freelance_Assistant
//
//  Created by Rich Allen on 18/01/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface iPhoneSettingsTableViewController : UITableViewController

//Section 1
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;

//Section 2
@property (weak, nonatomic) IBOutlet UILabel *paymentLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankDetialsLabel;
@property (strong, nonatomic) IBOutlet UIButton *invoiceLogoButton;


//Dropbox Stuff
@property (strong, nonatomic) IBOutlet UISwitch *dropboxSwitch;
- (IBAction)dropboxChanged:(id)sender;

- (IBAction)chooseLogoImage:(id)sender;

@end
