//
//  EmailViewController.h
//  Freelance_assistant
//
//  Created by Rich Allen on 14/12/2013.
//  Copyright (c) 2013 Rich Allen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserEmailStoreDelegate
@optional
-(void) storeEmailName:(NSString *)email;
@end

@interface EmailViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) id <UserEmailStoreDelegate> delegate;

- (IBAction)doneButton:(id)sender;


@end
