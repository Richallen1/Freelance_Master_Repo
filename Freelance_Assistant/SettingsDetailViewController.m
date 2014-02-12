//
//  SettingsDetailViewController.m
//  Freelance_Assistant
//
//  Created by Richard Allen on 30/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import "SettingsDetailViewController.h"
#import "UserInfoViewController.h"
#import "AddressInfoViewController.h"
#import "EmailViewController.h"
#import "PaymentTermsViewController.h"
#import "BankDetailsViewController.h"
#import <Dropbox/Dropbox.h>
#import "User.h"
#import "AppDelegate.h"

@interface SettingsDetailViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UserNameStoreDelegate, UserAddressStoreDelegate, UserEmailStoreDelegate, UserPaymentTermsStoreDelegate, UserBankDetailsStoreDelegate>
{
    NSManagedObjectContext *context;
    User *user;
}
@property (nonatomic, readonly) DBAccountManager *accountManager;
@property (nonatomic, readonly) DBAccount *account;
@property (nonatomic, retain) DBDatastore *store;
@end

@implementation SettingsDetailViewController
@synthesize userNameLabel=_userNameLabel;
@synthesize userAddressLabel=_userAddressLabel;
@synthesize userEmailLabel=_userEmailLabel;
@synthesize paymentLabel=_paymentLabel;
@synthesize bankDetialsLabel=_bankDetialsLabel;


-(void)viewWillAppear:(BOOL)animated
{
    _dropboxSwitch.on = NO;
    [self CheckDropboxStatus];
    [self fillUserData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    
    user = [self findUser];
    
}
-(void)fillUserData
{
    if (user != NULL) {
        _userNameLabel.text = user.name;
        _userAddressLabel.text = user.address;
        _userEmailLabel.text = user.email;
        _paymentLabel.text = user.paymentTerms;
        
        if (![user.accountNumber isEqualToString:@""]) {
            _bankDetialsLabel.text = @"Stored";
        }
    }
}

-(User *)findUser
{    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSError *error = nil;
    NSArray *users = [context executeFetchRequest:request error:&error];
    if (users.count == 0) {
        User *newUser = nil;
        
        newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        return newUser;
        
    }
    return [users objectAtIndex:0];
    
    
}
-(void)storeUserName:(NSString *)name
{
    NSError *error;
    user.name = name;
    [context save:&error];
    [self fillUserData];
}
-(void)storeUserAddressWithAddress:(NSString *)addr1 andAddress2:(NSString *)addr2 andPostCode:(NSString *)postcode
{
    NSError *error;
    user.address = addr1;
    user.address = addr2;
    user.postcode = postcode;
    [context save:&error];
    [self fillUserData];
}
-(void)storeEmailName:(NSString *)email
{
    NSError *error;
    user.email = email;
    [context save:&error];
    [self fillUserData];
}
-(void)storeUserPaymentTerms:(NSString *)paymentTerms
{
    NSError *error;
    user.paymentTerms = paymentTerms;
    [context save:&error];
    [self fillUserData];
}
-(void)storeBankDetailsWithAccountNumber:(NSString *)accountNumber andSortCode:(NSString *)sortCode
{
    NSError *error;
    user.accountNumber = accountNumber;
    user.sortCode = sortCode;
    [context save:&error];
    [self fillUserData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setDelegate:self];
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 3) return nil;
    
    // By default, allow row to be selected
    return indexPath;
}
#pragma Dropbox Methods
-(void)CheckDropboxStatus
{
    if (![DBAccountManager sharedManager].linkedAccount)
    {
        NSLog(@"Account Not Linked");
        _dropboxSwitch.on = NO;
    }
    else
    {
        NSLog(@"Account Linked");
        _dropboxSwitch.on = YES;
    }
}

- (IBAction)dropboxChanged:(id)sender
{
    if ([_dropboxSwitch isOn]) {
        NSLog(@"Link Account");
        //Link Account
        [[DBAccountManager sharedManager] linkFromController:self];
        DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
        if (account) {
            DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
            [DBFilesystem setSharedFilesystem:filesystem];
        }
    }
    else
    {
        NSLog(@"Unlink Account");
        //Unlink Account
        [[[DBAccountManager sharedManager] linkedAccount] unlink];
        self.store = nil;
    }
}
- (IBAction)chooseLogoImage:(id)sender
{

}
@end
