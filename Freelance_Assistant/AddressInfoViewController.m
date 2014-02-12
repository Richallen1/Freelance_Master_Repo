//
//  AddressInfoViewController.m
//  Freelance_assistant
//
//  Created by Rich Allen on 14/12/2013.
//  Copyright (c) 2013 Rich Allen. All rights reserved.
//

#import "AddressInfoViewController.h"

@interface AddressInfoViewController ()

@end

@implementation AddressInfoViewController
@synthesize address1=_address1;
@synthesize address2=_address2;
@synthesize postCode=_postCode;
@synthesize delegate = _delegate;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)doneButton:(id)sender
{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:_address1.text forKey:@"User_Address_1"];
//    [defaults setObject:_address2.text forKey:@"User_Address_2"];
//    [defaults setObject:_postCode.text forKey:@"User_Postcode"];
//    [defaults synchronize];

    [self.delegate storeUserAddressWithAddress:_address1.text andAddress2:_address2.text andPostCode:_postCode.text];
    
    if ([[[UIDevice currentDevice]model]  isEqual: @"iPhone"] || [[[UIDevice currentDevice]model]  isEqual: @"iPhone Simulator"]) {
        [self dismissModalViewControllerAnimated:YES];
    }
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
@end
