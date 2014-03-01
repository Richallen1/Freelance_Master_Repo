//
//  AddClientPopoverViewController.m
//  Freelance_Assistant
//
//  Created by Rich Allen on 27/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import "AddClientPopoverViewController.h"
#import "AppDelegate.h"

@interface AddClientPopoverViewController ()
{
    NSManagedObjectContext *context;
    NSArray *clientsArray;
}
@end

@implementation AddClientPopoverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addClient:(id)sender
{
    if ([self.addressField.text isEqualToString:@""] && [self.address2Field.text isEqualToString:@""] && [self.cityField.text isEqualToString:@""] && [self.stateField.text isEqualToString:@""] && [self.zipField.text isEqualToString:@""] && [self.phoneField.text isEqualToString:@""] && [self.emailField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You need to enter some info for a client before saving." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    else if ([self.emailField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter a user email." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
    
    BOOL companyCheck = [self checkClientForName:_companyField.text];
    
    if (companyCheck == true) {

    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Client" inManagedObjectContext:context];
    NSManagedObject *newClient = [[NSManagedObject alloc]initWithEntity:entityDesc insertIntoManagedObjectContext:context];
    
    [newClient setValue:self.firstNameField.text forKey:@"firstName"];
    [newClient setValue:self.lastNameField.text forKey:@"lastName"];
        if ([self.companyField.text isEqualToString:@""]) {
            NSString *string = [NSString stringWithFormat:@"%@ %@",self.firstNameField.text, self.lastNameField.text];
            [newClient setValue:string forKey:@"company"];
        }
        else
        {
            [newClient setValue:self.companyField.text forKey:@"company"];
        }
    [newClient setValue:self.addressField.text forKey:@"address"];
    [newClient setValue:self.address2Field.text forKey:@"address2"];
    [newClient setValue:self.cityField.text forKey:@"city"];
    [newClient setValue:self.stateField.text forKey:@"state"];
    [newClient setValue:self.zipField.text forKey:@"zip"];
    [newClient setValue:self.phoneField.text forKey:@"phone"];
    [newClient setValue:self.emailField.text forKey:@"email"];
    [newClient setValue:@"30" forKey:@"paymentTerms"];

    NSError *err;
    [context save:&err];
    
    if (err) {
        NSLog(@"%@", err);
    }
}
    [self.delegate done];
    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Done" message:@"Client Added!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
    [self removeKeyboard];
    
    }
    
}

- (IBAction)cancelClient:(id)sender
{
    [self.delegate done];
}

- (IBAction)showPicker:(id)sender
{
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentModalViewController:picker animated:YES];
}
- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
}


-(BOOL)checkClientForName:(NSString *)company
{
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Client"];
        request.predicate = [NSPredicate predicateWithFormat:@"company = %@", company];
        NSError *error = nil;
        NSArray *clients = [context executeFetchRequest:request error:&error];
        if ([clients count] == 0) {
            return true;
        }
        return false;
}
#pragma AdressBook Stuff
//Addressbook Stuff
- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    [self displayPerson:person];
    [self dismissModalViewControllerAnimated:YES];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)displayPerson:(ABRecordRef)person
{
    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSLog(@"Client Name: %@ %@",firstName, lastName);
    
    //Email Address
    NSString* email = nil;
    ABMultiValueRef emailAddresses = ABRecordCopyValue(person,
                                                       kABPersonEmailProperty);
    if (ABMultiValueGetCount(emailAddresses) > 0) {
        email = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(emailAddresses, 0);
    } else {
        email = @"[None]";
    }
    NSLog(@"Client Email: %@",email);
    CFRelease(emailAddresses);
    
    //Phone Number
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    NSLog(@"Client Phone: %@",phone);
    CFRelease(phoneNumbers);
    
    
    ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonAddressProperty);
    NSArray *theArray = (__bridge_transfer id)ABMultiValueCopyArrayOfAllValues(multi);
    
    // Figure out which values we want and store the index.
    const NSUInteger theIndex = 0;
    
    // Set up an NSDictionary to hold the contents of the array.
    NSDictionary *theDict = [theArray objectAtIndex:theIndex];
    

    NSLog(@"Client Street: %@",[theDict objectForKey:(NSString *)kABPersonAddressStreetKey]);
    NSLog(@"Client City: %@",[theDict objectForKey:(NSString *)kABPersonAddressCityKey]);
    NSLog(@"Client State: %@",[theDict objectForKey:(NSString *)kABPersonAddressStateKey]);
    NSLog(@"Client Zip: %@",[theDict objectForKey:(NSString *)kABPersonAddressZIPKey]);
    
    self.firstNameField.text = firstName;
    self.lastNameField.text = lastName;
    self.companyField.text = @"";
    self.addressField.text = [theDict objectForKey:(NSString *)kABPersonAddressStreetKey];
    self.address2Field.text = @"";
    self.cityField.text = [theDict objectForKey:(NSString *)kABPersonAddressCityKey];
    self.stateField.text = [theDict objectForKey:(NSString *)kABPersonAddressStateKey];
    self.zipField.text = [theDict objectForKey:(NSString *)kABPersonAddressZIPKey];
    self.phoneField.text = phone;
    self.emailField.text = email;
    
    
}
-(void)removeKeyboard
{
    [_firstNameField resignFirstResponder];
    [_lastNameField resignFirstResponder];
    [_companyField resignFirstResponder];
    [_addressField resignFirstResponder];
    [_address2Field resignFirstResponder];
    [_cityField resignFirstResponder];
    [_stateField resignFirstResponder];
    [_zipField resignFirstResponder];
    [_phoneField resignFirstResponder];
    [_countryField resignFirstResponder];
    [_emailField resignFirstResponder];
}

@end
