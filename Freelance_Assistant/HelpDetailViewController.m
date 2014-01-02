//
//  HelpDetailViewController.m
//  Freelance_Assistant
//
//  Created by Richard Allen on 31/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import "HelpDetailViewController.h"
#import "HelpSideViewController.h"
#import <MessageUI/MessageUI.h>


@interface HelpDetailViewController ()<HelpDetailDelegate, MFMailComposeViewControllerDelegate>

@end

@implementation HelpDetailViewController
@synthesize helpTopicLabel=_helpTopicLabel;
@synthesize helpTextView=_helpTextView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	_helpTextView.text = @"";
    _helpTopicLabel.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)PassHelpDataWithTopic:(NSString *)topic andArticle:(NSString *)article
{
    _helpTopicLabel.text = topic;
    _helpTextView.text = article;
    

}

- (IBAction)contactUs:(id)sender
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

        NSString *subject = [NSString stringWithFormat:@"Support-0187"];
        [picker setSubject:subject];
        
        NSArray *toRecipients;
        // Set up recipients
            toRecipients = [NSArray arrayWithObject:@"support@magicentertainmentgroup.com"];
       
        [picker setToRecipients:toRecipients];

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
    
}

@end
