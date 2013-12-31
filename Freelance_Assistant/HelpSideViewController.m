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
    
}
@end

@implementation HelpSideViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    helpTopics = [[NSMutableArray alloc]init];

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
    NSMutableDictionary *currentDict = [helpTopics objectAtIndex:indexPath.row];
    cell.textLabel.text = [currentDict objectForKey:@"topic"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.delegate PassHelpDataWithTopic:@"sssssss" andArticle:@"dddddd"];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
