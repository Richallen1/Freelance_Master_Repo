//
//  HelpDetailViewController.m
//  Freelance_Assistant
//
//  Created by Richard Allen on 31/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import "HelpDetailViewController.h"
#import "HelpSideViewController.h"

@interface HelpDetailViewController ()<HelpDetailDelegate>

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
    _helpTextView.text = topic;
    _helpTopicLabel.text = article;

}

@end
