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
    int bitspersymbol;
    int *convertedtoBPSK;
    int *convertedtoSymbols;
    int *convertedtoIs;
    int *convertedtoQs;
    int pilotLength;
    int *pilots;
    unsigned long lenString; //length of input
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
@property (nonatomic,retain) NSURL *fileURL;        // file URL to audio signal
@property (nonatomic,retain) NSString *myString;    //input string
@property (nonatomic) UInt32 Audio;
@property (nonatomic) float carrierFrequency;       // carrier frequency
@property (nonatomic) int oversample;               // oversamplig factor
@property (nonatomic) float rollOffFactor;          // roll off factor
@property (nonatomic) int nPeriods;                 // number of periods
@property (nonatomic) BOOL isBPSK;                  // use BPSK if true
@property (nonatomic) BOOL carrierFrequencyOnly;    // transmit only the carrier frequency if true
@property (nonatomic) BOOL isBarker13;              // Use Barker13 pilot

// Methods

// Initialize the default options for the class
-(instancetype)init;

// Get the input string and set length parameter
-(void)getInputString:(NSString *) inputString;

// Convert from Ascii to bits for either BPSK or QPSK
-(void)QPSKsymbols;
-(void)BPSKsymbols;

// Upsample the signal by the "oversample" property and zero pad for convolution
-(void)zerosQPSK;
-(void)Addinzeros;

// Create the pulse shaping filter
-(void)PulseShape;

// Method to create the carrier frequency only signal
-(void)createCarrierFrequencyOnly;

// convolve the upsampled symbols with the pulse filter
-(void)QPSKconvolutionandmodulation;
-(void)BPSKconvolutionandmodulation;

// Convert the upsampled and convolved signal to audio
-(void)converttoAudio;

// Free The allocated memory
-(void)freeMemory;

@end
