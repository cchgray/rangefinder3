//
//  ViewController.m
//  camtest2
//
//  Created by Carter Crenshaw Howard Gray on 4/22/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//
//hey dude
#import "ViewController.h"
#pragma mark - Delegate Methods
#pragma mark - Datasource Methods

@interface ViewController (){
    CMMotionManager *motionManager;
}

@end

@implementation ViewController
@synthesize stillImageOutput,  imageView, captureImage;
@synthesize pickerHeight, feetHeight, inchHeight;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //picker code
    self.feetHeight= [[NSArray alloc] initWithObjects:@"feet", @"3", @"4", @"5", @"6", nil];
    
    
    self.inchHeight = [[NSArray alloc] initWithObjects:@"inches", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10",@"11", nil];
    
    self.distanceDisplay.text = @"Choose Height!";
    self.pickerHeight.backgroundColor = [UIColor whiteColor];
    self.pickerHeight.dataSource = self;
    self.pickerHeight.delegate = self;

    //angle code
    CMDeviceMotion *deviceMotion = motionManager.deviceMotion;
    CMAttitude *attitude = deviceMotion.attitude;
    referenceAttitude   = attitude;
    [motionManager startDeviceMotionUpdates];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    // freeze camera code
	_imageCrosshairs.clipsToBounds = YES;
    captureImage.hidden = YES;
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
               // NSLog(@"Device position : back");
                backCamera = device;
            }
            else {
               // NSLog(@"Device position : front");
                frontCamera = device;
            }
        }
    }
    
    if (!FrontCamera) {
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&error];
        if (!input) {
           // NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
    }
    
    if (FrontCamera) {
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        if (!input) {
           // NSLog(@"ERROR: trying to open camera: %@", error);
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
        UIGraphicsEndImageContext();
        
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
        UIGraphicsEndImageContext();
        
        CGRect cropRect = CGRectMake(0, 0, 320, 568);
        CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
        
        [captureImage setImage:[UIImage imageWithCGImage:imageRef]];
        
        CGImageRelease(imageRef);
    }
}

// freeze camera and distanceDisplay

- (IBAction)snowflakePressDown:(id)sender {
    
    captureImage.hidden = NO; //show the captured image view
    imageView.hidden = YES; //hide the live video feed
    [self capImage];
    
    
    //pauses the distance
    qInt = (int) q;
    NSInteger feet = (NSInteger)q;
    CGFloat fraction = q - feet;
    NSInteger inches = (NSInteger)(12.0 * fraction);
    NSLog(@"%ld feet %ld inches", (long)feet,(long)inches);
    
    NSNumber *inch0 = [NSNumber numberWithInteger:inches];
    
    string2 = [NSString stringWithFormat:@"%@", inch0];
    
     NSNumber *ft0 = [NSNumber numberWithInteger:feet];
    
    string1 = [NSString stringWithFormat:@"%@", ft0];
    
    if ((feet + inches) >> 0){
        self.freezeDistanceDisplay.text = [NSString stringWithFormat :@"%@ feet %@ inches", string1, string2];
    }
    else{
        self.freezeDistanceDisplay.text = @"Choose Height!";
    }
    _distanceDisplay.hidden = YES;
    _freezeDistanceDisplay.hidden = NO;
    
   
}

- (IBAction)snowflakePressUp:(id)sender {
    captureImage.hidden = YES; //show the captured image view
    imageView.hidden = NO; //hide the live video feed
    [self initializeCamera];
	haveImage = NO;
    _distanceDisplay.hidden = NO;
    _freezeDistanceDisplay.hidden = YES;
}




//pickercode
#pragma mark Picker Delegate Methods


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
        if(component== 0)
    {
        return [self.feetHeight objectAtIndex:row];
    }
    else
    {
        return [self.inchHeight objectAtIndex:row];
        
    }
   
    return 0;
    
}

