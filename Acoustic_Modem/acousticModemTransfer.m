//
//  acousticModemTransfer.m
//  Acoustic_Modem
//
//  Created by Adam V. Rich on 2/19/15.
//  Copyright (c) 2015 Adam. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "acousticModemTransfer.h"

@implementation acousticModemTransfer

@synthesize myString;
@synthesize fileURL;
@synthesize Audio;

-(instancetype)init{
    self = [super init];
    self.rollfactor = 0.5;
    self.Nperiods = 5;
    myString = @"Hello, World!";
    bitspersymbol=1;
    self.frequencytest=2000;
    self.oversample=110;
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
    printf("%s",[myString UTF8String]);
}

-(void)BPSKsymbols{
    NSData * data = [myString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    NSUInteger len = [data length];//gets length of data
      char *bytes = [data bytes];
    convertedtoBPSK = (int*)malloc((len*8+26)*sizeof(int));
    int pilots[26]= {+1,+1,+1,+1,+1,-1,-1,+1,+1,-1,+1,-1,+1,
                     +1,+1,+1,+1,+1,-1,-1,+1,+1,-1,+1,-1,+1};
//    int pilots[13]= {+1,+1,+1,+1,+1,-1,-1,+1,+1,-1,+1,-1,+1};

    printf("\nlength data=%d\n",len);
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
    printf("length of bpsk signals = %d\n",len*8+26);
    for (int ind = 0; ind <2+len*8; ind++) {
        if (ind<26) {
            printf("Header ind[%d] = %d\n",ind, convertedtoBPSK[ind]);
        }
        else if  (ind ==26){
            printf("\n\n");
        }
        else if (ind<320 && ind >25) {
            
            printf("Data ind[%d] = %d\n",ind,convertedtoBPSK[ind]);
        }
        
    }
    
    
    
}
-(void)QPSKsymbols{
    
    // @autoreleasepool {
    //myString =self.stringInput.text;
    NSData * data = [myString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    NSUInteger len = [data length];//gets length of data
    char *bytes = [data bytes];
    // first_byte = *bytes;
    // second_byte = *(bytes+1);
    // third_byte = *(bytes+2);
    // ...
    // *(bytes+len-1)
    // printf("%d\n", len);
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
        // printf("%d\n", convertedtoIs[m]);
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
    float padding =self.Nperiods*self.oversample*2;
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
    float padding = self.Nperiods*self.oversample*2; // whole filter length (Nperiods in both direction)
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
    printf("\nnewlength = %d\n",newlength);
//    int ind;
//        for (ind=0; ind<newlength; ind++) { //adding in pilot symbols
//            printf("ind[%d], symbols= %f, converted = %d\n",ind, Symbolswithzeros[ind+10],convertedtoBPSK[ind]);
//        }
    
}


-(void)PulseShape{
    
    int N = self.Nperiods;
    
    float pT;
    float Ts= (float)self.oversample;
    parray =(float*)malloc(self.Nperiods*self.oversample*2*sizeof(float)); //allocate data for pulse shape data
    printf("\nsize of pulse%d\n",self.Nperiods*self.oversample*2);
    for (int t=-self.oversample*N; t<self.oversample*N; t++) { //square root cosine pulse shape
        if (t==0) {
            pT=(1/sqrtf(Ts))*(1-self.rollfactor+(4*self.rollfactor/M_PI));
        }
        else if (t==Ts/(4*self.rollfactor) || (t==-Ts/(4*self.rollfactor)))
        {
            pT=self.rollfactor/(sqrtf(2*Ts))*((1+2/M_PI)*sinf(M_PI/(4*self.rollfactor))+(1-2/M_PI)*cos(M_PI/(4*self.rollfactor)));
        }
        else
        {
            pT = 1/sqrtf(Ts) * ((sinf(M_PI*(1-self.rollfactor)*t/Ts))+(4*self.rollfactor*t/Ts*cosf(M_PI*(1+self.rollfactor)*t/Ts)))/((M_PI*t/Ts)*(1-pow((4*self.rollfactor*t/Ts),2)));
        }
        parray[t+self.oversample*N]=pT; //stores values into array
        
    }
    
}
-(void)QPSKconvolutionandmodulation{

    vDSP_Length filterlength=self.Nperiods*self.oversample*2;
    lenOfSymbolsWithZeros = (lenString*4+26)*self.oversample+2*filterlength;

    vDSP_Length qLength = lenOfSymbolsWithZeros - filterlength;
    vDSP_Length iLength = lenOfSymbolsWithZeros - filterlength;
    //
    float * ResultI = (float*)malloc(iLength* sizeof(ResultI));
    float * ResultQ = (float*)malloc(qLength * sizeof(ResultQ));
    
    signal = (float*)malloc(iLength*sizeof(signal));
    
    vDSP_conv(zeroeswithIs,1,parray+filterlength-1,-1,ResultI, 1, iLength,filterlength); //convolution
    vDSP_conv(zeroeswithQs,1,parray+filterlength-1,-1,ResultQ, 1, qLength, filterlength);//convolution
    
    
    
    for (int h=0; h<iLength-1; h++) {
        
        signal[h] = ResultI[h+1]*cosf(2*M_PI*self.frequencytest*(float)h/44100.0) - ResultQ[h+1]*sinf(2*M_PI*self.frequencytest*(float)h/44100.0);
        
    }
}
-(void)BPSKconvolutionandmodulation {
    vDSP_Length filterlength=self.oversample*self.Nperiods*2;
    lenOfSymbolsWithZeros = (lenString*8+26)*self.oversample+2*filterlength;
    
    ResultLength=lenOfSymbolsWithZeros-filterlength;
    
    float *BPSKResult =(float*)malloc(ResultLength * sizeof(float));
    
    signal = (float*)malloc(ResultLength*sizeof(float));
    vDSP_conv(Symbolswithzeros,1,parray+filterlength-1,-1,BPSKResult, 1, ResultLength,filterlength); //convolution
    for (int w=0; w<ResultLength-1; w++) {
        signal[w]=10*BPSKResult[w+1]*cosf(2.0*M_PI*self.frequencytest*(float)w/44100.0); //modulation
    }

    
}

-(void)converttoAudio

{
    vDSP_Length filterlength=self.oversample*self.Nperiods*2;
    
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
    assert (audioErr == noErr);
    
    UInt32 numSamples = ResultLength;
    UInt32 bytesToWrite = numSamples*sizeof(Float32);
    
    audioErr = AudioFileWriteBytes(audiofile, false, 0, &bytesToWrite, signal); //write file
    
    audioErr = AudioFileClose(audiofile);
}


@end
