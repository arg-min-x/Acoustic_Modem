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
    
//    _BPSKorQPSKPickerData = @[@"BPSK",@"QPSK"];
//    self.BPSKorQPSKPicker.dataSource = self;
//    self.BPSKorQPSKPicker.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)getInputSettings:(UIStoryboardSegue *)sender{
//    SettingsViewController * properties = [sender sourceViewController]; //getting properties
//    self.modemTransferOb.carrierFrequency = properties.carrierFrequency;
//    self.modemTransferOb.oversample = properties.oversample;
//    self.modemTransferOb.rollOffFactor = properties.rollOffFactor;
////    self.modemTransferOb.nPeriods = properties.nPeriods;
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
    
    // Get the row of the picker
//    NSInteger row = [self.BPSKorQPSKPicker selectedRowInComponent:0];
//    printf("%ld",row);
    BOOL isEnabled = self.enableQPSK.on;
    if (isEnabled== 0) {
        self.isBPSK = true;
        printf("Using BPSK\n");
    }
    else{
        self.isBPSK = false;
        printf("UsingQPSK\n");
    }
    
    // Enable Back button after save
    self.backButton.enabled = YES;
    self.backButton.alpha = 1;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.carrierFrequencyInput resignFirstResponder];
    [self.oversampleInput resignFirstResponder];
    [self.rollOffFactorInput resignFirstResponder];
    [self.nPeriodsInput resignFirstResponder];
    
}

//// Number of columns
//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
//
//// Number of rows of data
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
//    return _BPSKorQPSKPickerData.count;
//}
//
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return _BPSKorQPSKPickerData[row];
//}
//
//// get the selected row
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
