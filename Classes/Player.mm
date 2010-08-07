//
//  Player.m
//  verySimpleMusicThing2
//
//  Created by Santiago Zavala on 7/26/10.
//  Copyright 2010 Twirex. All rights reserved.
//

#import "Player.h"

#define kOutputBus 0
#define kInputBus 1



@implementation Player

@synthesize freq;

static const char* checkStatus( OSStatus s )
{
	const char *r = "whatev";
	
	switch( s ) {
		case  kAudioFileUnspecifiedError: 
			r = "kAudioFileUnspecifiedError"; 
			break;
		case  kAudioFileUnsupportedFileTypeError: 
			r =  "kAudioFileUnsupportedFileTypeError"; 
			break;
		case kAudioFileStreamError_IllegalOperation:
			r = "kAudioFileStreamError_IllegalOperation";
			break;            
		case kAudioFileUnsupportedDataFormatError:
			r = "kAudioFileUnsupportedDataFormatError"; 
			break;
		case kAudioFileInvalidFileError: 
			r="kAudioFileInvalidFileError"; 
			break;
		case kAudioFileStreamError_ValueUnknown: 
			r="kAudioFileStreamError_ValueUnknown";
			break;
		case kAudioFileStreamError_DataUnavailable: 
			r="kAudioFileStreamError_DataUnavailable";
			break;
	}
	
	if( s ) {
		//const char *e = (const char*)&s;
		//dbg_printf( "ERROR status: %s %c%c%c%c\n", r, e[3],e[2],e[1],e[0] );
	}
	
	return r;
}

static AudioComponentInstance audioUnit;

static OSStatus recordingCallback(void *inRefCon, 
                                  AudioUnitRenderActionFlags *ioActionFlags, 
                                  const AudioTimeStamp *inTimeStamp, 
                                  UInt32 inBusNumber, 
                                  UInt32 inNumberFrames, 
                                  AudioBufferList *ioData) {
	
    // TODO: Use inRefCon to access our interface object to do stuff
    // Then, use inNumberFrames to figure out how much data is available, and make
    // that much space available in buffers in an AudioBufferList.
	
    AudioBufferList *bufferList; // <- Fill this up with buffers (you will want to malloc it, as it's a dynamic-length list)
	
    // Then:
    // Obtain recorded samples
	
    OSStatus status;
	
    status = AudioUnitRender(audioUnit, 
                             ioActionFlags, 
                             inTimeStamp, 
                             inBusNumber, 
                             inNumberFrames, 
                             bufferList);
    checkStatus(status);
	
    // Now, we have the samples we just read sitting in buffers in bufferList
//    DoStuffWithTheRecordedAudio(bufferList);
    return noErr;
}

static OSStatus playbackCallback(void *inRefCon, 
								 AudioUnitRenderActionFlags *ioActionFlags, 
								 const AudioTimeStamp *inTimeStamp, 
								 UInt32 inBusNumber, 
								 UInt32 inNumberFrames, 
								 AudioBufferList *ioData) {    
    // Notes: ioData contains buffers (may be more than one!)
    // Fill them up as much as you can. Remember to set the size value in each buffer to match how
    // much data is in the buffer.
	Player *THIS = (Player*)inRefCon;
	
	int channelsThisBuffer;
	UInt32 bytesToFill;
		
	for (UInt32 i = 0; i < ioData->mNumberBuffers;  i++) {
		channelsThisBuffer = int(&ioData->mBuffers[i].mNumberChannels);
		bytesToFill =  ioData->mBuffers[i].mDataByteSize;
		AudioSampleType *outA = (AudioSampleType *)ioData->mBuffers[i].mData;
		
		BOOL on = YES;
		for (int j = 0; j < bytesToFill * 32; j++) {
			outA[j] = (on)?(SInt16)(1 * 32767.0f):(SInt16)(-1 * 32767.0f);
			if (j % (41000/THIS->freq) == 0) {
				on = !on;
			}
		}
	}
	
	
    return noErr;
}


