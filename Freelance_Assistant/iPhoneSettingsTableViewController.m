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
#import <Dropbox/Dropbox.h>
#import "User.h"
#import "AppDelegate.h"

@interface iPhoneSettingsTableViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UserNameStoreDelegate, UserAddressStoreDelegate, UserEmailStoreDelegate, UserPaymentTermsStoreDelegate, UserBankDetailsStoreDelegate>
{
    NSManagedObjectContext *context;
    User *user;
}
@property (nonatomic, readonly) DBAccountManager *accountManager;
@property (nonatomic, readonly) DBAccount *account;
@property (nonatomic, retain) DBDatastore *store;
@end

@implementation iPhoneSettingsTableViewController
@synthesize userNameLabel = _userNameLabel;
@synthesize userAddressLabel = _userAddressLabel;
@synthesize userEmailLabel = _userEmailLabel;
@synthesize paymentLabel = _paymentLabel;
@synthesize bankDetialsLabel = _bankDetialsLabel;
@synthesize dropboxSwitch = _dropboxSwitch;
@synthesize invoiceLogoButton = _invoiceLogoButton;
-(void)viewWillAppear:(BOOL)animated
{
    [self fillUserData];
}


#pragma Dropbox Methods
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
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

#pragma ViewController Life Cycle
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = UIColorFromRGB(0x64c3d9);
    self.tableView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    self.tabBarController.tabBar.backgroundColor = UIColorFromRGB(0x64c3d9);
    _dropboxSwitch.on = NO;
    [self CheckDropboxStatus];
    [self fillUserData];
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    
    user = [self findUser];
    
    
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
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
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"terms_segue"]){
        
    }
    else if ([segue.identifier isEqualToString:@"legal_segue"]){
        
    }
    else
    {
        NSLog(@"Delegate set");
        [segue.destinationViewController setDelegate:self];
    }
    
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
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
        if (user.invoiceLogo != NULL) {
            [_invoiceLogoButton setTitle:@"Change Image" forState:UIControlStateNormal];
        }
    }
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
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
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (IBAction)chooseLogoImage:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    

    [self presentViewController:picker animated:YES completion:NULL];
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSError *error;
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    user.invoiceLogo = imageData;
    [context save:&error];
    [self fillUserData];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)storeUserName:(NSString *)name
{
    NSError *error;
    user.name = name;
    [context save:&error];
    [self fillUserData];
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)storeUserAddressWithAddress:(NSString *)addr1 andAddress2:(NSString *)addr2 andPostCode:(NSString *)postcode
{
    NSError *error;
    user.address = addr1;
    user.city = addr2;
    user.postcode = postcode;
    [context save:&error];
    [self fillUserData];
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)storeEmailName:(NSString *)email
{
    NSError *error;
    user.email = email;
    [context save:&error];
    [self fillUserData];
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)storeUserPaymentTerms:(NSString *)paymentTerms
{
    NSError *error;
    user.paymentTerms = paymentTerms;
    [context save:&error];
    [self fillUserData];
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)storeBankDetailsWithAccountNumber:(NSString *)accountNumber andSortCode:(NSString *)sortCode
{
    NSError *error;
    user.accountNumber = accountNumber;
    user.sortCode = sortCode;
    [context save:&error];
    [self fillUserData];
}
@end
