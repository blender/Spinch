//
//  ViewController.m
//  Spinch
//
//  Created by Tommaso Piazza on 9/26/11.
//  Copyright (c) 2011 ChalmersTH. All rights reserved.
//

#import "iPhoneViewController.h"

@implementation iPhoneViewController

@synthesize sizeSlider = _sizeSlider;
@synthesize opacitySlider = _opacitySlider;
@synthesize imageView;
@synthesize colorMixerController = _colorMixerController;
@synthesize phoneViewController = _phoneViewController;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [SpinchModel sharedModel].isColorMixerDisplayed = NO;
    [SpinchModel sharedModel].isToolControllerDisplayed = YES;
    
    //rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateGesture:)];
    pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    
    //rotationGestureRecognizer.delegate = self;
    pinchGestureRecognizer.delegate = self;
    
    //[self.view addGestureRecognizer:rotationGestureRecognizer];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
    [self.view addSubview:imageView];
    
    lastRotation = 0.0f;
    lastScale = 0.0f;
    pinchTimes = 0;
    rotateTimes = 0;
    
    isPhoneViewControllerDisplayed = NO;
}

#pragma mark -
#pragma mark MSSCommunicationController Protocol

-(void) newContacs:(NSDictionary *)contacDictionary{
    
    
    SpinchDevice* device = [SpinchDevice sharedDevice]; 
    device.ipAddress = [MSSCommunicationController deviceIp];
    MSSCContactDescriptor *desc = [contacDictionary objectForKey:[NSNumber numberWithUnsignedChar:iPhoneID]];
    device.contactDescriptor = desc;
    if (device.contactDescriptor) {
        
        device.isOnTable = YES;
        [[MSSCommunicationController sharedController] setDeviceToCodeine:[DeviceInformation deviceInfoWithCDByteValue:device.contactDescriptor.byteValue andIp:device.ipAddress]];
        
        MSSCContactDescriptor* canvas = [contacDictionary objectForKey:[NSNumber numberWithUnsignedChar:iPadID]];
        
        if(canvas){
                    
            ((SpinchDevice *)[SpinchDevice sharedDevice]).otherDeviceDescriptor = canvas;
           
        
            float angle = [MSSCContactDescriptor orientationOfDescriptor:device.contactDescriptor relativeToDescriptor:canvas];
            
            if( (angle > 320.0f || angle < 80.0f ) || (angle > 100.0f && angle < 210.0f )){
                
                isPhoneViewControllerDisplayed = NO;
                
                if(![SpinchModel sharedModel].isToolControllerDisplayed){
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [SpinchModel sharedModel].isColorMixerDisplayed = NO;
                    self.colorMixerController = nil;
                    [SpinchModel sharedModel].isToolControllerDisplayed = YES;
                }
            }
            
            if((angle  > 215.0f && angle < 315.0f)){
                
                
                
                if(![SpinchModel sharedModel].isColorMixerDisplayed){
                    
                    if(isPhoneViewControllerDisplayed){
                        
                        isPhoneViewControllerDisplayed = NO;
                        [self.phoneViewController dismissViewControllerAnimated:YES completion:nil];
                    }
                    else{
                     
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                    self.colorMixerController = [[ColorMixerViewController alloc] init];
                    [SpinchModel sharedModel].isColorMixerDisplayed = YES;
                    [SpinchModel sharedModel].isToolControllerDisplayed = NO;
                    [self presentViewController:self.colorMixerController animated:YES completion:nil];
                }
                
            }
            /*
            if((angle  > 170.0f && angle < 215.0f)){

                if (isPhoneViewControllerDisplayed == NO) {
                    
                    [SpinchModel sharedModel].isColorMixerDisplayed = NO;

                    //[self dismissViewControllerAnimated:YES completion:nil];
                    self.phoneViewController = [[PhoneViewController alloc] initWithImage:[UIImage imageNamed:@"blank.png"]];
                    
                    if([SpinchModel sharedModel].isToolControllerDisplayed){
                        [SpinchModel sharedModel].isToolControllerDisplayed = NO;
                        [self presentViewController:self.phoneViewController animated:YES completion:nil];
                    }
                    else{
                        [SpinchModel sharedModel].isToolControllerDisplayed = NO;
                        [self.presentedViewController presentViewController:self.phoneViewController animated:YES completion:nil];
                    }
                    isPhoneViewControllerDisplayed = YES;

                }
            }
            */
        }
    }
    else{
    
        device.isOnTable = NO;
    
    }
    
}

-(void) newIPs:(NSDictionary *)ipDictionary {

    SpinchDevice* device = [SpinchDevice sharedDevice];
    NSNumber* key = [NSNumber numberWithUnsignedChar:device.otherDeviceDescriptor.byteValue];
    DeviceInformation* canvasDevice = [ipDictionary objectForKey:key];
    
    if(canvasDevice != nil && canvasDevice.ipStrLength > 0){
    
        SpinchDevice* device = [SpinchDevice sharedDevice];
        device.otherDevice = canvasDevice;
        
    }
    


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void) dealloc {

    //[rotationGestureRecognizer release];
    //[pinchGestureRecognizer release];
    self.colorMixerController = nil;
    [super dealloc];

}

- (IBAction) sizeSliderValueChanged:(UISlider *) sender{

    [SpinchModel sharedModel].toolWith = 50.0*[sender value];
    
}

- (IBAction) opacitySliderValueChanged:(UISlider *)sender{

    [SpinchModel sharedModel].toolAlpha = 1.0*[sender value]; 
}


#pragma mark - Gersture Handling

/*
-(IBAction) handleRotateGesture:(UIRotationGestureRecognizer *) recognizer
{
    
    if([recognizer state] == UIGestureRecognizerStateEnded) {
        
        lastRotation = 0.0f;
        NSLog(@"Rotation Ended");

        return;
    }
    
    
    /*
    NSLog(@"current rotation:%f\t last rotation:%f\t angle of rotation:%f", [recognizer rotation], lastRotation, rotation);
    lastRotation = [recognizer rotation];
    
    if(rotateTimes % 2 == 1){
        
        [SpinchModel sharedModel].toolAlpha = 1* rotation;
        
    }
    
    rotateTimes++;
    if(rotateTimes > 1) rotateTimes = 0;
     
     */
    /*
   
    CGFloat imgRotation = [recognizer rotation] - lastRotation;
    imageView.transform = CGAffineTransformRotate(imageView.transform, imgRotation);
    lastRotation = [recognizer rotation];
    
    float Arotation = fabsf([recognizer rotation]);
    int rot = Arotation;
    float rotation = Arotation - rot;
    NSLog(@"Rotation: %f", rotation);
    
    [SpinchModel sharedModel].toolAlpha = 1* rotation;

}
*/


-(IBAction) handlePinchGesture:(UIPinchGestureRecognizer *) recognizer
{

    /*

    
	CGAffineTransform currentTransform = imageView.transform;
	CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
	imageView.transform = newTransform;
    
    NSLog(@"Pinch scale:%f\t recognizer scale:%f\t scale delta:%f", scale, [recognizer scale], -1.0f*(lastScale - [recognizer scale]));
    
	lastScale = [recognizer scale];
    
    if(pinchTimes % 2 == 1){
    
        [SpinchModel sharedModel].toolWith = scale;
    
    }
    
    pinchTimes++;
    if(pinchTimes > 1) pinchTimes = 0;
     */
    

    if([recognizer state] == UIGestureRecognizerStateEnded) {
        
		lastScale = 1.0;
		return;
	}
    
	CGFloat scale = 1.0 - (lastScale - [recognizer scale]);
    CGAffineTransform currentTransform = imageView.transform;
	CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    imageView.transform =newTransform;
    
    int toolscale = 0;
    float increment = (lastScale - [recognizer scale]);
    
    increment = fabs(increment);
    //NSLog(@"Increment %f, 10%% %f", increment, lastScale*0.01);
    if(increment > lastScale*0.01){
        if(lastScale > 0)
            toolscale = 5;
        else
            toolscale = -5;
    }
    lastScale = [recognizer scale];
    [SpinchModel sharedModel].toolWith = 50*[recognizer scale];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{

    return YES;
}
@end
