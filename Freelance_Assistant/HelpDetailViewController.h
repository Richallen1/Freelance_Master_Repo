//
//  HelpDetailViewController.h
//  Freelance_Assistant
//
//  Created by Richard Allen on 31/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *helpTopicLabel;
@property (weak, nonatomic) IBOutlet UITextView *helpTextView;
- (IBAction)contactUs:(id)sender;

@end
