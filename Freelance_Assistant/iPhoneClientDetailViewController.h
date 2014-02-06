//
//  iPhoneClientDetailViewController.h
//  Freelance_Assistant
//
//  Created by Richard Allen on 26/01/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Client.h"
#import <AddressBookUI/AddressBookUI.h>

@protocol iPhoneClientDetailDelegate
@optional
-(void)tableViewReload;
@end

@interface iPhoneClientDetailViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *companyField;
@property (weak, nonatomic) IBOutlet UITextField *address1Field;
@property (weak, nonatomic) IBOutlet UITextField *address2Field;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *countyField;
@property (weak, nonatomic) IBOutlet UITextField *zipField;
@property (weak, nonatomic) IBOutlet UITextField *countryField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (strong, nonatomic) Client *selectedClient;
@property (weak, nonatomic) id <iPhoneClientDetailDelegate> delegate;

- (IBAction)updateButton:(id)sender;
- (IBAction)deleteButton:(id)sender;
- (IBAction)importFromContact:(id)sender;


@end
