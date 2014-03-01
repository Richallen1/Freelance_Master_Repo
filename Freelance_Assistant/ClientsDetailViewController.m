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
    UIImageView *imgView;
}
@end

@implementation ClientsDetailViewController
@synthesize firstName=_firstName;
@synthesize surname=_surname;
@synthesize company=_company;
@synthesize address=_address;
@synthesize address2=_address2;
@synthesize city=_city;
@synthesize state=_state;
@synthesize zip=_zip;
@synthesize phone=_phone;
@synthesize country=_country;
@synthesize email=_email;
@synthesize updateBtnProperty=_updateBtnProperty;
@synthesize deleteClientButton=_deleteClientButton;

-(void)checkForClient
{
   
    if (selectedClient == NULL) {        
        UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"noClient" ofType:@"png"]];
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 703, 768)];
        imgView.image = img;
        imgView.backgroundColor = [UIColor redColor];
        [self.view addSubview:imgView];
    }
    else
    {
        if (imgView) {
            [imgView removeFromSuperview];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    context = [appDelegate managedObjectContext];
    [self checkForClient];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateClient:(id)sender
{
    selectedClient.firstName = _firstName.text;
    selectedClient.lastName = _surname.text;
    selectedClient.company = _company.text;
    selectedClient.address = _address.text;
    selectedClient.address2 = _address2.text;
    selectedClient.city = _city.text;
    selectedClient.state = _state.text;
    selectedClient.zip = _zip.text;
    selectedClient.phone = _phone.text;
    selectedClient.email = _email.text;
    selectedClient.paymentTerms = @"30";
    
    NSError *err;
    [context save:&err];
    NSLog(@"%@", selectedClient);

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
    [self checkForClient];
}

@end
