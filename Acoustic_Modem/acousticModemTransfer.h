//
//  acousticModemTransfer.h
//  Acoustic_Modem
//
//  Created by Adam V. Rich on 2/19/15.
//  Copyright (c) 2015 Adam. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import <Accelerate/Accelerate.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import "string.h"
#include <complex.h>
#include "math.h"

@interface acousticModemTransfer : NSObject
{
    //int samplerate;
    int bitspersymbol;
    int *convertedtoBPSK;
    int *convertedtoSymbols;
    int *convertedtoIs;
    int *convertedtoQs;
//    int oversample;
    int lenString; //length of input
    bool sample;
    float *Symbolswithzeros;
    float *parray;
    float *zeroeswithIs;
    float *zeroeswithQs;
    float *signal;
    vDSP_Length lenOfSymbolsWithZeros;
    vDSP_Length ResultLength;
}
//Properties
@property (nonatomic,retain) NSURL *fileURL;
@property (nonatomic,retain) NSString *myString; //input
@property (nonatomic) UInt32 Audio;
@property (nonatomic) float carrierFrequency;
@property (nonatomic) int oversample;
@property (nonatomic) float rollOffFactor;
@property (nonatomic) int nPeriods;
@property (nonatomic) BOOL isBPSK;
@property (nonatomic) BOOL carrierFrequencyOnly;

// Methods

// Initialize the class
-(instancetype)init;

// Get string and set length
-(void)getInputString:(NSString *) inputString;

// Convert from Ascii to bits
-(void)QPSKsymbols;
-(void)BPSKsymbols;

// Upsample and zero pad
-(void)zerosQPSK;
-(void)Addinzeros;

//
-(void)PulseShape;

//
-(void)createCarrierFrequencyOnly;

//
-(void)QPSKconvolutionandmodulation;
-(void)BPSKconvolutionandmodulation;

// Convert to an audio signal play
-(void)converttoAudio;

// Free The allocated memory
-(void)freeMemory;

@end
