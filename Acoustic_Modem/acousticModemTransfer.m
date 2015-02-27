//
//  acousticModemTransfer.m
//  Acoustic_Modem
//
//  Created by Adam V. Rich on 2/19/15.
//  Copyright (c) 2015 Adam. All rights reserved.
//
#import "acousticModemTransfer.h"

@implementation acousticModemTransfer

@synthesize myString;
@synthesize fileURL;
@synthesize Audio;

-(instancetype)init{
    self = [super init];
    self.rollOffFactor = 0.5;
    self.nPeriods = 5;
    myString = @"Hello, World!_________";
    bitspersymbol=1;
    self.carrierFrequency=2000;
    self.oversample=110;
    self.isBPSK = true;
    lenString = [myString length];
    
    return self;
}
-(void)getInputString:(NSString *)inputString{
    
    if (lenString<23) {
        myString=inputString;
        myString=[myString stringByPaddingToLength:22 withString:@"*" startingAtIndex:0]; //added decimals after, spaces may not work, but you can try
        
    }else{
        myString=inputString;
    }
    lenString = [myString length];
}

-(void)BPSKsymbols{
    NSData * data = [myString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    NSUInteger len = [data length];//gets length of data
    char *bytes = [data bytes];
    convertedtoBPSK = (int*)malloc((len*8+26)*sizeof(int));
    int pilots[26]= {+1,+1,+1,+1,+1,-1,-1,+1,+1,-1,+1,-1,+1,
                     +1,+1,+1,+1,+1,-1,-1,+1,+1,-1,+1,-1,+1};
//    int pilots[13]= {+1,+1,+1,+1,+1,-1,-1,+1,+1,-1,+1,-1,+1};

    int m=0;
    
    for (int pi=0; pi<26; pi++) { //adding in pilot symbols
//        for (int pi=0; pi<13; pi++) { //adding in pilot symbols
        convertedtoBPSK[m]=pilots[pi];
        m++;
    }
    
    for(int i =0 ; i<len; i++){
        char Nbyte = *(bytes+i); //gets byte
        
        for (int j=0; j<8;j++) {
            
            if (j != 0) {
                Nbyte=Nbyte<<(1); //shift to the left once
            }
            
            if ((Nbyte&0x80)==0x80) { //checking if left most bit is equal to one
                convertedtoBPSK[m]=-1; //define symbol equal to -1
                
            } else {
                convertedtoBPSK[m]=+1; //define symbol equal to +1
            }
            m++;
        }
    }
}

-(void)QPSKsymbols{
    
    // @autoreleasepool {
    //myString =self.stringInput.text;
    NSData * data = [myString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    NSUInteger len = [data length];//gets length of data
    char *bytes = [data bytes];
    char a = 0XC0;//+3 fourth quadrant
    char b = 0x00;//-3 first quadrant
    unsigned char c = (unsigned char)0x80;//+1 third quadrant// shows up as -128
    char d = 0x40;//-1 second quadrant
    char symbols[]={a,b,c,d};
    
    int pilots[26]= {+1,+1,+1,+1,+1,-1,-1,+1,+1,-1,+1,-1,+1,+1,+1,+1,+1,+1,-1,-1,+1,+1,-1,+1,-1,+1};
    
    convertedtoIs = (int*)malloc((len*4+26)*sizeof(int));  //real part
    convertedtoQs = (int*)malloc((len*4+26)*sizeof(int)); //imaginary part
    
    int m=0;
    
    
    for (int pi=0; pi<26; pi++) {
        convertedtoQs[m]=0;
        convertedtoIs[m]=pilots[pi]; //pilots real part only
        m++;
    }
    
    for(int i =0 ; i<len; i++){
        char Nbyte = *(bytes+i); //gets byte
        
        
        for(int j =0 ; j < 4; j++){
            
            if (j!=0) {
                
                Nbyte= (Nbyte<<(2)); // grab 2 bits
                
            }
            
            for(int k=0; k<4; k++) {
                
                
                if((unsigned char) (Nbyte & 0xC0) == (unsigned char) symbols[k]) {
                    
                    
                    //need unsigned char because otherwise symbols[2] will equal -128 and not positive 128

                    switch (k) {
                            
                            
                        case 3: //binary 01 -1
                            convertedtoIs[m]=1;
                            convertedtoQs[m]=-1;
                            //   printf("%d\n", convertedtoQs[m]);
                            m++;
                            //  printf("%d\n", m);
                            
                            break;
                        case 2: //binary 10 +1
                            convertedtoIs[m]=-1;
                            convertedtoQs[m]=1;
                            //   printf("%d\n", convertedtoQs[m]);
                            // printf("%d\n", m);
                            m++;
                            
                            break;
                        case 1: //binary 00 -3
                            convertedtoIs[m]=1;
                            convertedtoQs[m]=1;
                            //      printf("%d\n", convertedtoQs[m]);
                            
                            // printf("%d\n", m);
                            m++;
                            break;
                        case 0: //binary 11 +3
                            convertedtoIs[m]=-1;
                            convertedtoQs[m]=-1;
                            //   printf("%d\n", convertedtoQs[m]);
                            
                            //   printf("%d\n", m);
                            m++;
                            break;
                            
                    }
                }
            }
        }
    }
}


-(void)zerosQPSK{
    // int length = [self.stringInput.text length]*4;
    int length = lenString*4+26;
    int newlength = length*self.oversample;
    float padding =self.nPeriods*self.oversample*2;
    int x=0;
    int*count;
    zeroeswithIs= (float*)malloc((newlength+(2*padding))*sizeof(float));
    zeroeswithQs= (float*)malloc((newlength+(2*padding))*sizeof(float));

    
    count=&x;//keep track of x
    for (int w=0; w<padding; w++) { //adds in oversamples times the number of periods of zeroes
        zeroeswithIs[w]=0;
        zeroeswithQs[w]=0;
        //  printf("%f\n",zeroeswithIs[x]);
        x++;
    }for (int z=0; z<length; z++) {
        zeroeswithIs[x] =(float) convertedtoIs[z]; //insert symbol
        zeroeswithQs[x] = (float)convertedtoQs[z]; //insert symbol
        // printf("%f\n",zeroeswithIs[x]);
        
        x++;
        for (int p =1; p<self.oversample; p++) {
            zeroeswithIs[x]=0; //add zeroes
            zeroeswithQs[x]=0; //add zeroes
            //    printf("%f\n",zeroeswithIs[x]);
            x++;
        }
    }
    
    
    int q;
    for (q=*count; q<padding+*count; q++) { //adds in oversamples times the number of periods of zeroes
        zeroeswithQs[q]=0;
        zeroeswithIs[q]=0;
        //   printf("%f\n",zeroeswithIs[x]);
    }
    
}
-(void)Addinzeros{
//     int length=[self.stringInput.text length]*8+26; //number of bits
    int length = lenString*8+26;
    float padding = self.nPeriods*self.oversample*2; // whole filter length (nPeriods in both direction)
    int newlength = length*self.oversample+padding*2; //number of bits plus zeros
    int x = 0;
    int *count = &x;
    
    Symbolswithzeros = (float*)malloc((newlength)*sizeof(float));
    
    for (int w=0; w<padding; w++) {
        Symbolswithzeros[w]=0;
        x++;
    }
    
    for (int z=0; z<length; z++) {
        Symbolswithzeros[x]=(float)convertedtoBPSK[z]; //grabbing symbol
        
        x++;
        
        for (int p = 1; p<self.oversample; p++) {
            Symbolswithzeros[x]=0; //adding in zeros
            
            x++;
            
        }
    }
    
    int q;
    for (q=*count; q<padding+*count; q++) {
        Symbolswithzeros[q]=0;
    }
//    int ind;
//        for (ind=0; ind<newlength; ind++) { //adding in pilot symbols
//            printf("ind[%d], symbols= %f, converted = %d\n",ind, Symbolswithzeros[ind+10],convertedtoBPSK[ind]);
//        }
    
}


-(void)PulseShape{
    
    int N = self.nPeriods;
    
    float pT;
    float Ts= (float)self.oversample;
    parray =(float*)malloc(self.nPeriods*self.oversample*2*sizeof(float)); //allocate data for pulse shape data
    for (int t=-self.oversample*N; t<self.oversample*N; t++) { //square root cosine pulse shape
        if (t==0) {
            pT=(1/sqrtf(Ts))*(1-self.rollOffFactor+(4*self.rollOffFactor/M_PI));
        }
        else if (t==Ts/(4*self.rollOffFactor) || (t==-Ts/(4*self.rollOffFactor)))
        {
            pT=self.rollOffFactor/(sqrtf(2*Ts))*((1+2/M_PI)*sinf(M_PI/(4*self.rollOffFactor))+(1-2/M_PI)*cos(M_PI/(4*self.rollOffFactor)));
        }
        else
        {
            pT = 1/sqrtf(Ts) * ((sinf(M_PI*(1-self.rollOffFactor)*t/Ts))+(4*self.rollOffFactor*t/Ts*cosf(M_PI*(1+self.rollOffFactor)*t/Ts)))/((M_PI*t/Ts)*(1-pow((4*self.rollOffFactor*t/Ts),2)));
        }
        parray[t+self.oversample*N]=pT; //stores values into array
        
    }
    
}
-(void)QPSKconvolutionandmodulation{

    vDSP_Length filterlength=self.nPeriods*self.oversample*2;
    lenOfSymbolsWithZeros = (lenString*4+26)*self.oversample+2*filterlength;

    vDSP_Length qLength = lenOfSymbolsWithZeros - filterlength;
    vDSP_Length iLength = lenOfSymbolsWithZeros - filterlength;
    //
    float * ResultI = (float*)malloc(iLength * sizeof(ResultI));
    float * ResultQ = (float*)malloc(qLength * sizeof(ResultQ));
    
    signal = (float*)malloc(iLength*sizeof(signal));
    
    vDSP_conv(zeroeswithIs,1,parray+filterlength-1,-1,ResultI, 1, iLength,filterlength); //convolution
    vDSP_conv(zeroeswithQs,1,parray+filterlength-1,-1,ResultQ, 1, qLength, filterlength);//convolution
    
    
    
    for (int h=0; h<iLength-1; h++) {
        
        signal[h] = ResultI[h+1]*cosf(2*M_PI*self.carrierFrequency*(float)h/44100.0) - ResultQ[h+1]*sinf(2*M_PI*self.carrierFrequency*(float)h/44100.0);
        
    }
    
    // Free array memory
    free(ResultI);
    free(ResultQ);
}
-(void)BPSKconvolutionandmodulation {
    vDSP_Length filterlength=self.oversample*self.nPeriods*2;
    lenOfSymbolsWithZeros = (lenString*8+26)*self.oversample+2*filterlength;
    
    ResultLength=lenOfSymbolsWithZeros-filterlength;
    
    float *BPSKResult =(float*)malloc(ResultLength * sizeof(float));
    
    signal = (float*)malloc(ResultLength*sizeof(float));
    vDSP_conv(Symbolswithzeros,1,parray+filterlength-1,-1,BPSKResult, 1, ResultLength,filterlength); //convolution
    for (int w=0; w<ResultLength-1; w++) {
        signal[w]=BPSKResult[w+1]*cosf(2.0*M_PI*self.carrierFrequency*(float)w/44100.0); //modulation
    }
    
    free(BPSKResult);
    
}

-(void)createCarrierFrequencyOnly{
    signal = (float *)malloc(44100*3*sizeof(float));
    for (int ind=0; ind<44100*3-1; ind++) {
        signal[ind] = cos(2.0*M_PI*self.carrierFrequency*(float)ind/44100.0);
    }
}

-(void)converttoAudio

{
    vDSP_Length filterlength=self.oversample*self.nPeriods*2;
    
    ResultLength=lenOfSymbolsWithZeros-filterlength;
    
    
    NSString *filePath = NSTemporaryDirectory();
    
    filePath = [filePath stringByAppendingPathComponent:@"signal.wav"];
    
    fileURL = [NSURL fileURLWithPath:filePath];
    AudioStreamBasicDescription asbd;
    
    memset(&asbd,0, sizeof(asbd));
    
    asbd.mSampleRate = 44100.0;
    asbd.mFormatID = kAudioFormatLinearPCM;
    
    asbd.mFormatFlags = kAudioFormatFlagIsFloat | kAudioFormatFlagIsNonInterleaved | kAudioFormatFlagsNativeEndian |kLinearPCMFormatFlagIsPacked;
    
    
    asbd.mBitsPerChannel =32;
    asbd.mChannelsPerFrame = 1;
    asbd.mFramesPerPacket = 1;
    asbd.mBytesPerFrame = 4;
    asbd.mBytesPerPacket = 4;
    
    AudioFileID audiofile;
    OSStatus audioErr = noErr;
    audioErr = AudioFileCreateWithURL((__bridge CFURLRef)fileURL,
                                      kAudioFileWAVEType,
                                      &asbd,
                                      kAudioFileFlags_EraseFile,
                                      &audiofile);
    if (audioErr == 1) {
        printf("Audio Error");
    }
    assert (audioErr == noErr);
    
    UInt32 numSamples = ResultLength;
    UInt32 bytesToWrite = numSamples*sizeof(Float32);
    
    audioErr = AudioFileWriteBytes(audiofile, false, 0, &bytesToWrite, signal); //write file
    
    audioErr = AudioFileClose(audiofile);
}

-(void)freeMemory
{
    if (self.isBPSK) {
        free(convertedtoBPSK);
        free(Symbolswithzeros);
    }
    else {
        free(convertedtoIs);
        free(convertedtoQs);
        free(zeroeswithIs);
        free(zeroeswithQs);
    }
//
    free(parray);
    free(signal);
    
    [[NSFileManager defaultManager] removeItemAtURL:fileURL error:nil];
}

@end
