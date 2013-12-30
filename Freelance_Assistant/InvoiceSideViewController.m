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
}
@end

@implementation InvoiceSideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *to  = @"1/1/2014";
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"dd/MM/yyyy"];
    //NSDate *startDate = [NSDate date];
    NSDate *startDate = [[NSDate alloc]init];
    NSLog(@"%@",startDate);
    NSDate *endDate = [f dateFromString:to];
    NSLog(@"%@",endDate);
    
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    
    NSLog(@"%ld", (long)components.day);
    
    
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
    return components.day;
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

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Invoice"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date"
                                                                                     ascending:YES
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Invoice *invoinceSelected = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.delegate fillDetailViewWithInvoiceData:invoinceSelected fromSender:self];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
