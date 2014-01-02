//
//  ClientsDetailViewController.m
//  Freelance_Assistant
//
//  Created by Rich Allen on 26/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import "ClientsDetailViewController.h"
#import "AppDelegate.h"
#import "ClientsSideViewController.h"
#import "Client.h"

@interface ClientsDetailViewController ()<clientSideViewController, UIPopoverControllerDelegate, UITextFieldDelegate>
{
    NSManagedObjectContext *context;
    Client *selectedClient;
}
@end

@implementation ClientsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    context = [appDelegate managedObjectContext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateClient:(id)sender
{
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Client" inManagedObjectContext:context];
        NSManagedObject *newClient = [[NSManagedObject alloc]initWithEntity:entityDesc insertIntoManagedObjectContext:context];
    
        [newClient setValue:self.firstName.text forKey:@"firstName"];
        [newClient setValue:self.surname.text forKey:@"lastName"];
        [newClient setValue:self.company.text forKey:@"company"];
        [newClient setValue:self.address.text forKey:@"address"];
        [newClient setValue:self.address2.text forKey:@"address2"];
        [newClient setValue:self.city.text forKey:@"city"];
        [newClient setValue:self.state.text forKey:@"state"];
        [newClient setValue:self.zip.text forKey:@"zip"];
        [newClient setValue:self.phone.text forKey:@"phone"];
        [newClient setValue:self.email.text forKey:@"email"];
    
        NSError *err;
        [context save:&err];

}

- (IBAction)deleteClient:(id)sender
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Client"];
    request.predicate = [NSPredicate predicateWithFormat:@"company = %@", selectedClient.company];
    NSError *error = nil;
    NSArray *clients = [context executeFetchRequest:request error:&error];
    
    if (clients.count > 0) {
        [context deleteObject:selectedClient];
    }
    
    self.firstName.text = @"";
    self.surname.text = @"";
    self.company.text = @"";
    self.address.text = @"";
    self.address2.text = @"";
    self.city.text = @"";
    self.state.text = @"";
    self.zip.text = @"";
    self.phone.text = @"";
    self.email.text = @"";
    
    [self.delgate tableViewReload];
}
-(void)fillDetailViewWithClientData:(Client *)client fromSender:(id)sender
{
    NSLog(@"%@", client);
    if (client != nil) {
        
        selectedClient = client;

    self.firstName.text = client.firstName;
    self.surname.text = client.lastName;
    self.company.text = client.company;
    self.address.text = client.address;
    self.address2.text = client.address2;
    self.city.text = client.city;
    self.state.text = client.state;
    self.zip.text = client.zip;
    self.phone.text = client.phone;
    self.email.text = client.email;
    }
    self.delgate = sender;
    
}

@end
