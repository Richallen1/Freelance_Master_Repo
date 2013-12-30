//
//  ClientPickerPopoverViewController.m
//  Freelance_Assistant
//
//  Created by Richard Allen on 28/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import "ClientPickerPopoverViewController.h"
#import "AppDelegate.h"
#import "Client.h"

@interface ClientPickerPopoverViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSManagedObjectContext *context;
}
@end

@implementation ClientPickerPopoverViewController
@synthesize delegate=_delegate;
@synthesize clients=_clients;
@synthesize clientPicker=_clientPicker;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    [self getClients];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getClients
{
    //Get Client Data from CoreData
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"Client" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:desc];
    
    NSError *error;
    NSArray *data = [context executeFetchRequest:request error:&error];
    
    NSMutableArray *clientsLocal = [[NSMutableArray alloc]init];
    
    for (Client *client in data) {
        [clientsLocal addObject:client.company];
    }
    self.clients = [[NSArray alloc]initWithArray:clientsLocal];
    return;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [self.clients count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [self.clients objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    NSLog(@"Selected Row %d", row);
    NSString *clientFromPicker = [[NSString alloc]init];
    clientFromPicker = [self.clients objectAtIndex:row];
    [self.delegate PassClientFromPickerWithClient:clientFromPicker withSender:self];
    
    
    //  [self getClientForName:[self.clients objectAtIndex:row]];
    
}

@end
