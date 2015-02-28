//
//  ViewController.h
//  Acoustic_Modem
//
//  Created by Adam V. Rich on 2/24/15.
//  Copyright (c) 2015 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "acousticModemTransfer.h"

// Properties
@interface InputViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *textInputField;     // string input text field
@property (strong, nonatomic) IBOutlet UIButton *transmitSignalButton;  // transmit signal button
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;        // access settings button
@property (strong, nonatomic) acousticModemTransfer * modemTransferOb;  // instantiation of modem transfer

// Methods
-(IBAction)unwindToInputController:(UIStoryboardSegue *)segue;// Get settings from settings view controller
-(NSUInteger)supportedInterfaceOrientations;                  // Lock screen orientation to portrait
@end

