//
//  SettingsDetailViewController.m
//  Freelance_Assistant
//
//  Created by Richard Allen on 30/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import "SettingsDetailViewController.h"

@interface SettingsDetailViewController ()

@end

@implementation SettingsDetailViewController
@synthesize userNameLabel=_userNameLabel;
@synthesize userAddressLabel=_userAddressLabel;
@synthesize userEmailLabel=_userEmailLabel;
@synthesize paymentLabel=_paymentLabel;
@synthesize bankDetialsLabel=_bankDetialsLabel;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    _userNameLabel.text  = [defaults objectForKey:@"User_Name"];
    _userAddressLabel.text = [defaults objectForKey:@"User_Address_1"];
    _userEmailLabel.text = [defaults objectForKey:@"User_Email"];

    if ([defaults objectForKey:@"inv_term_period"] != NULL) {
        NSString *paymentTerms = [NSString stringWithFormat:@"%@ Days",[defaults objectForKey:@"inv_term_period"]];
        _paymentLabel.text = paymentTerms;
    }
    if ([defaults objectForKey:@"Bank_Details_Status"]) {
        _bankDetialsLabel.text = @"Detials Stored";
    }
    _bankDetialsLabel.text = @"None Stored";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
