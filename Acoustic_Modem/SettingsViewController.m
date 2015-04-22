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
    // disable back button until settings are saved
    self.backButton.enabled = NO;
    self.backButton.alpha = 0.4;
    
    // set the values in the boxes based on the current settings
    self.carrierFrequencyInput.text = [NSString stringWithFormat:@"%.0f",self.carrierFrequency];
    self.oversampleInput.text = [NSString stringWithFormat:@"%d", self.oversample];
    self.nPeriodsInput.text = [NSString stringWithFormat:@"%d",self.nPeriods];
    self.rollOffFactorInput.text = [NSString stringWithFormat:@"%.2f",self.rollOffFactor];
    self.enableQPSK.on = !self.isBPSK;
    self.carrierFrequencyOnlySwitch.on = self.carrierFrequencyOnly;
    
    // Set BPSK or QPSK based on input contorller value
    self.BPSKTextLabel.font = [UIFont systemFontOfSize:12];
    self.QPSKTextLabel.font = [UIFont systemFontOfSize:12];
    if (self.isBPSK == true){
        self.BPSKTextLabel.alpha = 1;
        self.BPSKTextLabel.font = [UIFont boldSystemFontOfSize:12];
        self.QPSKTextLabel.alpha = 0.4;
        self.QPSKTextLabel.font = [UIFont systemFontOfSize:12];
        self.isBPSKSwitch.on = false;
    }
    else{
        self.QPSKTextLabel.alpha = 0.4;
        self.QPSKTextLabel.font = [UIFont systemFontOfSize:12];
        self.BPSKTextLabel.alpha = 1;
        self.BPSKTextLabel.font = [UIFont boldSystemFontOfSize:12];
        self.isBPSKSwitch.on = true;
    }
    
    // Set the barker13 or random51 based on the value from input controller
    self.barkerUITextLabel.font = [UIFont systemFontOfSize:12];
    self.random51TextLabel.font = [UIFont systemFontOfSize:12];
    if (self.isBarker13 == true){
        self.barkerUITextLabel.alpha = 1;
        self.barkerUITextLabel.font = [UIFont boldSystemFontOfSize:12];
        self.random51TextLabel.alpha = 0.4;
        self.random51TextLabel.font = [UIFont systemFontOfSize:12];
        self.barker13Switch.on = false;
    }
    else{
        self.barkerUITextLabel.alpha = 0.4;
        self.barkerUITextLabel.font = [UIFont systemFontOfSize:12];
        self.random51TextLabel.alpha = 1;
        self.random51TextLabel.font = [UIFont boldSystemFontOfSize:12];
        self.barker13Switch.on = true;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// switch between barker and random 51
- (IBAction)setBarker13Pilot:(id)sender {
    if (self.barker13Switch.on == false){
        self.barkerUITextLabel.alpha = 1;
        self.barkerUITextLabel.font = [UIFont boldSystemFontOfSize:12];
        self.random51TextLabel.alpha = 0.4;
        self.random51TextLabel.font = [UIFont systemFontOfSize:12];
        self.isBarker13 = true;
    }
    else{
        self.barkerUITextLabel.alpha = 0.4;
        self.barkerUITextLabel.font = [UIFont systemFontOfSize:12];
        self.random51TextLabel.alpha = 1;
        self.random51TextLabel.font = [UIFont boldSystemFontOfSize:12];
        self.isBarker13 = false;
    }

}
- (IBAction)setBPSK:(id)sender {
    if (self.isBPSKSwitch.on == false){
        self.BPSKTextLabel.alpha = 1;
        self.BPSKTextLabel.font = [UIFont boldSystemFontOfSize:12];
        self.QPSKTextLabel.alpha = 0.4;
        self.QPSKTextLabel.font = [UIFont systemFontOfSize:12];
        self.isBPSK = true;
    }
    else{
        self.QPSKTextLabel.alpha = 1;
        self.QPSKTextLabel.font = [UIFont boldSystemFontOfSize:12];
        self.BPSKTextLabel.alpha = 0.4;
        self.BPSKTextLabel.font = [UIFont systemFontOfSize:12];
        self.isBPSK = false;
    }
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
    
    // Check if the BPSK switch is checked and set isBPSK
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
