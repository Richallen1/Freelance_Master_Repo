//
//  UserInfoViewController.h
//  Freelance_assistant
//
//  Created by Rich Allen on 14/12/2013.
//  Copyright (c) 2013 Rich Allen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserNameStoreDelegate
@optional
-(void) storeUserName:(NSString *)name;
@end


@interface UserInfoViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *userFirstName;
@property (weak, nonatomic) IBOutlet UITextField *userSurname;
@property (weak, nonatomic) id <UserNameStoreDelegate> delegate;

- (IBAction)donButton:(id)sender;

@end
