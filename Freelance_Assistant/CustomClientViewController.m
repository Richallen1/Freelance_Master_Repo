//
//  CustomClientViewController.m
//  Freelance_Assistant
//
//  Created by Richard Allen on 26/01/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import "CustomClientViewController.h"
#import "Client.h"
#import "AppDelegate.h"

@interface CustomClientViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSManagedObjectContext *context;
    NSMutableArray *clients;
    NSString *clientSelected;
}
@end

@implementation CustomClientViewController

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
    [self FetchClientData];
}

-(void)FetchClientData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Client" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"ERROR: %@", error);
    }
    clients = [[NSMutableArray alloc]init];
    for (Client *cl in fetchedObjects) {
        [clients addObject:cl.company];
    }
    NSLog(@"%lu", (unsigned long)[clients count]);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    
    return [clients count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [clients objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    NSLog(@"Selected Row %d", row);
    NSString *clientFromPicker = [[NSString alloc]init];
    clientFromPicker = [clients objectAtIndex:row];
    clientSelected = clientFromPicker;
    
}
- (IBAction)doneButton:(id)sender
{
    [self.delegate ClientSelected:clientSelected];
}

@end
