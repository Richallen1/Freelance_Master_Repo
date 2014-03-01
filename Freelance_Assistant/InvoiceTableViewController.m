//
//  InvoiceTableViewController.m
//  freelance_assistant
//
//  Created by Rich Allen on 25/02/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "InvoiceTableViewController.h"

#import "AppDelegate.h"
#import "Invoice.h"
#import "iPhoneInvoiceDetailViewController.h"
#import "Client.h"
#import <Crashlytics/Crashlytics.h>
@interface InvoiceTableViewController ()<UIActionSheetDelegate, iPhoneInvoiceDelegate>
{
    Invoice *invoinceSelected;
    NSManagedObjectContext *context;
    NSArray *InvoiceRowObjects;
    UIPopoverController *addInvoiceController;
    NSString *todaysDate;
    Client *slectedClient;
    UIView *tutorialView;
}
@end

@implementation InvoiceTableViewController
@synthesize chosenView = _chosenView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    //Get Date Info
    NSDate *now = [[NSDate alloc] init];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"dd/MM/yyyy"];
	todaysDate = [dateFormat stringFromDate:now];
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    [self setupFetchedResultsControllerFoViewChoice:_chosenView];
    [self.tableView reloadData];
    self.title = _chosenView;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [InvoiceRowObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    Invoice *inv = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = inv.projectName;
    NSNumber *paid = [[NSNumber alloc]initWithInt:1];
    if (inv.paid == paid) {
        cell.detailTextLabel.text = @"Paid";
    }
    else
    {
        long daysDue = [self GetDueDateFromDate:inv.date];
        if (daysDue <= 0) {
            NSString *detailStr = @"This Invoice is Overdue!";
            cell.detailTextLabel.textColor = [UIColor redColor];
            cell.detailTextLabel.text = detailStr;
        }
        else
        {
            NSString *detailStr = [NSString stringWithFormat:@"This Invoice due in %ld days", daysDue];
            cell.detailTextLabel.text = detailStr;
        }
    }
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    float total = 0.00;
    for (Invoice *inv in InvoiceRowObjects) {
        float totalFL = [inv.total floatValue];
        total += totalFL;
    }
    NSString *result = [NSString stringWithFormat:@"Total: £%.02f", total];
    return result;
}
#pragma mark - Table view Edit Mthods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    invoinceSelected = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        Invoice *inv = [InvoiceRowObjects objectAtIndex:indexPath.row];
        [self deleteInvoiceWithNumber:inv.invoiceNumber];
        [self.tableView reloadData];
        NSLog(@"DELETE ROW NUMBER %ld", (long)indexPath.row);
    }
}
#pragma mark - Core Data Stack

- (void)setupFetchedResultsControllerFoViewChoice:(NSString *)choice
{
    NSError *error = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Invoice"];
    if ([choice isEqualToString:@"Outstanding"]) {
        request.predicate = [NSPredicate predicateWithFormat:@"paid == NO"];
        request.predicate = [NSPredicate predicateWithFormat:@"paid == %@", nil];
    }
    else if ([choice isEqualToString:@"Paid"]){
        request.predicate = [NSPredicate predicateWithFormat:@"paid == YES"];
    }
    
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date"
                                                                                     ascending:YES
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
    InvoiceRowObjects = [context executeFetchRequest:request error:&error];
    
    NSLog(@"Invoice Count: %lu", (unsigned long)[InvoiceRowObjects count]);
    
    
}
/**********************************************************
 Method:(void)deleteInvoiceWithNumber:(NSString *)invNumber
 Description:Deletes a invoice for a given invoice number
 Tag:Core Data
 **********************************************************/
-(void)deleteInvoiceWithNumber:(NSString *)invNumber
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Invoice"];
    request.predicate = [NSPredicate predicateWithFormat:@"invoiceNumber = %@", invNumber];
    NSError *error = nil;
    NSArray *invoices = [context executeFetchRequest:request error:&error];
    if (invoices.count == 0) {
        //Nothing to Delete.
    }
    if (invoices.count == 1) {
        //Delete all invoices matching that unique number!
        for (Invoice *invoice in invoices) {
            [context deleteObject:invoice];
            NSLog(@"Invoice: %@", invoice);
            
        }
        [context save:&error];
    }
}
-(User *)findUser
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSError *error = nil;
    NSArray *users = [context executeFetchRequest:request error:&error];
    if (users.count == 0) {
        User *newUser = nil;
        
        newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        return newUser;
        
    }
    return [users objectAtIndex:0];
}
#pragma mark - Utility Functions
- (long)GetDueDateFromDate:(NSString *)to
{
    User *user = [self findUser];
    int terms = [user.paymentTerms intValue];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"dd/MM/yyyy"];
    NSDate *startDate = [[NSDate alloc]init];
    NSString *startDateSting = [f stringFromDate:startDate];
    startDate = [f dateFromString:startDateSting];
    NSDate *endDate = [f dateFromString:to];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    return components.day+terms;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"chosen_invoice_segue"])
    {
        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
        iPhoneInvoiceDetailViewController *vc = segue.destinationViewController;
        invoinceSelected = [InvoiceRowObjects objectAtIndex:index.row];
        vc.selectedInvoice = invoinceSelected;
        vc.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"new_invoice"])
    {
        iPhoneInvoiceDetailViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}
#pragma mark - Delegate Methods
-(void)InvoiceStarted
{
    [self.tableView reloadData];
}
- (void)reloadTableFromDetailView
{
    [self setupFetchedResultsControllerFoViewChoice:_chosenView];
    [self.tableView reloadData];
    NSLog(@"Table Count: %lu",(unsigned long)[InvoiceRowObjects count]);
}
-(void)reloadTableData
{
    [self setupFetchedResultsControllerFoViewChoice:_chosenView];
    [self.tableView reloadData];
}
@end
