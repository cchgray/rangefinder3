//
//  ViewController.h
//  camtest2
//
//  Created by Carter Crenshaw Howard Gray on 4/22/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController

<UINavigationControllerDelegate, UIAccelerometerDelegate ,UIPickerViewDataSource, UIPickerViewDelegate>{
    
    //camera
    BOOL FrontCamera;
    BOOL haveImage;
    NSTimer *timer;
    CMAttitude *referenceAttitude;
    
    //picker
    float switchHeight;

    //angle
    float angNumber;
    int interger;
    float q;
    float d;
    float chestLevel;
    float caseInches;
    float caseFeet;
    NSString *string1;
    NSString *string2;
    NSNumber *inch;
    NSNumber *ft;
    int qInt;
    
    
}
//camera

@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *captureImage;
@property (nonatomic) UIInterfaceOrientation deviceOrientation;

//picker

@property (strong, nonatomic) NSArray *feetHeight;
@property (strong, nonatomic) NSArray *inchHeight;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerHeight;
@property(readonly, nonatomic) CMAttitude *attitude;
@property (nonatomic, readonly) CGFloat *height;

@property (weak, nonatomic) IBOutlet UILabel *ftLabel;
@property (weak, nonatomic) IBOutlet UILabel *inLabel;


// images

@property (weak, nonatomic) IBOutlet UIImageView *imageCrosshairs;
@property (weak, nonatomic) IBOutlet UIButton *snowflakePress;


//hide buttons

- (IBAction)snowflakePressDown:(id)sender;
- (IBAction)snowflakePressUp:(id)sender;
- (IBAction)hidePicker:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *hidePicker;

@property (weak, nonatomic) IBOutlet UILabel *distanceDisplay;
@property (weak, nonatomic) IBOutlet UILabel *chooseHeight;

@property (weak, nonatomic) IBOutlet UILabel *freezeDistanceDisplay;
- (IBAction)infoButtonPress:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@end



