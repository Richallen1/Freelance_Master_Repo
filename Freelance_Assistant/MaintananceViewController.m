//
//  MaintananceViewController.m
//  Freelance_Assistant
//
//  Created by Richard Allen on 30/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import "MaintananceViewController.h"
#import "AppDelegate.h"


@interface MaintananceViewController ()

@end

@implementation MaintananceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)next:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"check" forKey:@"App_Startup_Check"];
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    BOOL b = [delegate application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:nil];
    
}
@end
