//
//  AppDelegate.m
//  SplitView Sample
//
//  Created by Ying Rao on 1/19/13.
//  Copyright (c) 2013 Ying Rao. All rights reserved.
//
#import "MasterViewController.h"
#import "DetailViewContainerController.h"


@interface DetailViewContainerController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation DetailViewContainerController
@synthesize infoLabel1=_infoLabel1;
@synthesize labelImg1=_labelImg1;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"User_Name"] == NULL || [defaults objectForKey:@"User_Address_1"] == NULL || [defaults objectForKey:@"User_Address_2"] == NULL)
    {
        _infoLabel1.hidden = false;
        _labelImg1.hidden = false;
    }
    else
    {
        _infoLabel1.hidden = true;
        _labelImg1.hidden = true;
    }
    
	self.detailViewController1 = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController1"];
    self.detailViewController2 = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController2"];
    self.detailViewController3 = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController3"];
    self.detailViewController4 = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController4"];
    [self addChildViewController:self.detailViewController1];
    [self addChildViewController:self.detailViewController2];
    [self addChildViewController:self.detailViewController3];
    [self addChildViewController:self.detailViewController4];
    

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
            [sender setDelegate:viewController];
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
