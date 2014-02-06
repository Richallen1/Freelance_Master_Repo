//
//  iPhoneSettingsTableViewController.m
//  Freelance_Assistant
//
//  Created by Rich Allen on 18/01/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "iPhoneSettingsTableViewController.h"
#import "UserInfoViewController.h"
#import "AddressInfoViewController.h"
#import "EmailViewController.h"
#import "PaymentTermsViewController.h"
#import "BankDetailsViewController.h"


@interface iPhoneSettingsTableViewController ()

@end

@implementation iPhoneSettingsTableViewController
@synthesize userNameLabel=_userNameLabel;
@synthesize userAddressLabel=_userAddressLabel;
@synthesize userEmailLabel=_userEmailLabel;
@synthesize paymentLabel=_paymentLabel;
@synthesize bankDetialsLabel=_bankDetialsLabel;
@synthesize dropboxSwitch=_dropboxSwitch;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    _dropboxSwitch.on = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setDelegate:self];
}


@end
