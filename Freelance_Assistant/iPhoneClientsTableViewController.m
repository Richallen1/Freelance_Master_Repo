//
//  iPhoneClientsTableViewController.m
//  Freelance_Assistant
//
//  Created by Rich Allen on 18/01/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#import "iPhoneClientsTableViewController.h"
#import "AppDelegate.h"
#import "Client.h"
#import "iPhoneClientDetailViewController.h"

@interface iPhoneClientsTableViewController ()<iPhoneClientDetailDelegate>
{
    NSManagedObjectContext *context;
    NSArray *clientsArray;
    Client *selectedClient;
}
@end

@implementation iPhoneClientsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    clientsArray = [[NSArray alloc]init];
    selectedClient = NULL;
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    [self setupFetchedResultsController];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma Core Data Methods
- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Client"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"company"
                                                                                     ascending:YES
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 

}
#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Client *client = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = client.company;
    
    return cell;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"chosen_client_segue"])
    {
      NSIndexPath *indexPath = [ self.tableView indexPathForCell:sender];
        selectedClient = [self.fetchedResultsController objectAtIndexPath:indexPath];
        iPhoneClientDetailViewController *detailVC = segue.destinationViewController;
        detailVC.selectedClient = selectedClient;
        detailVC.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"new_client_segue"])
    {
        iPhoneClientDetailViewController *detailVC = segue.destinationViewController;
        detailVC.selectedClient = selectedClient;
    }
}
-(void)tableViewReload
{
    [self.tableView reloadData];
}
@end
