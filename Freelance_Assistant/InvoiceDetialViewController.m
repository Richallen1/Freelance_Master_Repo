//
//  InvoiceDetialViewController.m
//  Freelance_Assistant
//
//  Created by Rich Allen on 26/12/2013.
//  Copyright (c) 2013 Magic Entertainment. All rights reserved.
//

#import "InvoiceDetialViewController.h"
#import "MasterViewController.h"
#import "InvoiceSideViewController.h"
#import "Invoice.h"
#import "Client.h"
#import "ClientPickerPopoverViewController.h"
#import "AddChargeTableViewController.h"
#import "AppDelegate.h"
#import "Invoice_charges.h"
#import "PDFViewController.h"
#import "PDFPublisherController.h"
#import "CameraRecieptViewController.h"

@interface InvoiceDetialViewController ()<invoiceSideViewController, ClientPickerDelegate, AddChargeTableViewDelegate, UISplitViewControllerDelegate, CameraDelegate>
{
    NSManagedObjectContext *context;
    UIPopoverController *clientPopupController;
    Client *clientSelected;
    int recieptCount;
}
@end

@implementation InvoiceDetialViewController
@synthesize projectField=_projectField;
@synthesize invoiceField=_invoiceField;;
@synthesize dateField=_dateField;
@synthesize clientNameField=_clientNameField;
@synthesize chargesTableView=_chargesTableView;
@synthesize subTotalLabel=_subTotalLabel;
@synthesize vatLabel=_vatLabel;
@synthesize totalLabel=_totalLabel;
@synthesize invoiceRows=_invoiceRows;
@synthesize editBtn=_editBtn;
@synthesize noInvoiceImage=_noInvoiceImage;
@synthesize recieptsAttachedLabel=_recieptsAttachedLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _clientNameField.delegate = self;
    _invoiceRows = [[NSMutableArray alloc]init];
    
	//Core Data Context Declaration from App delegate shared context
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    context = [appdelegate managedObjectContext];
    
    recieptCount = [self checkReciptsCount];
    if (recieptCount == 0) {
        _recieptsAttachedLabel.hidden = YES;
    }
    else
    {
        _recieptsAttachedLabel.hidden = NO;
        NSString *str = [NSString stringWithFormat:@"%d Reciepts Attached", recieptCount];
        _recieptsAttachedLabel.text = str;
    }
    
    _recieptsAttachedLabel.hidden = YES;
    _noInvoiceImage.hidden = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Low Memory!!" message:@"You are running low on memory. You might want to close some of your other apps to get the best results." delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    
    [alert show];
}

#pragma Core Data
/**********************************************************
 Method:(void)deleteInvoiceWithNumber:(NSString *)invNumber
 Description:Deletes a invoice for a given invoice number
 Tag:Core Data
 **********************************************************/
-(void)deleteInvoiceWithNumber:(NSString *)invNumber
{
    
    NSLog(@"Deleting invoice with number: %@", invNumber);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Invoice"];
    request.predicate = [NSPredicate predicateWithFormat:@"invoiceNumber = %@", invNumber];
    NSError *error = nil;
    NSArray *invoices = [context executeFetchRequest:request error:&error];
    if (invoices.count == 0) {
        //Nothing to Delete.
        NSLog(@"No items found");
    }
    if (invoices.count == 1) {
        //Delete all invoices matching that unique number!
        for (NSManagedObject *invoice in invoices) {
            [context deleteObject:invoice];
            NSLog(@"Invoice %@ Deleted", invNumber);
            NSError *error = nil;
            [context save:&error];
        }
    }
    
}
/**********************************************************
 Method:(int)checkReciptsCount
 Description:
 Tag:Core Data
 **********************************************************/
-(int)checkReciptsCount
{
    int count = 0;
    
    //Get Reciepts from CoreData
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"Reciept" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:desc];
    
    NSError *error;
    NSArray *data = [context executeFetchRequest:request error:&error];
    count = [data count];
    
    return count;
}
/**********************************************************
 Method: (Client *) getClientForName:(NSString *)clientName
 Description:Gets the client company name for a given (Client *)
 Tag:Utility
 **********************************************************/
