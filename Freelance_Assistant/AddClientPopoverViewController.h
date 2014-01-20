//
//  AddClientPopoverViewController.h
//  Freelance_Assistant
//
//  Created by Rich Allen on 27/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@protocol addClientDelegate

-(void)done;

@end


@interface AddClientPopoverViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *companyField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextField *address2Field;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *stateField;
@property (weak, nonatomic) IBOutlet UITextField *zipField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *countryField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

@property (nonatomic, weak) id <addClientDelegate> delegate;
- (IBAction)addClient:(id)sender;
- (IBAction)cancelClient:(id)sender;
- (IBAction)showPicker:(id)sender;



@end
