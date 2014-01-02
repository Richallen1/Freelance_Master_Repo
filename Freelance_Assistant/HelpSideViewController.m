//
//  HelpSideViewController.m
//  Freelance_Assistant
//
//  Created by Richard Allen on 31/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import "HelpSideViewController.h"
#import "HelpDetailViewController.h"

@interface HelpSideViewController ()<HelpDetailDelegate>
{
    NSMutableArray *helpTopics;
    NSMutableArray *helpDetail;
    
}
@end

@implementation HelpSideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    helpTopics = [[NSMutableArray alloc]init];
    helpDetail = [[NSMutableArray alloc]init];
    
    [self BuildHelpLibrary];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [helpTopics count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [helpTopics objectAtIndex:indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.delegate PassHelpDataWithTopic:[helpTopics objectAtIndex:indexPath.row] andArticle:[helpDetail objectAtIndex:indexPath.row]];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)BuildHelpLibrary
{

    [helpTopics addObject:@"How to start an Invoice"];
    [helpTopics addObject:@"How to add a Client"];
    [helpTopics addObject:@"Change my details"];
    [helpTopics addObject:@"Email out my Invoice"];
    [helpTopics addObject:@"Update a Client's details"];

    
    [helpDetail addObject:@"Simply select the invoice menu and then click the + button and you will be asked for the project name. Once you have done that then choose the row with your new invoice and fill in the details on the right side."];
    [helpDetail addObject:@"Select the Client menu and then press the + sign. You will then be given a popup where you can enter the client info and then press the add client button."];
    [helpDetail addObject:@"Once you have pressed the Save and Preview button you will have the option to send the client the email directly."];
    [helpDetail addObject:@"Choose the Clienton the left hand side and then make the required changes. Once complete hit the update client button."];
    [helpDetail addObject:@""];

    
    
    
    
    
}
@end
