//
//  iPhoneClientDetailViewController.m
//  Freelance_Assistant
//
//  Created by Richard Allen on 26/01/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import "iPhoneClientDetailViewController.h"
#import "Client.h"
#import "AppDelegate.h"

@interface iPhoneClientDetailViewController ()<UITextFieldDelegate>
{
    NSManagedObjectContext *context;
  
}
@end

@implementation iPhoneClientDetailViewController
@synthesize firstNameField;
@synthesize lastNameField;
@synthesize companyField;
@synthesize address1Field;
@synthesize address2Field;
@synthesize cityField;
@synthesize countyField;
@synthesize zipField;
@synthesize countryField;
@synthesize emailField;
@synthesize phoneField;
@synthesize selectedClient;

-(void)setTextFieldDelegates
{
    firstNameField.delegate=self;
    lastNameField.delegate=self;
    companyField.delegate=self;
    address1Field.delegate=self;
    address2Field.delegate=self;
    cityField.delegate=self;
    countyField.delegate=self;
    zipField.delegate=self;
    countryField.delegate=self;
    emailField.delegate=self;
    phoneField.delegate=self;
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	//Core Data Context Declaration from App delegate shared context
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    
    if (selectedClient != NULL) {
        [self fillFieldsWithClientData:selectedClient];
        NSLog(@"FILL");
    }
    [self setTextFieldDelegates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateButton:(id)sender
{
    if (![emailField.text isEqualToString:@""] && (selectedClient == NULL) && ![emailField.text isEqualToString:@"[None]"]) {
        [self newClient];
        NSLog(@"1");
        
    }
    if (selectedClient != NULL && ![emailField.text isEqualToString:@""] && ![emailField.text isEqualToString:@"[None]"]) {
        [self saveClient];
        NSLog(@"2");
    }
    NSLog(@"3");
}

- (IBAction)deleteButton:(id)sender
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Client"];
    request.predicate = [NSPredicate predicateWithFormat:@"company = %@", selectedClient.company];
    NSError *error = nil;
    NSArray *clients = [context executeFetchRequest:request error:&error];
    
    if (clients.count > 0) {
        [context deleteObject:selectedClient];
    }
    
    firstNameField.text = @"";
    lastNameField.text = @"";
    companyField.text = @"";
    address1Field.text = @"";
    address2Field.text = @"";
    cityField.text = @"";
    countyField.text = @"";
    zipField.text = @"";
    phoneField.text = @"";
    emailField.text = @"";
    
    [context save:&error];
    [self.delegate tableViewReload];
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)saveClient
{
    selectedClient.firstName = self.firstNameField.text;
    selectedClient.lastName = self.lastNameField.text;
    selectedClient.company = self.companyField.text;
    selectedClient.address = self.address1Field.text;
    selectedClient.address2 = self.address2Field.text;
    selectedClient.city = self.cityField.text;
    selectedClient.state = self.countyField.text;
    selectedClient.zip = self.zipField.text;
    selectedClient.phone = self.phoneField.text;
    selectedClient.email = self.emailField.text;
    selectedClient.paymentTerms = @"30";
    
    if ([companyField.text isEqualToString:@""]) {
        NSString *companyStr = [NSString stringWithFormat:@"%@ %@",firstNameField.text, lastNameField.text];
        selectedClient.company = companyStr;
    }
    
    NSError *err;
    [context save:&err];
    [self.delegate tableViewReload];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)newClient
{
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
    [newClient setValue:self.address1Field.text forKey:@"address"];
    [newClient setValue:self.address2Field.text forKey:@"address2"];
    [newClient setValue:self.cityField.text forKey:@"city"];
    [newClient setValue:self.countyField.text forKey:@"state"];
    [newClient setValue:self.zipField.text forKey:@"zip"];
    [newClient setValue:self.phoneField.text forKey:@"phone"];
    [newClient setValue:self.emailField.text forKey:@"email"];
    [newClient setValue:@"30" forKey:@"paymentTerms"];
    
    NSError *err;
    if ([self checkClientForName:companyField.text] == true)
    {
        [context save:&err];
    }
    if (err) {
        NSLog(@"%@", err);
    }
}
-(void)fillFieldsWithClientData:(Client *)client
{
    firstNameField.text = selectedClient.firstName;
    lastNameField.text = selectedClient.lastName;
    companyField.text = selectedClient.company;
    address1Field.text = selectedClient.address;
    address2Field.text = selectedClient.address2;
    cityField.text = selectedClient.city;
    countyField.text = selectedClient.state;
    zipField.text = selectedClient.zip;
    countryField.text = selectedClient.zip;
    phoneField.text = selectedClient.phone;
    emailField.text = selectedClient.email;
}

#pragma Textfield Delegate and Amimation Methods
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField setReturnKeyType:UIReturnKeyDone];
    [self animateTextField: textField up: YES];
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    int movementDistance = [self getMovementDistanceForTextField:textField];
    const float movementDuration = 0.3f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
-(int)getMovementDistanceForTextField:(UITextField *)textField
{
    int returnValue = 0;
    
    if (textField == zipField) {
        returnValue = 20;
    }
    if (textField == countryField) {
        returnValue = 60;
    }
    if (textField == emailField) {
        returnValue = 90;
    }
    if (textField == phoneField) {
        returnValue = 150;
    }
    
    return returnValue;
}
#pragma Contact Importer
- (IBAction)importFromContact:(id)sender
{
    NSLog(@"sdsdsd");
    
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
    self.address1Field.text = [theDict objectForKey:(NSString *)kABPersonAddressStreetKey];
    self.address2Field.text = @"";
    self.cityField.text = [theDict objectForKey:(NSString *)kABPersonAddressCityKey];
    self.countyField.text = [theDict objectForKey:(NSString *)kABPersonAddressStateKey];
    self.zipField.text = [theDict objectForKey:(NSString *)kABPersonAddressZIPKey];
    self.phoneField.text = phone;
    self.emailField.text = email;
}

@end
