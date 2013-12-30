//
//  AddInvoicePopoverViewController.m
//  Freelance_Assistant
//
//  Created by Richard Allen on 28/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import "AddInvoicePopoverViewController.h"
#import "AppDelegate.h"
#import "Client.h"
#import "Invoice_charges.h"

@interface AddInvoicePopoverViewController ()
{
    NSManagedObjectContext *context;
}
@end

@implementation AddInvoicePopoverViewController

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

- (IBAction)createButton:(id)sender
{
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Invoice" inManagedObjectContext:context];
    NSManagedObject *newInvoice = [[NSManagedObject alloc]initWithEntity:entityDesc insertIntoManagedObjectContext:context];
    
    //Get Date Info
    NSDate *now = [[NSDate alloc] init];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"dd/MM/yyyy"];
	NSString *todaysDate = [dateFormat stringFromDate:now];
    
    Client *client = nil;
    Invoice_charges *charges = nil;
    
	
    [newInvoice setValue:todaysDate forKey:@"date"];
    [newInvoice setValue:self.projectNameField.text forKey:@"projectName"];
    [newInvoice setValue:self.invoiceNumberField.text forKey:@"invoiceNumber"];
    [newInvoice setValue:client forKey:@"clientForInvoice"];
    [newInvoice setValue:charges forKey:@"invoice_charges"];
    
    NSError *err;
    [context save:&err];
    
    if (err) {
        NSLog(@"%@", err);
    }

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invoice Created" message:@"Your Invoice has been created. Please now fill in the details." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
    [self.delegate InvoiceStarted];
}
@end
