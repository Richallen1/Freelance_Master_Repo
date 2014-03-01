//
//  iPhoneHelpDetailViewController.h
//  freelance_assistant
//
//  Created by Rich Allen on 13/02/2014.
//  Copyright (c) 2014 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface iPhoneHelpDetailViewController : UIViewController <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UILabel *helpTopicField;
    IBOutlet UITextView *helpDetailTextView;
}

@property (strong, nonatomic) NSString *helpTopic;
@property (strong, nonatomic) NSString *helpDetail;

@property (nonatomic, strong) NSMutableArray *invoiceRows;
- (IBAction)contactEmailButton:(id)sender;

@end
