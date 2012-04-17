//
//  iPadViewController.m
//  Spinch
//
//  Created by Tommaso Piazza on 9/27/11.
//  Copyright (c) 2011 ChalmersTH. All rights reserved.
//

#import "iPadViewController.h"

@implementation iPadViewController

@synthesize drawImage;
@synthesize colorMixerController = _colorMixerController;
@synthesize phoneViewController = _phoneViewController;
@synthesize dbgLabel = _dbgLabel;

- (void)viewDidLoad {
    
    [super viewDidLoad];
	mouseMoved = 0;
    model = [SpinchModel sharedModel];
    
    //self.colorMixerController = [[ColorMixerViewController alloc] initWithNibName:@"ColorMixerViewController" bundle:[NSBundle mainBundle]];
    self.colorMixerController = [[ColorMixerViewController alloc]init];
    self.colorMixerController.hueOffSet = 12.0f/24.0;
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    self.colorMixerController.view.frame = CGRectMake(rect.size.width-320, 0, 320, 480);
    self.colorMixerController.view.backgroundColor = [UIColor whiteColor];
    self.colorMixerController.view.hidden = YES;
    [self.view addSubview:_colorMixerController.view];
    
    self.phoneViewController = [[PhoneViewController alloc] init];
    self.phoneViewController.view.hidden = YES;
    
    [self.view addSubview:self.phoneViewController.view];
    
    self.dbgLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    
    self.dbgLabel.text = @"THIS IS A DEBUG LABEL";
    
    //[self.view addSubview:self.dbgLabel];
}

-(void) newContacs:(NSDictionary *)contacDictionary{
    
    self.dbgLabel.text = [NSString stringWithFormat:@"%f, %f", [SpinchModel sharedModel].colorHue, [SpinchModel sharedModel].localHue];
    
    SpinchDevice* device = [SpinchDevice sharedDevice]; 
    device.ipAddress = [MSSCommunicationController deviceIp];
    MSSCContactDescriptor *desc = [contacDictionary objectForKey:[NSNumber numberWithUnsignedChar:iPadID]];
    device.contactDescriptor = desc;

    if (device.contactDescriptor) {
        
        device.isOnTable = YES;
        [[MSSCommunicationController sharedController] setDeviceToCodeine:[DeviceInformation deviceInfoWithCDByteValue:device.contactDescriptor.byteValue andIp:device.ipAddress]];
        
        MSSCContactDescriptor* satelliteDevice = [contacDictionary objectForKey:[NSNumber numberWithUnsignedChar:iPhoneID]];
        
        if(satelliteDevice){
        
            float distance = [MSSCContactDescriptor distanceFromDescriptor:device.contactDescriptor toDescriptor:satelliteDevice];
            float angle  = [MSSCContactDescriptor orientationOfDescriptor:satelliteDevice relativeToDescriptor:device.contactDescriptor];
            
            if(distance < HALF_AN_IPHONE){
                if((angle  > 170.0f && angle < 230.0f) || (angle  < 10.0f || angle > 310.0f) ){
                    
                    self.colorMixerController.view.hidden = YES;

                    CGPoint position = [MSSCContactDescriptor positionOfDescriptor:satelliteDevice relativeToDescriptor:device.contactDescriptor];
                    
                    CGRect oldRect = self.phoneViewController.view.frame;
                    //TODO FIX REVERSE Y AXIS MOVEMENT ON THE SURFACE
                    CGPoint translatedPoint = CGPointMake(position.y+136, -1*((position.x-300)*3.0)-oldRect.size.height);
                    CGPoint inViewPos = CGPointApplyAffineTransform(translatedPoint, self.phoneViewController.view.transform);
                    //NSLog(@"relative Position:%d, %d", (int)inViewPos.x, (int)inViewPos.y);
                    CGRect newRect = CGRectMake(inViewPos.x, inViewPos.y, oldRect.size.width, oldRect.size.height);
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.3];
                    [self.phoneViewController.view setFrame:newRect];
                    [UIView commitAnimations];
                    self.phoneViewController.view.hidden = NO;

                }
                else if((angle  > 235.0f && angle < 305.0f)){
                    self.colorMixerController.view.hidden = NO;
                    

                
                }
                else {
                    self.colorMixerController.view.hidden = YES;
                    self.phoneViewController.view.hidden = YES;
                }
            }
            else {
                self.colorMixerController.view.hidden = YES;
                self.phoneViewController.view.hidden = YES;
            }
            
        }
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	mouseSwiped = NO;
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2) {
		drawImage.image = nil;
		return;
	}
	
	lastPoint = [touch locationInView:self.view];
	lastPoint.y -= 20;
	
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
	mouseSwiped = YES;
	UITouch *touch = [touches anyObject];	
	CGPoint currentPoint = [touch locationInView:self.view];
	currentPoint.y -= 20; // only for 'kCGLineCapRound'
	UIGraphicsBeginImageContext(self.view.frame.size);
	//Albert Renshaw - Apps4Life
	[drawImage.image drawInRect:CGRectMake(0, 0, drawImage.frame.size.width, drawImage.frame.size.height)]; //originally self.frame.size.width, self.frame.size.height)];
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), model.lineCap); //kCGLineCapSquare, kCGLineCapButt, kCGLineCapRound
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), model.toolWith); // for size
	
    //UIColor* strokeColor = [UIColor colorWithHue:model.colorHue saturation:1.0 brightness:model.colorBrightness alpha:model.toolAlpha];
    UIColor* strokeColor;
    
    if(self.colorMixerController.view.hidden == YES) {
        strokeColor = [UIColor colorWithHue:model.colorHue saturation:model.colorSaturation brightness:model.colorBrightness alpha:model.toolAlpha];
    }else{
        
        strokeColor = [UIColor colorWithHue:model.localHue saturation:1.0 brightness:1.0 alpha:model.toolAlpha];
    }
    
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), strokeColor.CGColor);
    
	CGContextBeginPath(UIGraphicsGetCurrentContext());
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
	CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	lastPoint = currentPoint;
	
	mouseMoved++;
	
	if (mouseMoved == 10) {
		mouseMoved = 0;
	}
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2) {
		drawImage.image = nil;
		return;
	}
	if(!mouseSwiped) {
		//if color == green
		UIGraphicsBeginImageContext(self.view.frame.size);
		[drawImage.image drawInRect:CGRectMake(0, 0, drawImage.frame.size.width, drawImage.frame.size.height)]; //originally self.frame.size.width, self.frame.size.height)];
		CGContextSetLineCap(UIGraphicsGetCurrentContext(), model.lineCap); //kCGLineCapSquare, kCGLineCapButt, kCGLineCapRound
		CGContextSetLineWidth(UIGraphicsGetCurrentContext(), model.toolWith);

        //strokeColor = [UIColor colorWithHue:model.colorHue saturation:1.0 brightness:model.colorBrightness alpha:model.toolAlpha];
        UIColor* strokeColor;
        
        if(self.colorMixerController.view.hidden == YES) {
            strokeColor = [UIColor colorWithHue:model.colorHue saturation:model.colorSaturation brightness:model.colorBrightness alpha:model.toolAlpha];
        }else{
            
            strokeColor = [UIColor colorWithHue:model.localHue saturation:1.0 brightness:1.0 alpha:model.toolAlpha];
        }
        
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), strokeColor.CGColor);
		
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextStrokePath(UIGraphicsGetCurrentContext());
		CGContextFlush(UIGraphicsGetCurrentContext());
		drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
