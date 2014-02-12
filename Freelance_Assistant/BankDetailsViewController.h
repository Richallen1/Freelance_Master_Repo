//
//  BankDetailsViewController.h
//  Freelance_assistant
//
//  Created by Rich Allen on 14/12/2013.
//  Copyright (c) 2013 Rich Allen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserBankDetailsStoreDelegate
@optional
-(void) storeBankDetailsWithAccountNumber:(NSString *)accountNumber andSortCode:(NSString *)sortCode;
@end


@interface BankDetailsViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *accountNumber;
@property (weak, nonatomic) IBOutlet UITextField *sortCode;
@property (weak, nonatomic) id <UserBankDetailsStoreDelegate> delegate;

- (IBAction)doneButton:(id)sender;

@end
