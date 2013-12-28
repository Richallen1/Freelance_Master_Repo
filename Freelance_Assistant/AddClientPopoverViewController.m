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
    BOOL companyCheck = [self checkClientForName:_companyField.text];
    
    if (companyCheck == true) {

    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Client" inManagedObjectContext:context];
    NSManagedObject *newClient = [[NSManagedObject alloc]initWithEntity:entityDesc insertIntoManagedObjectContext:context];
    
    [newClient setValue:self.firstNameField.text forKey:@"firstName"];
    [newClient setValue:self.lastNameField.text forKey:@"lastName"];
    [newClient setValue:self.companyField.text forKey:@"company"];
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

}

- (IBAction)cancelClient:(id)sender
{
    [self.delegate done];
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
@end