- (Client *) getClientForName:(NSString *)clientName
{
    //Get Client Data from CoreData
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"Client" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.predicate = [NSPredicate predicateWithFormat:@"company = %@", clientName];
    [request setEntity:desc];
    
    NSError *error;
    NSArray *data = [context executeFetchRequest:request error:&error];
    if (data.count !=0) {
        for (Client *c in data) {
            NSLog(@"%@", c.company);
            return c;
        }
    }
    Client *cl = [[Client alloc]init];
    return cl;
}
/**********************************************************
 Method: (Client *) getClientForName:(NSString *)clientName
 Description:Gets the client company name for a given (Client *)
 Tag:Utility
 **********************************************************/
- (Invoice *) getInvoiceForNumber:(NSString *)invoiceNumber
{
    //Get Invoice Data from CoreData
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"Invoice" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.predicate = [NSPredicate predicateWithFormat:@"invoiceNumber = %@", invoiceNumber];
    [request setEntity:desc];
    
    NSError *error;
    NSArray *data = [context executeFetchRequest:request error:&error];
    if (data.count != 0) {
        for (Invoice *inv in data) {
            NSLog(@"%@", inv.invoiceNumber);
            return inv;
        }
    }
    Invoice *inv = [[Invoice alloc]init];
    return inv;
}
/**********************************************************
 Method:(void) InvoiceWithDict:(NSMutableDictionary *)dict invoiceForCharges:(Invoice *)inv
 Description:Updates an invoice object with the dictionary of invoice information.
 Tag:Core Data
 **********************************************************/
-(Invoice_charges *) InvoiceWithDict:(NSMutableDictionary *)dict invoiceForCharges:(Invoice *)inv
{
    Invoice_charges *newCharge = nil;
    newCharge = [NSEntityDescription insertNewObjectForEntityForName:@"Invoice_charges" inManagedObjectContext:context];
    
    NSString *priceStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Price"]];
    NSString *totalStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Total"]];
    NSString *vatStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"VAT"]];
    NSString *qtyStr = [NSString stringWithFormat:@"%@",[dict objectForKey:@"Qty"]];
    
    newCharge.date = [dict objectForKey:@"Date"];
    newCharge.price = priceStr;
    newCharge.desc = [dict objectForKey:@"Desc"];
    newCharge.vat = vatStr;
    newCharge.total = totalStr;
    newCharge.qty = qtyStr;
    
    return newCharge;
}
/**********************************************************
 Method:(IBAction)SaveAndPreview:(id)sender
 Description:Stores and updates invioce info
 Tag:Core Data
 **********************************************************/

