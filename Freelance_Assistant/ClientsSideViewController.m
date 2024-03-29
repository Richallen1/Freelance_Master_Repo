//
//  ClientsSideViewController.m
//  Freelance_Assistant
//
//  Created by Rich Allen on 26/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "ClientsSideViewController.h"
#import "AppDelegate.h"
#import "Client.h"
#import "AddClientPopoverViewController.h"
#import "ClientsDetailViewController.h"

@interface ClientsSideViewController () <addClientDelegate, ClientDetailDelegate, UIPopoverControllerDelegate>
{
    NSManagedObjectContext *context;
    NSArray *clientsArray;
    UIPopoverController *addClientController;
}
@end

@implementation ClientsSideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    
    [self setupFetchedResultsController];
    [self getClientsCount];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Low Memory!!" message:@"You are running low on memory. You might want to close some of your other apps to get the best results." delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    
    [alert show];
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Client *client = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    if ([client.company  isEqual: @""]) {
        NSString *str = [NSString stringWithFormat:@"%@ %@",client.firstName, client.lastName];
        cell.textLabel.text = str;
    }
    else
    {
    cell.textLabel.text = client.company;
    }
    return cell;
}

- (void)setupFetchedResultsController // attaches an NSFetchRequest to this UITableViewController
{

    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Client"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"company"
                                                                                     ascending:YES
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    
    
    clientsArray = [context executeFetchRequest:request error:&error];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    Client *selectedClient = [self.fetchedResultsController objectAtIndexPath:path];
    
    [self.delegate fillDetailViewWithClientData:selectedClient fromSender:self];
}
-(void)done
{
    [self.tableView reloadData];

}
- (IBAction)addClient:(id)sender
{
    AddClientPopoverViewController *addClientView = [[self storyboard] instantiateViewControllerWithIdentifier:@"addClientVC"];
    
    [addClientView setDelegate:self];
  
    addClientController = [[UIPopoverController alloc]
                             initWithContentViewController:addClientView];
    
    CGRect rect = CGRectMake(0, 0, 550, 550);
    [addClientController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
    
}
-(void)tableViewReload
{
    [self.tableView reloadData];
}

-(void)getClientsCount
{
    //Get Client Data from CoreData
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"Client" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:desc];
    
    NSError *error;
    NSArray *clientsLocal = [context executeFetchRequest:request error:&error];
    
    NSLog(@"Clients Count: %lu", (unsigned long)[clientsLocal count]);
    return;
}

@end
