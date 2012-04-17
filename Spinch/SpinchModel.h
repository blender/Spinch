//
//  SpinchModel.h
//  Spinch
//
//  Created by Tommaso Piazza on 3/7/12.
//  Copyright (c) 2012 ChalmersTH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSSCContactDescriptor.h"
#import "InterDeviceComController.h"
#import "SpinchDevice.h"

#ifdef SIMULATOR
#define HALF_AN_IPHONE 230
#define HALF_AN_IPAD 300
#endif
#ifndef SIMULATOR
#define HALF_AN_IPHONE 380
#define HALF_AN_IPAD 300
#endif

@interface SpinchModel : NSObject <InterDeviceComProtocol>

@property (nonatomic, assign) float toolWith;
@property (nonatomic, assign) float toolAlpha;
@property (nonatomic, assign) float colorSaturation;
@property (nonatomic, assign) float colorHue;
@property (nonatomic, assign) float colorBrightness;
@property (nonatomic, assign) BOOL isColorMixerDisplayed;
@property (nonatomic, assign) BOOL isToolControllerDisplayed;
//not serialized
@property (nonatomic, assign) unsigned char lineCap;
@property (nonatomic, assign) float localHue;

+(SpinchModel *) sharedModel;
-(void) transmitToCanvasDevice;

@end
