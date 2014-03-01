//
//  UserInfoViewController.m
//  Freelance_assistant
//
//  Created by Rich Allen on 14/12/2013.
//  Copyright (c) 2013 Rich Allen. All rights reserved.
//

#import "UserInfoViewController.h"
#import "AppDelegate.h"
#import "User.h"

@interface UserInfoViewController ()
{
    NSManagedObjectContext *context;
}
@end

@implementation UserInfoViewController
@synthesize userFirstName=_userFirstName;
@synthesize userSurname=_userSurname;
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (IBAction)donButton:(id)sender
{
    NSString *nameStr = [NSString stringWithFormat:@"%@ %@",_userFirstName.text, _userSurname.text ];
    [self.delegate storeUserName:nameStr];

    if ([[[UIDevice currentDevice]model]  isEqual: @"iPhone"] || [[[UIDevice currentDevice]model]  isEqual: @"iPhone Simulator"]) {
        [self dismissModalViewControllerAnimated:YES];
    }
}
@end
