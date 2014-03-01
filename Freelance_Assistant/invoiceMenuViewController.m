//
//  invoiceMenuViewController.m
//  freelance_assistant
//
//  Created by Rich Allen on 25/02/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#import "invoiceMenuViewController.h"
#import "InvoiceTableViewController.h"

@interface invoiceMenuViewController () 
{
    NSArray *menuItems;
    UIView *tutorialView;
}
@end

@implementation invoiceMenuViewController
/*--------------------------------------------------------------------
 Method: (void)tutorialDone
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)tutorialDone
{
    [tutorialView removeFromSuperview];
    tutorialView = nil;
    self.tabBarController.selectedIndex = 2;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"DONE" forKey:@"firstTime"];
}
/*--------------------------------------------------------------------
 Method: (void)showFirstTimeTutorial
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)showFirstTimeTutorial
{
    tutorialView = [[UIView alloc]initWithFrame:self.view.bounds];
    tutorialView.backgroundColor = [UIColor blackColor];
    tutorialView.alpha = 0.3;
    
    UIView *tutorialContentView = [[UIView alloc]initWithFrame:self.view.bounds];
    
    //Add Image View
    UIImage *img = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TutorialView" ofType:@"png"]];
    UIImageView *tutorialImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 280, 340)];
    tutorialImage.image = img;
    [tutorialView addSubview:tutorialImage];
    
    //Add Done Button
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(104, 400, 120, 30)];
    [btn setEnabled:YES];
    [btn setUserInteractionEnabled:YES];
    [btn addTarget: self
            action: @selector(tutorialDone)
  forControlEvents: UIControlEventTouchDown];
    
    [btn setTitle:@"Ok I've got it!" forState:UIControlStateNormal];
    [tutorialContentView addSubview:btn];
    
    
    [tutorialView addSubview:tutorialContentView];
    [self.view addSubview:tutorialView];
    
}
/*--------------------------------------------------------------------
 Method: (void)viewDidLoad
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    menuItems = [[NSArray alloc]initWithObjects:@"All", @"Outstanding", @"Paid", nil];
    self.navigationController.navigationBar.backgroundColor = UIColorFromRGB(0x64c3d9);
    self.tabBarController.tabBar.backgroundColor = UIColorFromRGB(0x64c3d9);
    self.tableView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    if (![[defaults objectForKey:@"firstTime"] isEqualToString:@"DONE"]) {
        if (self.view.bounds.size.height >= 568) {
            [self showFirstTimeTutorial];
        }
    }
}
/*--------------------------------------------------------------------
 Method: (void)didReceiveMemoryWarning
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
/*--------------------------------------------------------------------
 Method: (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [menuItems count];
}
/*--------------------------------------------------------------------
 Method: (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [menuItems objectAtIndex:indexPath.row];
    
    return cell;
}
/*--------------------------------------------------------------------
 Method: (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 Description:
 Tag:
 
 --------------------------------------------------------------------*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"chosen_invoice_menu"])
    {
        InvoiceTableViewController *itvc = segue.destinationViewController;
        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
        itvc.chosenView = [menuItems objectAtIndex:index.row];
    }
}
@end