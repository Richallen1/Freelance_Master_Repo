//
//  AddressInfoViewController.h
//  Freelance_assistant
//
//  Created by Rich Allen on 14/12/2013.
//  Copyright (c) 2013 Rich Allen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserAddressStoreDelegate
@optional
-(void) storeUserAddressWithAddress:(NSString *)addr1 andAddress2:(NSString *)addr2 andPostCode:(NSString *)postcode;
@end

@interface AddressInfoViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *address1;
@property (weak, nonatomic) IBOutlet UITextField *address2;
@property (weak, nonatomic) IBOutlet UITextField *postCode;
@property (weak, nonatomic) id <UserAddressStoreDelegate> delegate;

- (IBAction)doneButton:(id)sender;

@end
