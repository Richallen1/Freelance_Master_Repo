//
//  AppDelegate.m
//  SplitView Sample
//
//  Created by Ying Rao on 1/19/13.
//  Copyright (c) 2013 Ying Rao. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "MasterViewController.h"
#import "DetailViewContainerController.h"
#import "StartUpViewController.h"

@interface DetailViewContainerController ()<UIAlertViewDelegate>
{
    UIPopoverController *firstTimeController;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation DetailViewContainerController
@synthesize infoTextView=_infoTextView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"User_Name"] == NULL || [defaults objectForKey:@"User_Address_1"] == NULL || [defaults objectForKey:@"User_Address_2"] == NULL)
    {
        _infoTextView.hidden = false;
    }
    else
    {
        _infoTextView.hidden = true;
    }
    
	self.detailViewController1 = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController1"];
    self.detailViewController2 = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController2"];
    self.detailViewController3 = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController3"];
    self.detailViewController4 = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController4"];
    [self addChildViewController:self.detailViewController1];
    [self addChildViewController:self.detailViewController2];
    [self addChildViewController:self.detailViewController3];
    [self addChildViewController:self.detailViewController4];
    
    [self FirstStartUp];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self showViewWithId:2 withSender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showViewWithId:(int)viewId withSender:(id)sender {
    NSLog(@"%@", sender);
    UIViewController *viewController;
    switch (viewId) {
        case 0:
            viewController = self.detailViewController1;
            [sender setDelegate:viewController];
            NSLog(@"VC1 Loaded");
            break;
        case 1:
            viewController = self.detailViewController2;
            [sender setDelegate:viewController];
            NSLog(@"VC2 Loaded");
            break;
        case 2:
            viewController = self.detailViewController3;
            NSLog(@"VC3 Loaded");
            break;
        case 3:
            viewController = self.detailViewController4;
            [sender setDelegate:viewController];
            NSLog(@"VC4 Loaded");
            break;

    }
    [self showChildViewController:viewController];
}

-(void)showChildViewController:(UIViewController*)content {
    if(topController != content) {
        content.view.frame = [self.view frame]; // 2
        [self.view addSubview:content.view];
        [content didMoveToParentViewController:self];
        topController = content;
    }
}
-(void)FirstStartUp
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"First_Start_Up"] == NULL) {
        
        NSLog(@"First Time");
        [defaults setObject:@"NO" forKey:@"First_Start"];
        [defaults setObject:@"" forKey:@"User_Name"];
        [defaults setObject:@"" forKey:@"User_Address_1"];
        [defaults setObject:@"" forKey:@"User_Address_2"];
        [defaults setObject:@"" forKey:@"inv_term_period"];
        [defaults setObject:@"" forKey:@"User_Account_Number"];
        [defaults setObject:@"" forKey:@"User_Sort_Code"];
        [defaults setObject:@"" forKey:@"User_VAT"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Welcome to Freelance Assistant" message:@"We need to get some information from you so that we can put your details on your invoices. Click ok to go to the settings tab and enter in the information." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [defaults setObject:@"NO" forKey:@"First_Start_Up"];
    }
    
    

    
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Home", @"Home");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
