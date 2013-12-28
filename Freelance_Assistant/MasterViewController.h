//
//  MasterViewController.h
//  Freelance_Assistant
//
//  Created by Rich Allen on 24/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@class DetailViewContainerController;

@protocol dataPassDelegate
@optional
-(void)passDataWithString:(NSString *)data;
@end

@interface MasterViewController : UITableViewController 

@property (nonatomic, strong) NSArray *menuItems;
@property (strong, nonatomic) DetailViewContainerController *detailViewContainerController;
@property (nonatomic, weak) id <dataPassDelegate> delegate;


@end