#pragma mark Picker Data Source Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 2;
    
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
  
    if(component== 0)
    {
        return [self.feetHeight count];
    }
    else if (component== 1)
    {
        return [self.inchHeight count];
        
    }
    
    return 0;
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    
    NSInteger firstComponentRow = [self.pickerHeight selectedRowInComponent:0];
    NSInteger secondComponentRow = [self.pickerHeight selectedRowInComponent:1];
   
   
    
    switchHeight = caseInches + caseFeet;
    
    chestLevel = (switchHeight * 0.9);
    NSLog(@"chestlevel is %f", chestLevel);
    
    switch(firstComponentRow) {
        case 0:
            caseFeet = -1;
            NSLog(@"0 feet");
            break;
        case 1:
            caseFeet = 3;
            NSLog(@"3 feet");
            break;
        case 2:
            caseFeet = 4;
            NSLog(@"4 feet");
            break;
        case 3:
            caseFeet = 5;
            NSLog(@"5 feet");
            break;
        case 4:
            caseFeet = 6;
            NSLog(@"6 feet");
     
            break;
            
    }
    
    switch(secondComponentRow)
    {
        case 0:
            caseInches = -1;
            break;
        case 1:
            caseInches = 0;
            break;
        case 2:
            caseInches = 0.08333333;
         
            break;
        case 3:
            caseInches = .166666666;
          
            break;
        case 4:
            caseInches = .25;
  
            break;
        case 5:
            caseInches  = .33333333;
  
            break;
        case 6:
            caseInches  = .41666666;
    
        case 7:
            caseInches = .5;
  
            break;
        case 8:
            caseInches = .58333333;

            break;
        case 9:
            caseInches = .66666666;
      
            break;
        case 10:
            caseInches = .75;
        
            break;
        case 11:
            caseInches  = .833333333;
         
            break;
        case 12:
            caseInches  = .916666666;

            break;
    }
    
    
}


//anglecode



- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    
	float zz = [acceleration z];
    float yy = -[acceleration y];
	float angle = atan2(zz, yy);
    
    if(angle <= -0.1 && angle >= -1.57269){
        
        angNumber = angle - 1.57269;
        
        q = chestLevel*tan(.7);
      
        NSInteger feet = (NSInteger)q;
        CGFloat fraction = q - feet;
        NSInteger inches = (NSInteger)(12.0 * fraction);
      //  NSLog(@"%ld feet %ld inches", (long)feet,(long)inches);
        
        NSNumber *inch0 = [NSNumber numberWithInteger:inches];
        
        string2 = [NSString stringWithFormat:@"%@", inch0];
        
        NSNumber *ft0 = [NSNumber numberWithInteger:feet];
        
        string1 = [NSString stringWithFormat:@"%@", ft0];
        
        if ((feet || inches) != -1){
            self.distanceDisplay.text = [NSString stringWithFormat :@"%@ feet %@ inches", string1, string2];
        }
        else{
            self.distanceDisplay.text = @"Choose Height!";
        }
        
    }
    
    else if((angle <= -1.57269 && angle >= -3.1459265) || (angle >= 2.35619449019 && angle <= 3.1459265))
	{
		
        [_distanceDisplay setText:@"Aim In Front!"];
        [_freezeDistanceDisplay setText:@"Aim In Front!"];
		
	}
	else if(angle >= -0.2 && angle <= 2.35619449019)
	{
		
        [_distanceDisplay setText:@"Don't Aim Up!"];
        [_freezeDistanceDisplay setText:@"Don't Aim Up!"];
        
		
    }
    
}

// hide hieght picker

- (IBAction)hidePicker:(id)sender {
    
 
    if ((pickerHeight.hidden)) {
        
        pickerHeight.hidden = !pickerHeight.hidden;
        [sender setTitle:@"Done" forState:UIControlStateNormal];
    
    } else if (!pickerHeight.hidden){
        
        pickerHeight.hidden = !pickerHeight.hidden;
        [sender setTitle:@"Height" forState:UIControlStateNormal];
        
    }
    
}

- (IBAction)infoButtonPress:(id)sender {
}
    @end
