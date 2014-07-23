//
//  ViewController.m
//  camtest2
//
//  Created by Carter Crenshaw Howard Gray on 4/22/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//
//hey dude
#import "ViewController.h"


@interface ViewController (){
    
    CMMotionManager *motionManager;
    
}

@end

@implementation ViewController 

@synthesize stillImageOutput,  imageView, captureImage;

- (void)viewDidLoad
{
    [super viewDidLoad];

    _unitsFromMeticButton.hidden = YES;
    
    //angle code
    CMDeviceMotion *deviceMotion = motionManager.deviceMotion;
    CMAttitude *attitude = deviceMotion.attitude;
    referenceAttitude   = attitude;
    [motionManager startDeviceMotionUpdates];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];

    _distanceDisplay.hidden = NO;
    _distanceDisplay.text = @"Choose Height!";
    _freezeDistanceDisplay.hidden = YES;
    
    // camera code
    imageView.hidden = NO;
    
    FrontCamera = NO;
    
    captureImage.hidden = YES;
    
    [self initializeCamera];
    
}


 

// camera code
- (void) initializeCamera {
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetPhoto;
	
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
	captureVideoPreviewLayer.frame = self.imageView.bounds;
	[self.imageView.layer addSublayer:captureVideoPreviewLayer];
	
    UIView *view = [self imageView];
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [view bounds];
    [captureVideoPreviewLayer setFrame:bounds];
    
    
    NSArray *devices = [AVCaptureDevice devices];
    AVCaptureDevice *frontCamera;
    AVCaptureDevice *backCamera;
    
    for (AVCaptureDevice *device in devices) {
        
       // NSLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
             //   NSLog(@"Device position : back");
                backCamera = device;
            }
            else {
          //      NSLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    
    if (!FrontCamera) {
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!input) {
          //  NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
    }
    
    if (FrontCamera) {
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        if (!input) {
        //    NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
    }
	
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    [session startRunning];
}


- (void) capImage { //method to capture image from AVCaptureSession video feed
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
   // NSLog(@"about to request a capture from: %@", stillImageOutput);
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            [self processImage:[UIImage imageWithData:imageData]];
        }
    }];
}


- (void) processImage:(UIImage *)image { //process captured image, crop, resize and rotate
    haveImage = YES;
#define DegreesToRadians(x) ((x) * M_PI / 180.0)
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) { //Device is ipad
        // Resize image
        UIGraphicsBeginImageContext(CGSizeMake(768, 1022));
        [image drawInRect: CGRectMake(0, 0, 768, 1022)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        //UIGraphicsEndImageContext();
        
        CGRect cropRect = CGRectMake(0, 130, 768, 768);
        CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
        //or use the UIImage wherever you like
        
        [captureImage setImage:[UIImage imageWithCGImage:imageRef]];
        
        CGImageRelease(imageRef);
        
    }else{ //Device is iphone
        // Resize image
       UIGraphicsBeginImageContext(CGSizeMake(320, 568));
        [image drawInRect: CGRectMake(0, 0, 320, 568)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
       // UIGraphicsEndImageContext();
        
        CGRect cropRect = CGRectMake(0, 0, 320, 568);
        CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
        
        [captureImage setImage:[UIImage imageWithCGImage:imageRef]];
        
        CGImageRelease(imageRef);
    }
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
        //NSLog(@"upside upright");
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:0.5];
        captureImage.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
        [UIView commitAnimations];
    }
    
}

