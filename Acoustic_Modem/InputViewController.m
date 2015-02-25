//
//  ViewController.m
//  Acoustic_Modem
//
//  Created by Adam V. Rich on 2/24/15.
//  Copyright (c) 2015 Adam. All rights reserved.
//

#import "InputViewController.h"
#import "SettingsViewController.h"
#import "string.h"
#import <AudioToolbox/AudioToolbox.h>
#include <complex.h>
#include "math.h"
#include "AudioController.h"

@interface InputViewController ()
@property (strong, nonatomic) AudioController *audioController;
@end

@implementation InputViewController


-(IBAction)unwindToInputController:(UIStoryboardSegue *)sender{
    SettingsViewController * properties = [sender sourceViewController]; //getting properties
    self.modemTransferOb.carrierFrequency = properties.carrierFrequency;
    self.modemTransferOb.oversample = properties.oversample;
    self.modemTransferOb.rollOffFactor = properties.rollOffFactor;
    self.modemTransferOb.nPeriods = properties.nPeriods;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.modemTransferOb = [[acousticModemTransfer alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitForTransmission:(id)sender {
    [self.textInputField resignFirstResponder];
//    self.transmitSignalButton.enabled = NO;
//    self.transmitSignalButton.alpha = 0.4;
//    self.settingsButton.enabled = NO;
//    self.settingsButton.alpha = 0.4;
    //    [modemTransferOb QPSKsymbols];
    //    [modemTransferOb zerosQPSK];
    //    [modemTransferOb PulseShape];
    //    [modemTransferOb QPSKconvolutionandmodulation];
    [self.modemTransferOb getInputString:self.textInputField.text];
    [self.modemTransferOb BPSKsymbols];
    [self.modemTransferOb Addinzeros];
    [self.modemTransferOb PulseShape];
    [self.modemTransferOb BPSKconvolutionandmodulation];
    [self.modemTransferOb converttoAudio];
    
    // Initialize audio controller
    self.audioController = [[AudioController alloc] init];
    [self.audioController getFileURL:(self.modemTransferOb.fileURL)];
    [self.audioController configureAudioPlayer];
    [self.audioController tryPlayMusic];
    
//    self.transmitSignalButton.enabled = YES;
//    self.transmitSignalButton.alpha = 1;
//    self.settingsButton.enabled = YES;
//    self.settingsButton.alpha = 0.4;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textInputField resignFirstResponder];
}

@end
