//
//  PhoneViewController.m
//  SlideUnder
//
//  Created by Tommaso Piazza on 3/19/12.
//  Copyright (c) 2012 ChalmersTH. All rights reserved.
//

#import "PhoneViewController.h"

@implementation PhoneViewController
@synthesize iPhoneImage, iPhoneImageView;
@synthesize model;

-(PhoneViewController*) init{

    self = [super init];
    
    if(self){
        
        iPhoneImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iPhone3G.png" ofType:nil]];
        model =[SpinchModel sharedModel];
    }
    
    return self;
}

-(PhoneViewController *) initWithImage:(UIImage *) image{

    self = [super init];
    
    if(self){
        
        iPhoneImage = image;
        model =[SpinchModel sharedModel];
    }
    
    return self;
}

-(void) loadView {
    
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iPhoneImage.size.width, iPhoneImage.size.height)];
    
}

-(void) viewDidLoad{
    
    iPhoneImageView = [[UIImageView alloc] initWithImage:iPhoneImage];
    [self.view addSubview: iPhoneImageView];
    
    UIButton* capButtonRound = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* btnImage = [UIImage imageNamed:@"lineCapRound.png"];
    capButtonRound.frame = CGRectMake(130, 160, btnImage.size.width, btnImage.size.height);
    [capButtonRound setImage:btnImage forState:UIControlStateNormal];
    [capButtonRound addTarget:self action:@selector(lineCapRound) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:capButtonRound];
    
    UIButton* capButtonSquared = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* btnImage2 = [UIImage imageNamed:@"lineCapSquared.png"];
    capButtonSquared.frame = CGRectMake(130, 360, btnImage2.size.width, btnImage2.size.height);
    [capButtonSquared setImage:btnImage2 forState:UIControlStateNormal];
    [capButtonSquared addTarget:self action:@selector(lineCapSquared) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:capButtonSquared];
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(-80, 280, 300, 50)];
    textLabel.textAlignment = UITextAlignmentCenter;
    textLabel.text = @"Tap to change line cap style";
    [self.view addSubview:textLabel];
    textLabel.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    //self.view.backgroundColor = [UIColor greenColor];

}

-(void) viewDidUnload {

}

-(void) lineCapRound {

    model.lineCap = kCGLineCapRound;
    NSLog(@"Line Cap set to round");
}

-(void) lineCapSquared {
    
    model.lineCap = kCGLineCapSquare;
    NSLog(@"Line Cap set to square");
}


-(BOOL) canBecomeFirstResponder {
    
    return  YES;
}

-(BOOL) becomeFirstResponder {
    
    return  YES;
}


@end
