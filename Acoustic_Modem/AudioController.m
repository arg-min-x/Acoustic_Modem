//
//  AudioController.m
//  ATBasicSounds
//
//  Created by Audrey M Tam on 22/03/2014.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

#import "AudioController.h"
@import AVFoundation;

@interface AudioController () <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioSession *audioSession;
@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (assign) BOOL backgroundMusicPlaying;
@property (assign) BOOL backgroundMusicInterrupted;
@property (assign) SystemSoundID pewPewSound;
@property (strong, nonatomic) NSURL *fileURL;

@end

@implementation AudioController

#pragma mark - Public

- (instancetype)init;
{
    self = [super init];
    if (self) {
        [self configureAudioSession];
    }
    return self;
}

- (void)getFileURL:(NSURL *)inputURL
{
    self.fileURL = inputURL;
}

- (void)tryPlaySound {
	// If background music or other music is already playing, nothing more to do here
	if (self.backgroundMusicPlaying || [self.audioSession isOtherAudioPlaying]) {
        return;
    }
    
    // Play background music if no other music is playing and we aren't playing already
    //Note: prepareToPlay preloads the music file and can help avoid latency. If you don't
    //call it, then it is called anyway implicitly as a result of [self.backgroundMusicPlayer play];
    //It can be worthwhile to call prepareToPlay as soon as possible so as to avoid needless
    //delay when playing a sound later on.
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
     self.backgroundMusicPlaying = YES;
}

- (void)configureAudioPlayer {
    // Create audio player with background music
    //    NSString *backgroundMusicPath = [[NSBundle mainBundle] pathForResource:@"background-music-aac" ofType:@"caf"];
    //    NSString *backgroundMusicPath = [[NSBundle mainBundle] pathForResource:@"pew-pew-lei" ofType:@"caf"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.fileURL error:nil];
    self.backgroundMusicPlayer.delegate = self;  // We need this so we can restart after interruptions
    self.backgroundMusicPlayer.numberOfLoops = 0;	// Negative number means loop forever
}

- (void) configureAudioSession {
    // Implicit initialization of audio session
    self.audioSession = [AVAudioSession sharedInstance];
    
    // Set category of audio session
	// See handy chart on pg. 46 of the Audio Session Programming Guide for what the categories mean
	// Not absolutely required in this example, but good to get into the habit of doing
	// See pg. 10 of Audio Session Programming Guide for "Why a Default Session Usually Isn't What You Want"
	
    NSError *setCategoryError = nil;
    if ([self.audioSession isOtherAudioPlaying]) { // mix sound effects with music already playing
        [self.audioSession setCategory:AVAudioSessionCategorySoloAmbient error:&setCategoryError];
        self.backgroundMusicPlaying = NO;
    } else {
        [self.audioSession setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    }
    if (setCategoryError) {
        NSLog(@"Error setting category! %ld", (long)[setCategoryError code]);
    }
}
@end