- (void) initialize{
	freq = 400;
	
	OSStatus status;
	
	// Describe audio component
	AudioComponentDescription desc;
	desc.componentType = kAudioUnitType_Output;
	desc.componentSubType = kAudioUnitSubType_RemoteIO;
	desc.componentFlags = 0;
	desc.componentFlagsMask = 0;
	desc.componentManufacturer = kAudioUnitManufacturer_Apple;
	
	// Get component
	AudioComponent inputComponent = AudioComponentFindNext(NULL, &desc);
	
	// Get audio units
	status = AudioComponentInstanceNew(inputComponent, &audioUnit);
	checkStatus(status);
	
	// Enable IO for recording
	UInt32 flag = 1;
	status = AudioUnitSetProperty(audioUnit, 
								  kAudioOutputUnitProperty_EnableIO, 
								  kAudioUnitScope_Input, 
								  kInputBus,
								  &flag, 
								  sizeof(flag));
	checkStatus(status);
	
	// Enable IO for playback
	status = AudioUnitSetProperty(audioUnit, 
								  kAudioOutputUnitProperty_EnableIO, 
								  kAudioUnitScope_Output, 
								  kOutputBus,
								  &flag, 
								  sizeof(flag));
	checkStatus(status);
	AudioStreamBasicDescription audioFormat;
	// Describe format
	audioFormat.mSampleRate			= 44100.00;
	audioFormat.mFormatID			= kAudioFormatLinearPCM;
	audioFormat.mFormatFlags		= kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
	audioFormat.mFramesPerPacket	= 1;
	audioFormat.mChannelsPerFrame	= 1;
	audioFormat.mBitsPerChannel		= 16;
	audioFormat.mBytesPerPacket		= 2;
	audioFormat.mBytesPerFrame		= 2;
	
	// Apply format
	status = AudioUnitSetProperty(audioUnit, 
								  kAudioUnitProperty_StreamFormat, 
								  kAudioUnitScope_Output, 
								  kInputBus, 
								  &audioFormat, 
								  sizeof(audioFormat));
	checkStatus(status);
	status = AudioUnitSetProperty(audioUnit, 
								  kAudioUnitProperty_StreamFormat, 
								  kAudioUnitScope_Input, 
								  kOutputBus, 
								  &audioFormat, 
								  sizeof(audioFormat));
	checkStatus(status);
	
	
	// Set input callback
	AURenderCallbackStruct callbackStruct;
	callbackStruct.inputProc = recordingCallback;
	callbackStruct.inputProcRefCon = self;
	status = AudioUnitSetProperty(audioUnit, 
								  kAudioOutputUnitProperty_SetInputCallback, 
								  kAudioUnitScope_Global, 
								  kInputBus, 
								  &callbackStruct, 
								  sizeof(callbackStruct));
	checkStatus(status);
	
	// Set output callback
	callbackStruct.inputProc = playbackCallback;
	callbackStruct.inputProcRefCon = self;
	status = AudioUnitSetProperty(audioUnit, 
								  kAudioUnitProperty_SetRenderCallback, 
								  kAudioUnitScope_Global, 
								  kOutputBus,
								  &callbackStruct, 
								  sizeof(callbackStruct));
	checkStatus(status);
	
	// Disable buffer allocation for the recorder (optional - do this if we want to pass in our own)
	flag = 0;
	status = AudioUnitSetProperty(audioUnit, 
								  kAudioUnitProperty_ShouldAllocateBuffer,
								  kAudioUnitScope_Output, 
								  kInputBus,
								  &flag, 
								  sizeof(flag));
	
	// TODO: Allocate our own buffers if we want
	
	// Initialise
	status = AudioUnitInitialize(audioUnit);
	checkStatus(status);
}

- (void) start{
	NSLog(@"In the start");

	OSStatus status = AudioOutputUnitStart(audioUnit);
	checkStatus(status);
}
- (void) stop{
	OSStatus status = AudioOutputUnitStop(audioUnit);
	checkStatus(status);
}

- (void) dealloc{
	AudioUnitUninitialize(audioUnit);
	[super dealloc];
}


@end
