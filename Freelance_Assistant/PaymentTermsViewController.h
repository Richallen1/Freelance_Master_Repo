//
//  PaymentTermsViewController.h
//  Freelance_assistant
//
//  Created by Rich Allen on 14/12/2013.
//  Copyright (c) 2013 Rich Allen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserPaymentTermsStoreDelegate
@optional
-(void) storeUserPaymentTerms:(NSString *)paymentTerms;
@end

@interface PaymentTermsViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *paymentTermsField;
@property (weak, nonatomic) id <UserPaymentTermsStoreDelegate> delegate;

- (IBAction)doneButton:(id)sender;

@end
