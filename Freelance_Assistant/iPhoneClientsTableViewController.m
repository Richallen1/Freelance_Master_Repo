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
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = UIColorFromRGB(0x64c3d9);
    self.tableView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    clientsArray = [[NSArray alloc]init];
    selectedClient = NULL;
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    [self setupFetchedResultsController];

}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma Core Data Methods
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
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
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)deleteClientForCompany:(NSString *)company
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Client"];
    request.predicate = [NSPredicate predicateWithFormat:@"company = %@", company];
    NSError *error = nil;
    NSArray *clients = [context executeFetchRequest:request error:&error];
    if (clients.count == 0) {
        //Nothing to Delete.
    }
    if (clients.count >= 1) {
        //Delete all invoices matching that unique number!
        for (Client *client in clients) {
            [context deleteObject:client];
        }
        [context save:&error];
    }
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Client *client = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = client.company;
    
    return cell;
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
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
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        Client *cl = [clientsArray objectAtIndex:indexPath.row];
        
        [self deleteClientForCompany:cl.company];
        [tableView reloadData];
        NSLog(@"DELETE ROW NUMBER %ld", (long)indexPath.row);

    }
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

#pragma Client Custon Delegate Methods
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)tableViewReload
{
    [self.tableView reloadData];
    
}
@end