- (void)SaveInvoice
{
    if ([self CheckFieldsForSave] == true) {
        Invoice *newInvoice = nil;
        newInvoice = [self getInvoiceForNumber:_invoiceField.text];
        Invoice_charges *charges = nil;
        Client *client = [self getClientForName:_clientNameField.text];
        NSLog(@"client: %@", client);
        
        [newInvoice setValue:_dateField.text forKey:@"date"];
        [newInvoice setValue:_invoiceField.text forKey:@"invoiceNumber"];
        [newInvoice setValue:_projectField.text forKey:@"projectName"];
        [newInvoice setValue:_subTotalLabel.text forKey:@"subTotal"];
        [newInvoice setValue:_totalLabel.text forKey:@"total"];
        [newInvoice setValue:_vatLabel.text forKey:@"vat"];
        [newInvoice setValue:client forKey:@"clientForInvoice"];
        [newInvoice setValue:charges forKey:@"invoice_charges"];
        
        NSMutableSet *tempSet = [[NSMutableSet alloc]init];
        
        for (NSMutableDictionary *dict in _invoiceRows)
        {
            [tempSet addObject:[self InvoiceWithDict:dict invoiceForCharges:newInvoice]];
        }
        [newInvoice setValue:tempSet forKey:@"invoice_charges"];
        
        NSError *err;
        [context save:&err];
        
        if (err) {
            NSLog(@"%@", err);
        }
    }
}
- (BOOL)CheckFieldsForSave
{
    if ([_dateField.text  isEqual: @""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You need to enter a vaild date before being able to save." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return false;
    }
    if ([_invoiceField.text  isEqual: @""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You need to enter a vaild invoice number before being able to save." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return false;
    }
    if ([_projectField.text  isEqual: @""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You need to enter a vaild project name before being able to save." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return false;
    }
    if ([_clientNameField.text  isEqual: @""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You need to select a client before being able to save." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return false;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"User_Name"] == NULL || [defaults objectForKey:@"User_Address_1"] == NULL || [defaults objectForKey:@"User_Address_2"] == NULL)
    {
        [self SaveInvoice];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Some info missing" message:@"Please go to the setting menu as your information is missing. Your invoice has been saved so you can return later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return false;
    }
    return true;
}
- (IBAction)DeleteInvoice:(id)sender
{
    
    [self deleteInvoiceWithNumber:_invoiceField.text];
    [self.delegate reloadTableFromDetailView];
    [self ClearFields];
}

- (IBAction)MarkAsPaid:(id)sender
{
    Invoice *inv = [self getInvoiceForNumber:_invoiceField.text];
    NSNumber *n = [[NSNumber alloc]initWithInt:1];
    inv.paid = n;
    
    NSError *err;
    [context save:&err];
    
    if (err) {
        NSLog(@"%@", err);
    }
    [self.delegate reloadTableFromDetailView];
}

- (IBAction)addItem:(id)sender {
}

- (IBAction)editItems:(id)sender
{
    {
        NSLog(@"Entered Editing Mode....");
        
        if (self.chargesTableView.editing == NO)
        {
            _editBtn.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
            [self.chargesTableView setEditing: YES animated: YES];
        }
        else
        {
            NSLog(@"End Editing Mode....");
            _editBtn.tintColor = nil;
            
            [self.chargesTableView setEditing: NO animated: YES];
        }
    }
}
-(void)clearFields
{
    _projectField.text = @"";
    _invoiceField.text = @"";
    _dateField.text = @"";
    _clientNameField.text = @"";
    _subTotalLabel.text = @"";
    _vatLabel.text = @"";
    _totalLabel.text = @"";
    _invoiceRows = nil;
}
-(void)fillDetailViewWithInvoiceData:(Invoice *)invoice fromSender:(id)sender
{
    _noInvoiceImage.hidden = YES;
    self.delegate = sender;
    
        if (invoice.projectName != NULL) {
               self.projectField.text = invoice.projectName;
        }
            if (invoice.invoiceNumber != NULL) {
                    self.invoiceField.text = invoice.invoiceNumber;
            }
                if (invoice.date != NULL) {
                        self.dateField.text = invoice.date;
                }
                    if (invoice.subTotal != NULL) {
                            self.subTotalLabel.text = invoice.subTotal;
                    }
                        if (invoice.vat != NULL) {
                                self.vatLabel.text = invoice.vat;
                        }
                            if (invoice.total != NULL) {
                                    self.totalLabel.text = invoice.total;
                            }
    
        //Client Data
        Client *client = invoice.clientForInvoice;
        if (client != nil) {
            NSLog(@"%@",client);
            clientSelected = client;
          self.clientNameField.text = client.company;
        }
    
        //Table View Data
        NSSet *chargesSet = invoice.invoice_charges;
        NSLog(@"Charges Set: %@", chargesSet);
        if ([chargesSet count] != 0) {
        NSLog(@"%lu", (unsigned long)chargesSet.count);
        NSLog(@"%@", invoice.projectName);
        
        
        for (Invoice_charges *invChg in chargesSet)
        {
            
            NSLog(@"%@", invChg.date);
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];

            
            [dict setObject:invChg.date forKey:@"Date"];
            [dict setObject:invChg.desc forKey:@"Desc"];
            [dict setObject:invChg.price forKey:@"subTotal"];
            [dict setObject:invChg.vat forKey:@"VAT"];
            [dict setObject:invChg.total forKey:@"Total"];
            [dict setObject:invChg.qty forKey:@"Qty"];
            [_invoiceRows addObject:dict];
            
            //set dict to nil
            dict = nil;
        }
    }
    else
    {
        [_invoiceRows removeAllObjects];

    }
    [self.chargesTableView reloadData];
}
/**********************************************************
 Method:(void) addChargeViewController:(AddChargeTableViewController *)sender chargeDictionary:(id)dict
 Description:Custom delegate method from the popover to add a charge tio the table.
 Tag:Custom Delegate
 **********************************************************/
- (void)addChargeViewController:(AddChargeTableViewController *)sender chargeDictionary:(id)dict
{
    [_invoiceRows addObject:dict];
    [self.chargesTableView reloadData];
    float fl = [[dict objectForKey:@"subTotal"]floatValue];
    NSLog(@"total - %f", fl);
    NSLog(@"%lu", (unsigned long)[_invoiceRows count]);
    
    NSLog(@"Dictionary Added: %@",dict);
    
    [self updateLabels];
    
}
/**********************************************************
 Method:(void)updateLabels
 Description:Updates the total, vat and subtotal labels based on the array of charges.
 Tag:Math / UIStuff
 **********************************************************/
-(void)updateLabels
{
    float subTotal = 0.00;
    float vat = 0.00;
    float total = 0.00;
    
    for (NSMutableDictionary *dict in _invoiceRows)
    {

        float flSub = [[dict objectForKey:@"subTotalFL"]floatValue];
        float flVat = [[dict objectForKey:@"vatFL"]floatValue];
        float flTotal = [[dict objectForKey:@"totalFL"]floatValue];
        
        
        subTotal += flSub;
        vat += flVat;
        
        NSLog(@"%f",flSub);
        NSLog(@"%f",flVat);
        NSLog(@"%f",flTotal);
    }
    total = subTotal+vat;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *subTotalAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:subTotal]];
    NSString *vatAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:vat]];
    NSString *totalAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:total]];
    
    NSLog(@"%@",subTotalAsString);
    NSLog(@"%@",vatAsString);
    NSLog(@"%@",totalAsString);

    _subTotalLabel.text = subTotalAsString;
    _vatLabel.text = vatAsString;
    _totalLabel.text = totalAsString;
}
/**********************************************************
 Method:(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 Description:Segue delegate methods (Overidden)
 Tag:Segue
 **********************************************************/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
   // [segue.destinationViewController setDelegate:self];
    if ([segue.identifier isEqualToString:@"client_segue"]) {
  
        [segue.destinationViewController setDelegate:self];
    }
    if ([segue.identifier isEqualToString:@"charge_detail_segue"]) {
        
        [segue.destinationViewController setDelegate:self];
        
    }
    if ([segue.identifier isEqualToString:@"Preview Segue"]) {
        

        [self SaveInvoice];
        
        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
        [mutableDict setObject:_clientNameField.text forKey:@"name"];
        
        //Proj Details
        [mutableDict setValue:_projectField.text forKey:@"projectName"];
        [mutableDict setValue:_invoiceField.text forKey:@"invoiceNumber"];
        [mutableDict setValue:_dateField.text forKey:@"invoiceDate"];
        
        NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:mutableDict];
        
        NSString *fileCreated = [PDFPublisherController PublishPDFWithData:_invoiceRows withClientDetails:dict forClient:clientSelected];
        PDFViewController *pvc = segue.destinationViewController;
        pvc.fileName = _invoiceField.text;
        pvc.filePath = fileCreated;
        pvc.client = clientSelected;
        pvc.projectName = _projectField.text;
        pvc.inv = [self getInvoiceForNumber:_invoiceField.text];
    }
    if ([segue.identifier isEqualToString:@"camera_segue"])
    {
        CameraRecieptViewController *crvc = segue.destinationViewController;
        crvc.invoice = [self getInvoiceForNumber:_invoiceField.text];
        crvc.delegate = self;
    }
    NSLog(@"SEGUE to: %@", segue.identifier);
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Preview Segue"]) {
        if ([self CheckFieldsForSave] == false) {
        return NO;
        }
    }
    return YES;
}
-(void)CameraDelegateDone
{
    if (recieptCount == 0) {
        _recieptsAttachedLabel.hidden = YES;
    }
    else
    {
        _recieptsAttachedLabel.hidden = NO;
        NSString *str = [NSString stringWithFormat:@"%d Reciepts Attached", recieptCount];
        _recieptsAttachedLabel.text = str;
    }
}
/**********************************************************
 Method:(void)PassClientFromPickerWithClient:(NSString *)client withSender:(id)sender
 Description:Pass Client Name from picker
 Tag:
 **********************************************************/
