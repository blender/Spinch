//
//  PhoneViewController.h
//  SlideUnder
//
//  Created by Tommaso Piazza on 3/19/12.
//  Copyright (c) 2012 ChalmersTH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpinchModel.h"

@interface PhoneViewController : UIViewController
{

}


-(PhoneViewController*) init;
-(PhoneViewController*) initWithImage:(UIImage *) image;
-(void) lineCapRound;
-(void) lineCapSquared;

@property (nonatomic, strong) UIImage* iPhoneImage;
@property (nonatomic, strong) UIImageView* iPhoneImageView;
@property (nonatomic, strong) SpinchModel* model;

@end
