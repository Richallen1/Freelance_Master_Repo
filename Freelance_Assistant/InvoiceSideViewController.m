//
//  InvoiceSideViewController.m
//  Freelance_Assistant
//
//  Created by Rich Allen on 26/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import "InvoiceSideViewController.h"
#import "AppDelegate.h"
#import "Invoice.h"
#import "AddInvoicePopoverViewController.h"
#import "InvoiceDetialViewController.h"


@interface InvoiceSideViewController () <AddInvoiceDelegate, InvoiceDetailDelegate>
{
    NSManagedObjectContext *context;
    NSArray *InvoiceRowObjects;
    UIPopoverController *addInvoiceController;
    NSString *todaysDate;
   // NSMutableArray *InvoiceRowObjects;
}
@end

@implementation InvoiceSideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Get Date Info
    NSDate *now = [[NSDate alloc] init];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"dd/MM/yyyy"];
	todaysDate = [dateFormat stringFromDate:now];
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    [self setupFetchedResultsController];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (long)GetDueDateFromDate:(NSString *)to
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int terms = [[defaults objectForKey:@"inv_term_period"]integerValue];
    
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

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Invoice *inv = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = inv.projectName;
    
    
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
    
    
    return cell;
}

- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    NSError *error = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Invoice"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date"
                                                                                     ascending:YES
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
    InvoiceRowObjects = [context executeFetchRequest:request error:&error];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Invoice *invoinceSelected = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate fillDetailViewWithInvoiceData:invoinceSelected fromSender:self];
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
        [tableView reloadData];
        NSLog(@"DELETE ROW NUMBER %ld", (long)indexPath.row);
    }
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
        for (NSManagedObject *invoice in invoices) {
            [context deleteObject:invoice];
        }
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

-(void)InvoiceStarted
{
    [self.tableView reloadData];
}
- (void)reloadTableFromDetailView
{
    [self setupFetchedResultsController];
    [self.tableView reloadData];
}
- (IBAction)addInvoiceBtn:(id)sender
{
    AddInvoicePopoverViewController *addInvoiceView = [[self storyboard] instantiateViewControllerWithIdentifier:@"addInvoiceVC"];
    
    addInvoiceView.delegate = self;
    
    addInvoiceController = [[UIPopoverController alloc]
                           initWithContentViewController:addInvoiceView];
    
    CGRect rect = CGRectMake(0, 0, 400, 260);
    [addInvoiceController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}



@end