// freeze camera and distanceDisplay
- (IBAction)snowflakePressDown:(id)sender {
    
    imageView.hidden = YES; //hide the live video feed
    
    _distanceDisplay.hidden = YES;
    
    _freezeDistanceDisplay.hidden = NO;
    
    [self capImage];
    
    captureImage.hidden = NO; //show the captured image view
    
    //Customary freeze distance
    forCustomaryUnit = _chestLevelPassed*tan(angNumber);
    
    forCustomaryUnit = forCustomaryUnit/3;
    
    forMetricUnit = forCustomaryUnit * .9144;
    
    if (!_unitsFromUSbutton.hidden) {
        
        NSString *string1;
        
        NSString *string2;
        
        NSInteger yards = (NSInteger)forCustomaryUnit;
        
        CGFloat fractionft = forCustomaryUnit - yards;
        
        NSInteger feet = (NSInteger)(3.0 * fractionft);
        
       // NSLog(@"%ld yards %ld feet", (long)yards ,(long)feet);
        
        NSNumber *feet0 = [NSNumber numberWithInteger:feet];
        
        string2 = [NSString stringWithFormat:@"%@", feet0];
        
        NSNumber *yd0 = [NSNumber numberWithInteger:yards];
        
        string1 = [NSString stringWithFormat:@"%@", yd0];
        
        if (forCustomaryUnit == 0){
            
            self.freezeDistanceDisplay.text = @"Enter Height!";
        }
        
        else {
            if (yards == 1 && feet != 1){
                
                self.freezeDistanceDisplay.text = [NSString stringWithFormat :@"%@ yard %@ feet", string1, string2];
           
            }
            
            else if (yards == 0 && feet != 1){
            
                self.freezeDistanceDisplay.text = [NSString stringWithFormat :@"%@ feet", string2];
            
            }
            
            else if (yards == 0 && feet == 1){
                
                self.freezeDistanceDisplay.text = [NSString stringWithFormat :@"%@ foot", string2];
                
            }
            
            else if (yards != 1 && feet == 1){
                
                self.freezeDistanceDisplay.text = [NSString stringWithFormat :@"%@ yards %@ foot", string1, string2];
                
            }
            
            else {
            
                self.freezeDistanceDisplay.text = [NSString stringWithFormat :@"%@ yards %@ feet", string1, string2];
            
            }
        }
        
    }
    //Mertic freeze Distance
    else if (!_unitsFromMeticButton.hidden){
        
        NSString *string3;
        
        NSString *string4;
        
        metricUnitInt = forMetricUnit;
        
        NSInteger meters = (NSInteger)forMetricUnit;
        
        CGFloat fractionm = forMetricUnit - meters;
        
        NSInteger centiMeters = (NSInteger)(10.0 * fractionm);
        
        NSNumber *cm0 = [NSNumber numberWithInteger:centiMeters];
        
        string4 = [NSString stringWithFormat:@"%@", cm0];
        
        NSNumber *m0 = [NSNumber numberWithInteger:meters];
        
        string3 = [NSString stringWithFormat:@"%@", m0];
        
        if (forMetricUnit == 0) {
            
            self.freezeDistanceDisplay.text = @"Enter Height!";
            
        }
        
        else {
            if (meters == 1){
                
            self.freezeDistanceDisplay.text = [NSString stringWithFormat :@"%@ meter %@0 cms", string3, string4];
                
            }
            else if (meters == 0){
                
                self.freezeDistanceDisplay.text = [NSString stringWithFormat :@"%@0 centimeters", string4];
                
            }
            else if (centiMeters == 1){
                
                self.freezeDistanceDisplay.text = [NSString stringWithFormat :@"%@ meters %@0 cm", string3, string4];
                
            }
            else if (centiMeters == 1 && meters == 1){
                
                self.freezeDistanceDisplay.text = [NSString stringWithFormat :@"%@ meter %@0 cm", string3, string4];
                
            }
            else{
                
            self.freezeDistanceDisplay.text = [NSString stringWithFormat :@"%@ meters %@0 cms", string3, string4];
            
            }
        }
    }
   
}


- (IBAction)snowflakePressUp:(id)sender {
    captureImage.hidden = YES; //show the captured image view
    
    imageView.hidden = NO; //hide the live video feed
    
    [self initializeCamera];
    
	haveImage = NO;
    
    _distanceDisplay.hidden = NO;
    
    _freezeDistanceDisplay.hidden = YES;
}


