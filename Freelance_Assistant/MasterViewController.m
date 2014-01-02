//
//  MasterViewController.m
//  Freelance_Assistant
//
//  Created by Rich Allen on 24/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


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
    
    self.tableView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    
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
 
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [_menuItems objectAtIndex:indexPath.row];
    return cell;
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
