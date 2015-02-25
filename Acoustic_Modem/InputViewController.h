//
//  ViewController.h
//  Acoustic_Modem
//
//  Created by Adam V. Rich on 2/24/15.
//  Copyright (c) 2015 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "acousticModemTransfer.h"

@interface InputViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *textInputField;

@property (strong, nonatomic) IBOutlet UIButton *transmitSignalButton;
-(IBAction)unwindToInputController:(UIStoryboardSegue *)segue;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;
@property (strong, nonatomic) acousticModemTransfer * modemTransferOb;
@end