//anglecode
-(void)GiveDistanceDisplay{
    
    forCustomaryUnit = _chestLevelPassed*tan(angNumber);
    
    forCustomaryUnit = forCustomaryUnit/3;
    
    forMetricUnit = forCustomaryUnit * .9144;
    
    if (!_unitsFromUSbutton.hidden) {
        
        NSString *string1;
        
        NSString *string2;
        
        NSInteger yards = (NSInteger)forCustomaryUnit;
        
        CGFloat fractionft = forCustomaryUnit - yards;
        
        NSInteger feet = (NSInteger)(3.0 * fractionft);
        
        //NSLog(@"%ld yards %ld feet", (long)yards ,(long)feet);
        
        NSNumber *feet0 = [NSNumber numberWithInteger:feet];
        
        string2 = [NSString stringWithFormat:@"%@", feet0];
        
        NSNumber *yd0 = [NSNumber numberWithInteger:yards];
        
        string1 = [NSString stringWithFormat:@"%@", yd0];
        
        if (forCustomaryUnit == 0){
            
            self.distanceDisplay.text = @"Enter Height!";
        }
        
        else {
            if (yards == 1 && feet != 1){
                
                self.distanceDisplay.text = [NSString stringWithFormat :@"%@ yard %@ feet", string1, string2];
                
            }
            
            else if (yards == 0 && feet != 1){
                
                self.distanceDisplay.text = [NSString stringWithFormat :@"%@ feet", string2];
                
            }
            
            else if (yards == 0 && feet == 1){
                
                self.distanceDisplay.text = [NSString stringWithFormat :@"%@ foot", string2];
                
            }
            
            else if (yards != 1 && feet == 1){
                
                self.distanceDisplay.text = [NSString stringWithFormat :@"%@ yards %@ foot", string1, string2];
                
            }
            
            else if (yards == 1 && feet == 1){
                
                self.distanceDisplay.text = [NSString stringWithFormat :@"%@ yard %@ foot", string1, string2];
                
            }
            
            else {
                
                self.distanceDisplay.text = [NSString stringWithFormat :@"%@ yards %@ feet", string1, string2];
                
            }
        }
        
    }
    
    else if (!_unitsFromMeticButton.hidden){
        
        NSString *string3;
        
        NSString *string4;
        
        NSInteger meters = (NSInteger)forMetricUnit;
        
        CGFloat fractionm = forMetricUnit - meters;
        
        NSInteger centiMeters = (NSInteger)(10.0 * fractionm);
        
        NSLog(@"%ld meters %ld0 cms", (long)meters ,(long)centiMeters);
        
        NSNumber *cm0 = [NSNumber numberWithInteger:centiMeters];
        
        string4 = [NSString stringWithFormat:@"%@", cm0];
        
        NSNumber *m0 = [NSNumber numberWithInteger:meters];
        
        string3 = [NSString stringWithFormat:@"%@", m0];
        
        if (forMetricUnit == 0){
            
            self.distanceDisplay.text = @"Enter Height!";
            
        }
        else {
                if (meters == 1){
                    
                    self.distanceDisplay.text = [NSString stringWithFormat :@"%@ meter %@0 cms", string3, string4];
                    
                }
                else if (meters == 0){
                
                self.distanceDisplay.text = [NSString stringWithFormat :@"%@0 cms", string4];
                
                }
                else if (centiMeters == 1){
                    
                    self.distanceDisplay.text = [NSString stringWithFormat :@"%@ meters %@0 cm", string3, string4];
                    
                }
                else if (centiMeters == 1 && meters == 1){
                    
                    self.distanceDisplay.text = [NSString stringWithFormat :@"%@ meter %@0 cm", string3, string4];
                    
                }
                else{
                    
                    self.distanceDisplay.text = [NSString stringWithFormat :@"%@ meters %@0 cms", string3, string4];
                    
                }
            
        }
    }
    

}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    
	float zz = [acceleration z];
    float yy = -[acceleration y];
	float angle = atan2(zz, yy);
    
    
        if(angle <= -0.1 && angle >= -1.57269){
        
            angNumber = angle - 1.57269;
            [self GiveDistanceDisplay];
        }
    
    else if((angle <= -1.57269 && angle >= -3.1459265) || (angle >= 2.35619449019 && angle <= 3.1459265))
	{
		
        [_distanceDisplay setText:@"Aim In Front!"];
		
	}
	else if(angle >= -0.1 && angle <= 2.35619449019)
	{
		
        [_distanceDisplay setText:@"Don't Aim Up!"];
		
    }
}
    


- (IBAction)unitsFromMetric:(id)sender {
    
    _unitsFromUSbutton.hidden = NO;
    
    _unitsFromMeticButton.hidden = YES;
    
}


-(IBAction)unitsFromCustomary:(id)sender{
    
    _unitsFromUSbutton.hidden = YES;

    _unitsFromMeticButton.hidden = NO;
    
}

    @end
