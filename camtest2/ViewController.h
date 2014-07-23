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
#import <QuartzCore/QuartzCore.h>


@interface ViewController : UIViewController


<UINavigationControllerDelegate, UIAccelerometerDelegate>{
    
    //camera
    BOOL FrontCamera;
    
    BOOL haveImage;
    
    NSTimer *timer;
    
    CMAttitude *referenceAttitude;
    
    //angle
    float angNumber;
    
    float forCustomaryUnit;
    
    float forMetricUnit;
    
    int customaryUnitInt;
    
    int metricUnitInt;
    
}

@property (nonatomic) float chestLevelPassed;

//camera
@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIImageView *captureImage;

// snowflake
@property (weak, nonatomic) IBOutlet UIButton *snowflakePress;

- (IBAction)snowflakePressDown:(id)sender;

- (IBAction)snowflakePressUp:(id)sender;

//Unit Changer Buttons
@property (weak, nonatomic) IBOutlet UIButton *unitsFromUSbutton;

@property (weak, nonatomic) IBOutlet UIButton *unitsFromMeticButton;

- (IBAction)unitsFromMetric:(id)sender;

- (IBAction)unitsFromCustomary:(id)sender;

//display labels
@property (weak, nonatomic) IBOutlet UILabel *distanceDisplay;

@property (weak, nonatomic) IBOutlet UILabel *freezeDistanceDisplay;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@end



