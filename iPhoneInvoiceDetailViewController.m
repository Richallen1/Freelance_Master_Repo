//
//  iPhoneInvoiceDetailViewController.m
//  Freelance_Assistant
//
//  Created by Richard Allen on 20/01/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import "iPhoneInvoiceDetailViewController.h"
#import "AppDelegate.h"
#import "Client.h"
#import "Invoice_charges.h"

@interface iPhoneInvoiceDetailViewController ()
{
    NSMutableArray *invoiceRowObjects;
    NSManagedObjectContext *context;
}
@end

@implementation iPhoneInvoiceDetailViewController

@synthesize clientTextField=_clientTextField;
@synthesize projectNameField=_projectNameField;
@synthesize invoiceNumberField=_invoiceNumberField;
@synthesize chragesTableView=_chargesTableView;
@synthesize subTotalLabel=_subTotalLabel;
@synthesize vatLabel=_vatLabel;
@synthesize totalLabel=_totalLabel;
@synthesize selectedInvoice;

- (void)viewDidLoad
{
    [super viewDidLoad];
	//Core Data Context Declaration from App delegate shared context
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
}
#pragma Core Data
/**********************************************************
 Method:(void)deleteInvoiceWithNumber:(NSString *)invNumber
 Description:Deletes a invoice for a given invoice number
 Tag:Core Data
 **********************************************************/
-(void)deleteInvoiceWithNumber:(NSString *)invNumber
{
    
    NSLog(@"Deleting invoice with number: %@", invNumber);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Invoice"];
    request.predicate = [NSPredicate predicateWithFormat:@"invoiceNumber = %@", invNumber];
    NSError *error = nil;
    NSArray *invoices = [context executeFetchRequest:request error:&error];
    if (invoices.count == 0) {
        //Nothing to Delete.
        NSLog(@"No items found");
    }
    if (invoices.count == 1) {
        //Delete all invoices matching that unique number!
        for (NSManagedObject *invoice in invoices) {
            [context deleteObject:invoice];
            NSLog(@"Invoice %@ Deleted", invNumber);
            NSError *error = nil;
            [context save:&error];
        }
    }
    
}
/**********************************************************
 Method: (Client *) getClientForName:(NSString *)clientName
 Description:Gets the client company name for a given (Client *)
 Tag:Utility
 **********************************************************/
- (Client *) getClientForName:(NSString *)clientName
{
    //Get Client Data from CoreData
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"Client" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.predicate = [NSPredicate predicateWithFormat:@"company = %@", clientName];
    [request setEntity:desc];
    
    NSError *error;
    NSArray *data = [context executeFetchRequest:request error:&error];
    if (data.count !=0) {
        for (Client *c in data) {
            NSLog(@"%@", c.company);
            return c;
        }
    }
    Client *cl = [[Client alloc]init];
    return cl;
}
/**********************************************************
 Method: (Client *) getClientForName:(NSString *)clientName
 Description:Gets the client company name for a given (Client *)
 Tag:Utility
 **********************************************************/
- (Invoice *) getInvoiceForNumber:(NSString *)invoiceNumber
{
    //Get Invoice Data from CoreData
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"Invoice" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.predicate = [NSPredicate predicateWithFormat:@"invoiceNumber = %@", invoiceNumber];
    [request setEntity:desc];
    
    NSError *error;
    NSArray *data = [context executeFetchRequest:request error:&error];
    if (data.count != 0) {
        for (Invoice *inv in data) {
            NSLog(@"%@", inv.invoiceNumber);
            return inv;
        }
    }
    Invoice *inv = [[Invoice alloc]init];
    return inv;
}
/**********************************************************
 Method:(IBAction)SaveAndPreview:(id)sender
 Description:Stores and updates invioce info
 Tag:Core Data
 **********************************************************/

- (void)SaveInvoice
{

    if (![_invoiceNumberField  isEqual: @""]) {
        
        NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Invoice" inManagedObjectContext:context];
        NSManagedObject *newInvoice = [[NSManagedObject alloc]initWithEntity:entityDesc insertIntoManagedObjectContext:context];
//        
//        [newInvoice setValue:_dateField.text forKey:@"date"];
//        [newInvoice setValue:_invoiceNumberField.text forKey:@"invoiceNumber"];
//        [newInvoice setValue:_projectNameField.text forKey:@"projectName"];
//        [newInvoice setValue:_subTotalLabel.text forKey:@"subTotal"];
//        [newInvoice setValue:_totalLabel.text forKey:@"total"];
//        [newInvoice setValue:_vatLabel.text forKey:@"vat"];
//        [newInvoice setValue:client forKey:@"clientForInvoice"];
//        [newInvoice setValue:charges forKey:@"invoice_charges"];
        
        
        
    }

}
- (IBAction)addItem:(id)sender
{
    
}
- (IBAction)editItem:(id)sender
{
    
}
- (IBAction)doneButton:(id)sender
{
    
}

- (IBAction)saveAndPreview:(id)sender {
}

#pragma TableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [invoiceRowObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
