//
//  MasterViewController.m
//  Freelance_Assistant
//
//  Created by Rich Allen on 24/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewContainerController.h"
#import "DetailViewController.h"
#import "StartUpViewController.h"

@interface MasterViewController ()

@end

@implementation MasterViewController
@synthesize menuItems=_menuItems;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _menuItems = @[@"Invoices", @"Clients", @"Settings", @"Help"];
    self.detailViewContainerController = (DetailViewContainerController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [_menuItems objectAtIndex:indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        [self.detailViewContainerController showViewWithId:2 withSender:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"invoice_segue"])
    {
        [self.detailViewContainerController showViewWithId:0 withSender:segue.destinationViewController];
    }
    if ([segue.identifier isEqualToString:@"client_segue"])
    {
        [self.detailViewContainerController showViewWithId:1 withSender:segue.destinationViewController];
    }
    if ([segue.identifier isEqualToString:@"settings_segue"])
    {
       //[self.detailViewContainerController showViewWithId:2 withSender:segue.destinationViewController];
    }
    if ([segue.identifier isEqualToString:@"help_segue"])
    {
        [self.detailViewContainerController showViewWithId:3 withSender:segue.destinationViewController];
    }
}



@end
