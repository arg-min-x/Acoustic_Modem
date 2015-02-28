//
//  SettingsViewController.m
//  Acoustic_Modem
//
//  Created by Adam V. Rich on 2/24/15.
//  Copyright (c) 2015 Adam. All rights reserved.
//

#import "SettingsViewController.h"
#import "InputViewController.h"

@interface SettingsViewController (){
//    NSArray * _BPSKorQPSKPickerData;
}
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backButton.enabled = NO;
    self.backButton.alpha = 0.4;
    
    self.carrierFrequencyInput.text = [NSString stringWithFormat:@"%.0f",self.carrierFrequency];
    self.oversampleInput.text = [NSString stringWithFormat:@"%d", self.oversample];
    self.nPeriodsInput.text = [NSString stringWithFormat:@"%d",self.nPeriods];
    self.rollOffFactorInput.text = [NSString stringWithFormat:@"%.2f",self.rollOffFactor];
    self.enableQPSK.on = !self.isBPSK;
    self.carrierFrequencyOnlySwitch.on = self.carrierFrequencyOnly;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveParameters:(id)sender {
    // Remove Keyboards when saving
    [self.carrierFrequencyInput resignFirstResponder];
    [self.oversampleInput resignFirstResponder];
    [self.rollOffFactorInput resignFirstResponder];
    [self.nPeriodsInput resignFirstResponder];
    
    // Get the parameters from the view controller
    NSString * tmp = self.carrierFrequencyInput.text;
    self.carrierFrequency = [tmp floatValue];
    
    tmp = self.oversampleInput.text;
    self.oversample = [tmp intValue];
    
    tmp = self.rollOffFactorInput.text;
    self.rollOffFactor = [tmp floatValue];
    
    tmp = self.nPeriodsInput.text;
    self.nPeriods = [tmp intValue];
    
    // Check if the BPSK switch is checked ans set isBPSK
    BOOL isEnabledQPSK = self.enableQPSK.on;
    if (isEnabledQPSK== 0) {
        self.isBPSK = true;
    }
    else{
        self.isBPSK = false;
    }
    
    // Check if the carrier frequency only mode is checked and set carrierFrequencyOnly
    BOOL isEnabledcarrierFrequencyOnly = self.carrierFrequencyOnlySwitch.on;
    if (isEnabledcarrierFrequencyOnly== 1) {
        self.carrierFrequencyOnly = true;
    }
    else{
        self.carrierFrequencyOnly = false;
    }
    
    // Enable Back button after save
    self.backButton.enabled = YES;
    self.backButton.alpha = 1;
}

// Remove keyboards if the user touches anywhere on the screen
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.carrierFrequencyInput resignFirstResponder];
    [self.oversampleInput resignFirstResponder];
    [self.rollOffFactorInput resignFirstResponder];
    [self.nPeriodsInput resignFirstResponder];
    
}

// Lock orientation into portrait orientation
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
