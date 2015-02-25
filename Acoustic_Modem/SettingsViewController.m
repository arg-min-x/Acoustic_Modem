//
//  SettingsViewController.m
//  Acoustic_Modem
//
//  Created by Adam V. Rich on 2/24/15.
//  Copyright (c) 2015 Adam. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backButton.enabled = NO;
    self.backButton.alpha = 0.4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveParameters:(id)sender {
    NSString * tmp = self.carrierFrequencyInput.text;
    self.carrierFrequency = [tmp floatValue];
    
    tmp = self.oversampleInput.text;
    self.oversample = [tmp intValue];
    
    tmp = self.rollOffFactorInput.text;
    self.rollOffFactor = [tmp floatValue];
    
    tmp = self.nPeriodsInput.text;
    self.nPeriods = [tmp intValue];

    [self.carrierFrequencyInput resignFirstResponder];
    [self.oversampleInput resignFirstResponder];
    [self.rollOffFactorInput resignFirstResponder];
    [self.nPeriodsInput resignFirstResponder];
    
    self.backButton.enabled = YES;
    self.backButton.alpha = 1;

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.carrierFrequencyInput resignFirstResponder];
    [self.oversampleInput resignFirstResponder];
    [self.rollOffFactorInput resignFirstResponder];
    [self.nPeriodsInput resignFirstResponder];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
