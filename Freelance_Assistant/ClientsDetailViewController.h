//
//  ClientsDetailViewController.h
//  Freelance_Assistant
//
//  Created by Rich Allen on 26/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClientsSideViewController;

@protocol ClientDetailDelegate <NSObject>
@optional
-(void)tableViewReload;
@end

@interface ClientsDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *surname;
@property (weak, nonatomic) IBOutlet UITextField *company;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *address2;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UITextField *zip;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *country;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) id<ClientDetailDelegate> delgate;



- (IBAction)updateClient:(id)sender;
- (IBAction)deleteClient:(id)sender;



@end
