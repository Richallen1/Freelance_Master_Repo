//
//  StartUpViewController.m
//  Freelance_Assistant
//
//  Created by Richard Allen on 31/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import "StartUpViewController.h"

@interface StartUpViewController ()

@end

@implementation StartUpViewController
@synthesize nameField=_nameField;
@synthesize addressField=_addressField;
@synthesize cityField=_cityField;
@synthesize postField=_postField;
@synthesize userEmail=_userEmail;


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

- (IBAction)doneButton:(id)sender
{
    [self.delegate Done];
//    if ([_nameField.text isEqualToString:@""] || [_addressField.text isEqualToString:@""] || [_addressField.text isEqualToString:@""] || [_cityField.text isEqualToString:@""] || [_postField.text isEqualToString:@""]|| [_userEmail.text isEqualToString:@""])
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops...You Missed a bit." message:@"There are some fields missing. We need an entry in these to correctly build your invoices. You can change these details at a later date by going to the settings menu." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//        [alert show];
//    }
//    else
//    {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:_nameField.text forKey:@"User_Name"];
//        [defaults setObject:_addressField.text forKey:@"User_Address_1"];
//        [defaults setObject:_cityField.text forKey:@"User_City"];
//        [defaults setObject:_postField forKey:@"User_Address_2"];
//        [defaults setObject:_userEmail.text forKey:@"User_Email"];
//    }
//
    
    
    //[self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)whyEmailAlert:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Why do you need my email?" message:@"We need your email so that we can CC your invoices to you." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
@end
