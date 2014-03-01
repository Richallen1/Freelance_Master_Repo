//
//  iPhoneHelpTableViewController.m
//  Freelance_Assistant
//
//  Created by Rich Allen on 18/01/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "iPhoneHelpTableViewController.h"
#import "iPhoneHelpDetailViewController.h"

@interface iPhoneHelpTableViewController ()
{
    NSMutableArray *helpTopics;
    NSMutableArray *helpDetail;
}
@end

@implementation iPhoneHelpTableViewController

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
    self.tabBarController.tabBar.backgroundColor = UIColorFromRGB(0x64c3d9);

    helpTopics = [[NSMutableArray alloc]init];
    helpDetail = [[NSMutableArray alloc]init];
    [self BuildHelpLibrary];
    
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
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
#pragma mark - Table view data source
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [helpTopics count];
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [helpTopics objectAtIndex:indexPath.row];
    
    return cell;
}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"help_detail_segue"]) {
        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
        iPhoneHelpDetailViewController *vc = segue.destinationViewController;
        vc.helpTopic = [helpTopics objectAtIndex:index.row];
        vc.helpDetail = [helpDetail objectAtIndex:index.row];
    }

}
/*--------------------------------------------------------------------
 Method:
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (void)BuildHelpLibrary
{
    
    [helpTopics addObject:@"How to start an Invoice"];
    [helpTopics addObject:@"How to add a Client"];
    [helpTopics addObject:@"Change my details"];
    [helpTopics addObject:@"Email out my Invoice"];
    [helpTopics addObject:@"Update a Client's details"];
    [helpTopics addObject:@"How do you mark an invoice as Paid"];
    [helpTopics addObject:@"How do you Delete an Invoice"];
    [helpTopics addObject:@"Is my data stored anywhere else"];
    [helpTopics addObject:@"Where can I go to get more help"];
    
    [helpDetail addObject:@"Simply select the invoice menu and then click the + button and you will be asked for the project name. Once you have done that then choose the row with your new invoice and fill in the details on the right side."];
    [helpDetail addObject:@"Select the Client menu and then press the + sign. You will then be given a popup where you can enter the client info and then press the add client button."];
    [helpDetail addObject:@"Go to the main menu and select settings. You can then select each area individually to input the data required."];
    [helpDetail addObject:@"Once you have pressed the Save and Preview button you will have the option to send the client the email directly."];
    [helpDetail addObject:@"Choose the Client on the left hand side and then make the required changes. Once complete hit the update client button."];
    [helpDetail addObject:@"When you're in the invoice screen in the top right hand corner you will see a button labeled mark as paid. Press this and the table on the left should show the invoice as paid."];
    [helpDetail addObject:@"Select the invoice from the left menu and then click the delete button on the right. Alternatively you can swipe on the left menu from right to left and it will show a delete button."];
    [helpDetail addObject:@"No. The data is only stored on the device. Future versions will have the option to back up with iCloud however this is not available yet."];
    [helpDetail addObject:@"You can press the contact us button on the top right hand corner of the help page, or email direct to support@magicentertainmentgroup.com"];
}

@end
