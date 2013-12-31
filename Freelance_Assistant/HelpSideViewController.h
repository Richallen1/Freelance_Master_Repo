//
//  HelpSideViewController.h
//  Freelance_Assistant
//
//  Created by Richard Allen on 31/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HelpDetailDelegate
@optional
- (void)PassHelpDataWithTopic:(NSString *)topic andArticle:(NSString *)article;

@end
@interface HelpSideViewController : UITableViewController
@property (weak, nonatomic) id <HelpDetailDelegate> delegate;
@end
