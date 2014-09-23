//
//  PurchaseViewController.m
//  CarPooling
//
//  Created by atk's mac on 28/08/14.
//  Copyright (c) 2014 gizmeon. All rights reserved.
//

#import "PurchaseViewController.h"

@interface PurchaseViewController ()
{
    MobiKwikSDK *payments;
    NSUserDefaults *prefs;
    NSString *user_id;
}
@end

@implementation PurchaseViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.Scroller setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    self.orderIdLabel.text=[self generateUniqueOrderId];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(KeyboardShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(KeyboardHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    prefs= [NSUserDefaults standardUserDefaults];
    user_id=[prefs stringForKey:@"id"];
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlackTranslucent;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(DoneButtonClicked:)];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    [self.amountField setInputAccessoryView:keyboardDoneButtonView];
    [self.phoneNoField setInputAccessoryView:keyboardDoneButtonView];
    [self.emailIdField setInputAccessoryView:keyboardDoneButtonView];
    [self.CardNoField setInputAccessoryView:keyboardDoneButtonView];
    [self.expiryDate setInputAccessoryView:keyboardDoneButtonView];
    [self.cvvField setInputAccessoryView:keyboardDoneButtonView];
    [self.payOptionField setInputAccessoryView:keyboardDoneButtonView];
    
    //[self.amountField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.phoneNoField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.emailIdField setKeyboardType:UIKeyboardTypeAlphabet];
    [self.CardNoField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.expiryDate setKeyboardType:UIKeyboardTypeNumberPad];
    [self.cvvField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.payOptionField setKeyboardType:UIKeyboardTypeAlphabet];
    
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(FetchingPayResponse:)
                                                 name:@"MobiSDK_response"
                                               object:nil];
}

- (NSString *)generateUniqueOrderId
{
    
    NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970]*10000;
    NSString *intervalString = [NSString stringWithFormat:@"%f", timeInMiliseconds];
    
    return [intervalString componentsSeparatedByString:@"."][0];
}



