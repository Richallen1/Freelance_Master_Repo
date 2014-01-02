//
//  AppDelegate.m
//  SplitView Sample
//
//  Created by Ying Rao on 1/19/13.
//  Copyright (c) 2013 Ying Rao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h" 


@interface DetailViewContainerController : UIViewController <UISplitViewControllerDelegate> {
    UIViewController* topController;
}

-(void)showViewWithId:(int)viewId withSender:(id)sender;

@property (strong, nonatomic) DetailViewController *detailViewController1;
@property (strong, nonatomic) DetailViewController *detailViewController2;
@property (strong, nonatomic) DetailViewController *detailViewController3;
@property (strong, nonatomic) DetailViewController *detailViewController4;

@property (weak, nonatomic) IBOutlet UIImageView *labelImg1;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel1;

@end
