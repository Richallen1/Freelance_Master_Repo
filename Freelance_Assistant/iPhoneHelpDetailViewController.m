//
//  iPhoneHelpDetailViewController.m
//  freelance_assistant
//
//  Created by Rich Allen on 13/02/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "iPhoneHelpDetailViewController.h"


@implementation iPhoneHelpDetailViewController
@synthesize helpTopic = _helpTopic;
@synthesize helpDetail = _helpDetail;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xF2F2F2);
    
    helpTopicField.text = _helpTopic;
    helpDetailTextView.text = _helpDetail;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)contactEmailButton:(id)sender
{
    [self displayMailComposerSheet];
}
#pragma mark - Compose Mail/SMS
// -------------------------------------------------------------------------------
//	displayMailComposerSheet
//  Displays an email composition interface inside the application.
//  Populates all the Mail fields.
// -------------------------------------------------------------------------------
- (void)displayMailComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    
    NSString *subject = [NSString stringWithFormat:@"Support Request"];
	[picker setSubject:subject];
    NSArray *toRecipients = [NSArray arrayWithObject:@"rich.allenlx@gmail.com"];

	[picker setToRecipients:toRecipients];


	// Fill out the email body text
	NSString *emailBody = @"";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentViewController:picker animated:YES completion:NULL];
}
#pragma mark - Delegate Methods
// -------------------------------------------------------------------------------
//	mailComposeController:didFinishWithResult:
//  Dismisses the email composition interface when users tap Cancel or Send.
//  Proceeds to update the message field with the result of the operation.
// -------------------------------------------------------------------------------
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString *feedbackMsg;
    UIAlertView *msgAlert;
    feedbackMsg = [[NSString alloc]init];
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            feedbackMsg = @"Result: Mail sending canceled";
            break;
        case MFMailComposeResultSaved:
            feedbackMsg = @"Result: Mail saved";
            break;
        case MFMailComposeResultSent:
            feedbackMsg = @"Result: Mail sent";
            msgAlert = [[UIAlertView alloc]initWithTitle:@"SENT!" message:@"Your support request has been sent." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            //[self removeFile:fileName];
            break;
        case MFMailComposeResultFailed:
            feedbackMsg = @"Result: Mail sending failed";
            msgAlert = [[UIAlertView alloc]initWithTitle:@"Oops...." message:@"Your support request failed to send. Please check your network settings and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            break;
        default:
            feedbackMsg = @"Result: Mail not sent";
            break;
    }
    NSLog(@"%@", feedbackMsg);
    if (msgAlert != nil) {
        [msgAlert show];
    }
	[self dismissViewControllerAnimated:YES completion:NULL];
}
@end