- (void)FetchingPayResponse:(NSNotification *) notification
{
    NSMutableDictionary *response;
    
    
    if ([[notification name] isEqualToString:@"MobiSDK_response"])
    {
        NSLog(@"I got this response ");
        NSLog(@"%@",[payments showPaymentResponse]);
        response = [[NSMutableDictionary alloc] initWithDictionary:[payments showPaymentResponse]];
        
        
        double delay = 0.7;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            UIAlertView *Status = [[UIAlertView alloc] initWithTitle:@"Transaction Status" message:[NSString stringWithFormat:@"Amount : %@\nOrder ID : %@\nStatus Code : %@\nMessage : %@\n",[response objectForKey:@"amount"],[response objectForKey:@"orderid"],[response objectForKey:@"statuscode"],[response objectForKey:@"statusmessage"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
          //  [Status show];
           
            
        });

        NSString *code=[NSString stringWithFormat:@"%@",[response objectForKey:@"statuscode"]];
        if([code isEqualToString:@"0"])
        {
      [self updateRidePoints:[response objectForKey:@"amount"] transID:[response objectForKey:@"orderid"] status:[response objectForKey:@"statusmessage"]];
        }
        else
        {
            [self ShowAlertStatus:@"Transaction unsuccessfull.Please provide a valid 13 to 19 digits card number!"];
        }
    
    }
    
}

-(void) updateRidePoints:(NSString*)amount transID:(NSString*)transId status:(NSString*)status
{
    [WTStatusBar setLoading:YES loadAnimated:YES];
    ConnectToServer=[[ServerConnection alloc] init];
    NSString *postData=[NSString stringWithFormat:@"userId=%@&amount=%@&transactionid=%@&status=%@&type=%@&ridepoints=%@",user_id,amount,transId,status,transId,amount];
    NSMutableURLRequest *paymentRespose=[ConnectToServer RequestServer:kServerLink_setPayment post:postData];
    dispatch_async(kBgQueue, ^{
        NSError *err;
        NSURLResponse *response;
        NSData *data= [NSURLConnection sendSynchronousRequest:paymentRespose  returningResponse:&response error:&err];
        if(!err){
            [self performSelectorOnMainThread:@selector(parsePaymentResponse:)
                                   withObject:data waitUntilDone:YES];
        }
        else{
            [WTStatusBar setLoading:NO loadAnimated:NO];
            [WTStatusBar clearStatus];
            [self ShowAlertView:UnableToProcess];
            
        }
        
    });

}

-(void)parsePaymentResponse:(NSData*)response
{
    NSError *jsonParsingError;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:response
                                                         options:0 error:&jsonParsingError];
    NSLog(@"Payment Response %@",data);
    NSString *result=[data objectForKey:@"status"];
    if(!jsonParsingError)
    {
    if([result isEqualToString:@"success"])
    {
        [WTStatusBar setLoading:NO loadAnimated:NO];
        [WTStatusBar clearStatus];
        [self ShowAlertStatus:@"Transaction successfull"];
    }
    else
    {
        [WTStatusBar setLoading:NO loadAnimated:NO];
        [WTStatusBar clearStatus];
        [self ShowAlertStatus:@"Transaction unsuccessfull"];
    }}
    else{
        [WTStatusBar setLoading:NO loadAnimated:NO];
        [WTStatusBar clearStatus];
        [self ShowAlertView:UnableToProcess];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)DoneButtonClicked:(id)sender
{
    [self.amountField resignFirstResponder];
    [self.phoneNoField resignFirstResponder];
    [self.emailIdField resignFirstResponder];
    [self.CardNoField resignFirstResponder];
    [self.expiryDate resignFirstResponder];
    [self.cvvField resignFirstResponder];
    [self.payOptionField resignFirstResponder];
}

-(void)fillUP
{
    UIAlertView *blank = [[UIAlertView alloc] initWithTitle:@"Blank Field" message:@"Fill all the details" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [blank show];
}

- (IBAction)payButtonAction:(id)sender {
    payments = [[MobiKwikSDK alloc] init];
    
    if ([[self.amountField text] isEqualToString:@""]){  [self fillUP];  }
    else
    {
        NSString *debitWalletState;
        
        if ([self.debitWalletSelector isOn])
        {
            debitWalletState = @"true";
        }
        else
        {
            debitWalletState = @"false";
        }
        
        
        NSMutableDictionary *TxnData = [[NSMutableDictionary alloc] init];
        
        [TxnData removeAllObjects];
        
        [TxnData setObject:self.amountField.text forKey:@"Amount"];
        [TxnData setObject:debitWalletState forKey:@"DebitWallet"];
        [TxnData setObject:self.orderIdLabel.text forKey:@"OrderID"];
        
        
        if (self.phoneNoField.text.length != 0)
        {
            [TxnData setObject:[self.phoneNoField text] forKey:@"PhoneNo"];
        }
        
        if (self.emailIdField.text.length != 0)
        {
            [TxnData setObject:[self.emailIdField text] forKey:@"EmailID"];
        }
        
        
        if (self.CardNoField.text.length == 0)
        {
            [TxnData setObject:[self.payOptionField text] forKey:@"paymentOption"];
        }
        else
        {
            [TxnData setObject:[self.CardNoField text] forKey:@"cardNumber"];
            [TxnData setObject:[self.expiryDate text] forKey:@"cardExpiry"];
            [TxnData setObject:[self.cvvField text] forKey:@"cardCVV"];
            
        }
        
        NSLog(@"%@",TxnData);
        
        [payments StartTransaction_withData:TxnData];
        
        
    }

    
}

- (IBAction)DebitWalletSelector:(id)sender {
    [UIView animateWithDuration:0.25f
                          delay:0.05f
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         
                         [self.debitWalletLabel setAlpha:0.0];
                     }
                     completion:^(BOOL finished) {
                         
                         if ([self.debitWalletSelector isOn])
                         {
                             [self.debitWalletLabel setText:@"TRUE"];
                         }
                         else
                         {
                             [self.debitWalletLabel setText:@"FALSE"];
                         }
                         
                         
                         [UIView animateWithDuration:0.25f
                                               delay:0.05f
                                             options:UIViewAnimationOptionTransitionCrossDissolve
                                          animations:^{
                                              
                                              [self.debitWalletLabel setAlpha:1.0];
                                          }
                                          completion:nil];
                         
                         
                     }];

}


- (void)KeyboardShown:(NSNotification*)notification
{
    
    [self.Scroller setContentInset:UIEdgeInsetsMake(0, 0, self.Scroller.frame.size.height + 44+216, 0)];
    
}


- (void)KeyboardHidden:(NSNotification*)notification
{
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.Scroller setContentOffset:CGPointMake(0, 0)];
        
    } completion:^(BOOL finished) {
        
        [self.Scroller setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
    }];
    
    
}

-(void)ShowAlertView:(NSString*)Message{
    UIAlertView * Alerts = [[UIAlertView alloc ]initWithTitle:kApplicationName message:Message delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alerts show];
}

-(void)ShowAlertStatus:(NSString*)Message{
    UIAlertView * Alerts = [[UIAlertView alloc ]initWithTitle:@"Transaction Status" message:Message delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
    [Alerts show];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
