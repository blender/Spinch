//
//  iPadViewController.h
//  Spinch
//
//  Created by Tommaso Piazza on 9/27/11.
//  Copyright (c) 2011 ChalmersTH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinchConfig.h"
#import "MSSCommunicationController.h"
#import "ColorMixerViewController.h"
#import "SpinchModel.h"
#import "PhoneViewController.h"

@interface iPadViewController : UIViewController <MSSCommunicationProtocol>
{
    IBOutlet UIImageView *drawImage;
    ColorMixerViewController* _colorMixerController;
    PhoneViewController *_phoneViewController;
    
    int mouseMoved;
    BOOL mouseSwiped;
    
    CGPoint lastPoint;
    
    SpinchModel* model;
    
    UILabel *_dbgLabel;
}

@property (strong, nonatomic) UILabel *dbgLabel;
@property (strong, nonatomic) IBOutlet UIImageView *drawImage;
@property (strong, nonatomic) ColorMixerViewController* colorMixerController;
@property (strong, nonatomic) PhoneViewController* phoneViewController;

@end
