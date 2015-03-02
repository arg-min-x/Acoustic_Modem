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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.modemTransferOb = [[acousticModemTransfer alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)pushToSettingsViewController{
    SettingsViewController *settingsVCOb = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    
    settingsVCOb.carrierFrequency = self.modemTransferOb.carrierFrequency;
    settingsVCOb.oversample = self.modemTransferOb.oversample;
    settingsVCOb.nPeriods = self.modemTransferOb.nPeriods;
    settingsVCOb.rollOffFactor = self.modemTransferOb.rollOffFactor;
    settingsVCOb.isBPSK = self.modemTransferOb.isBPSK;
    settingsVCOb.carrierFrequencyOnly = self.modemTransferOb.carrierFrequencyOnly;
    settingsVCOb.isBarker13 = self.modemTransferOb.isBarker13;
    
    [self presentViewController:settingsVCOb animated:YES completion:nil];
}

-(IBAction)unwindToInputController:(UIStoryboardSegue *)sender{
    SettingsViewController * properties = [sender sourceViewController]; //getting properties
    self.modemTransferOb.carrierFrequency = properties.carrierFrequency;
    self.modemTransferOb.oversample = properties.oversample;
    self.modemTransferOb.rollOffFactor = properties.rollOffFactor;
    self.modemTransferOb.nPeriods = properties.nPeriods;
    self.modemTransferOb.isBPSK = properties.isBPSK;
    self.modemTransferOb.carrierFrequencyOnly = properties.carrierFrequencyOnly;
    self.modemTransferOb.isBarker13 = properties.isBarker13;
}

- (IBAction)submitForTransmission:(id)sender {
    [self disableButtons];  // Disable Buttons
    // Clear Text Keyboard if still there
    [self.textInputField resignFirstResponder];
    self.modemTransferOb.carrierFrequencyOnly = false;
    
    // Get the Input string
    [self.modemTransferOb getInputString:self.textInputField.text];
    
        // Choose between BPSK ans QPSK
    if  (self.modemTransferOb.isBPSK == 1){
        [self.modemTransferOb BPSKsymbols];                 // Convert characters to symbols
        [self.modemTransferOb Addinzeros];                  // Upsample
        [self.modemTransferOb PulseShape];                  // Create Pulse Shaping Filter
        [self.modemTransferOb BPSKconvolutionandmodulation];// Filter the upsampled bits
    }
    else{
        [self.modemTransferOb QPSKsymbols];                 // Convert characters to symbols
        [self.modemTransferOb zerosQPSK];                   // Upsample
        [self.modemTransferOb PulseShape];                  // Create Pulse Shaping Filter
        [self.modemTransferOb QPSKconvolutionandmodulation];// Filter the upsampled bits
    }

    [self.modemTransferOb converttoAudio];                      // Convert the Signal to Audio
    
    // Initialize audio controller
    self.audioController = [[AudioController alloc] init];
    [self.audioController configureAudioSession];
    [self.audioController getFileURL:(self.modemTransferOb.fileURL)];
    [self.audioController configureAudioPlayer];
    [self.audioController tryPlaySound];                        // Play the signal
    [self.modemTransferOb freeMemory];
    
    // Set a timer to enable the button again
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(enableButtons) userInfo:nil repeats:NO];
}

- (IBAction)transmitCarrierFrequency:(id)sender {
    [self disableButtons];// Disable Buttons
    self.modemTransferOb.carrierFrequencyOnly = true;
    [self.textInputField resignFirstResponder];         // Clear Text Keyboard if still there
    [self.modemTransferOb createCarrierFrequencyOnly];
    [self.modemTransferOb converttoAudio];                      // Convert the Signal to Audio
    
    // Initialize audio controller
    self.audioController = [[AudioController alloc] init];
    [self.audioController configureAudioSession];
    [self.audioController getFileURL:(self.modemTransferOb.fileURL)];
    [self.audioController configureAudioPlayer];
    [self.audioController tryPlaySound];                        // Play the signal
    [self.modemTransferOb freeMemory];
    
    // Set a timer to enable the button again
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(enableButtons) userInfo:nil repeats:NO];
    
}

-(void) disableButtons{
    self.transmitCarrierFrequencyButton.enabled = false;
    self.transmitCarrierFrequencyButton.alpha = 0.4;
    self.settingsButton.enabled = false;
    self.settingsButton.alpha = 0.4;
    self.transmitSignalButton.enabled = false;
    self.transmitSignalButton.alpha = 0.4;
}

-(void) enableButtons{
    self.transmitCarrierFrequencyButton.enabled = true;
    self.transmitCarrierFrequencyButton.alpha = 1;
    self.settingsButton.enabled = true;
    self.settingsButton.alpha = 1;
    self.transmitSignalButton.enabled = true;
    self.transmitSignalButton.alpha = 1;
}
// get rid of keyboard when touching outside the keyboard
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textInputField resignFirstResponder];
}

// Lock orientation into portrait orientation
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
