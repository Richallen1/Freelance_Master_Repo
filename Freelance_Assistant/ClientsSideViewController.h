//
//  ClientsSideViewController.h
//  Freelance_Assistant
//
//  Created by Rich Allen on 26/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@class DetailViewContainerController;
@class Client;

@protocol clientSideViewController
@optional
-(void)fillDetailViewWithClientData:(Client *)client;
@end

@interface ClientsSideViewController : CoreDataTableViewController
@property (nonatomic, weak) id <clientSideViewController> delegate;
- (IBAction)addClient:(id)sender;

@end