-(void)PassClientFromPickerWithClient:(NSString *)client withSender:(id)sender
{
    NSLog(@"INV Client - %@", client);
    _clientNameField.text = client;
    clientSelected = [self getClientForName:client];
    
}
#pragma TableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
	
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_invoiceRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Drawing: %ld", (long)indexPath.row);
    
    
    static NSString *CellIdentifier = @"Invoice_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    //Build Table Header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 722, 40)];
    //headerView.backgroundColor = [UIColor grayColor];
    UILabel *header1View = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 90, 20)];
    header1View.text = @"Date";
    UILabel *header2View = [[UILabel alloc] initWithFrame:CGRectMake(110, 15, 240, 20)];
    header2View.text = @"Description";
    UILabel *header3View = [[UILabel alloc] initWithFrame:CGRectMake(360, 15, 80, 20)];
    header3View.text = @"Price";
    UILabel *header4View = [[UILabel alloc] initWithFrame:CGRectMake(450, 15, 40, 20)];
    header4View.text = @"Qty";
    UILabel *header5View = [[UILabel alloc] initWithFrame:CGRectMake(500, 15, 50, 20)];
    header5View.text = @"Vat";
    UILabel *header6View = [[UILabel alloc] initWithFrame:CGRectMake(570, 15, 80, 20)];
    header6View.text = @"Total";
    
    [headerView addSubview:header1View];
    [headerView addSubview:header2View];
    [headerView addSubview:header3View];
    [headerView addSubview:header4View];
    [headerView addSubview:header5View];
    [headerView addSubview:header6View];
    self.chargesTableView.tableHeaderView = headerView;
    
    NSMutableDictionary *currentDict = [[NSMutableDictionary alloc]init];
    
    NSLog(@"Charges Dict: %@", currentDict);
    
    currentDict = [_invoiceRows objectAtIndex:indexPath.row];
    //cell.textLabel.text = [currentDict objectForKey:@"Desc"];
    
    CGRect dateFrame = CGRectMake(10, 15, 90, 20);
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:dateFrame];
    dateLabel.tag = 0011;
    //dateLabel.backgroundColor =[UIColor blueColor];
    dateLabel.font = [UIFont systemFontOfSize:16];
    dateLabel.text = [currentDict objectForKey:@"Date"];
    [cell.contentView addSubview:dateLabel];
    
    CGRect descFrame = CGRectMake(110, 15, 240, 20);
    UILabel *descLabel = [[UILabel alloc] initWithFrame:descFrame];
    descLabel.tag = 0011;
    //descLabel.backgroundColor =[UIColor purpleColor];
    descLabel.font = [UIFont systemFontOfSize:16];
    descLabel.text = [currentDict objectForKey:@"Desc"];
    [cell.contentView addSubview:descLabel];
    
    CGRect priceFrame = CGRectMake(360, 15, 80, 20);
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:priceFrame];
    priceLabel.tag = 0011;
    //priceLabel.backgroundColor =[UIColor blueColor];
    priceLabel.font = [UIFont systemFontOfSize:16];
    priceLabel.text = [currentDict objectForKey:@"subTotal"];
    [cell.contentView addSubview:priceLabel];
    
    CGRect qtyFrame = CGRectMake(450, 15, 40, 20);
    UILabel *qtyLabel = [[UILabel alloc] initWithFrame:qtyFrame];
    qtyLabel.tag = 0011;
    //qtyLabel.backgroundColor =[UIColor blueColor];
    qtyLabel.font = [UIFont systemFontOfSize:16];
    qtyLabel.text = [currentDict objectForKey:@"Qty"];
    [cell.contentView addSubview:qtyLabel];
    
    CGRect vatFrame = CGRectMake(500, 15, 50, 20);
    UILabel *vatLabel = [[UILabel alloc] initWithFrame:vatFrame];
    vatLabel.tag = 0011;
    //vatLabel.backgroundColor =[UIColor blueColor];
    vatLabel.font = [UIFont systemFontOfSize:16];
    vatLabel.text = [currentDict objectForKey:@"VAT"];
    [cell.contentView addSubview:vatLabel];
    
    
    CGRect totalFrame = CGRectMake(570, 15, 80, 20);
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:totalFrame];
    totalLabel.tag = 0011;
    //totalLabel.backgroundColor =[UIColor redColor];
    totalLabel.font = [UIFont systemFontOfSize:16];
    totalLabel.text = [currentDict objectForKey:@"Total"];
    [cell.contentView addSubview:totalLabel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _clientNameField) {
        [self performSegueWithIdentifier: @"client_segue" sender: self];
        return NO;
    }
    else
    {
        return YES;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        Invoice_charges *chg = [_invoiceRows objectAtIndex:indexPath.row];
        
        [_invoiceRows removeObject:chg];
        [tableView reloadData];
        NSLog(@"DELETE ROW NUMBER %ld", (long)indexPath.row);
    }
}

- (void)ClearFields
{
    self.projectField.text = @"";
    self.invoiceField.text = @"";
    self.dateField.text = @"";
    self.subTotalLabel.text = @"";
    self.vatLabel.text = @"";
    self.totalLabel.text = @"";
    self.clientNameField.text = @"";
    _invoiceRows = nil;
    [self.chargesTableView reloadData];
}

@end
