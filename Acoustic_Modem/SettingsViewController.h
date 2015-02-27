//
//  SettingsViewController.h
//  Acoustic_Modem
//
//  Created by Adam V. Rich on 2/24/15.
//  Copyright (c) 2015 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *carrierFrequencyInput;
@property (strong, nonatomic) IBOutlet UITextField *oversampleInput;
@property (strong, nonatomic) IBOutlet UITextField *rollOffFactorInput;
@property (strong, nonatomic) IBOutlet UITextField *nPeriodsInput;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UISwitch *enableQPSK;
@property (strong, nonatomic) IBOutlet UISwitch *carrierFrequencyOnlySwitch;

@property (nonatomic) float carrierFrequency;
@property (nonatomic) int oversample;
@property (nonatomic) float rollOffFactor;
@property (nonatomic) int nPeriods;
@property (nonatomic) BOOL isBPSK;
@property (nonatomic) BOOL carrierFrequencyOnly;
//@property (nonatomic) float carrierFrequency;
//@property (strong, nonatomic) int * carrierFrequency;


@end
