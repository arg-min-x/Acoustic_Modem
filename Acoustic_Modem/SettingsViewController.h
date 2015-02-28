//
//  SettingsViewController.h
//  Acoustic_Modem
//
//  Created by Adam V. Rich on 2/24/15.
//  Copyright (c) 2015 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

// Properties
@property (strong, nonatomic) IBOutlet UITextField *carrierFrequencyInput;  //carrier frequency input box
@property (strong, nonatomic) IBOutlet UITextField *oversampleInput;        // oversample input box
@property (strong, nonatomic) IBOutlet UITextField *rollOffFactorInput;     // roll off factor input box
@property (strong, nonatomic) IBOutlet UITextField *nPeriodsInput;          // number of periord input box
@property (strong, nonatomic) IBOutlet UIButton *backButton;                // back to transmit page button
@property (strong, nonatomic) IBOutlet UISwitch *enableQPSK;                // use QPSK switch
@property (strong, nonatomic) IBOutlet UISwitch *carrierFrequencyOnlySwitch;// carrier frequency onl switch

@property (nonatomic) float carrierFrequency;       // carrier frequency
@property (nonatomic) int oversample;               // oversamplig factor
@property (nonatomic) float rollOffFactor;          // roll off factor
@property (nonatomic) int nPeriods;                 // number of periods
@property (nonatomic) BOOL isBPSK;                  // use BPSK if true
@property (nonatomic) BOOL carrierFrequencyOnly;    // transmit only the carrier frequency if true

// Methods
-(NSUInteger)supportedInterfaceOrientations;        // Lock screen orientation to portrait

@end
