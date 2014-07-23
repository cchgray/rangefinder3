//
//  InfoPage.h
//  Range Finder
//
//  Created by Carter Crenshaw Howard Gray on 5/13/14.
//  Copyright (c) 2014 Carter Crenshaw Howard Gray. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoPage : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
    
    float switchHeight;
    
    float caseInches;
    
    float caseFeet;
    
    float chestLevel;
}

@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UILabel *swipeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *swipeLabelBackground;

@property (weak, nonatomic) IBOutlet UIScrollView *InstructionsScrollView;

//picker code
@property (strong, nonatomic) NSArray *feetHeight;

@property (strong, nonatomic) NSArray *inchHeight;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerHeight;

@property (nonatomic, readonly) CGFloat *height;

@property (weak, nonatomic) IBOutlet UILabel *ftLabel;

@property (weak, nonatomic) IBOutlet UILabel *inLabel;


@end
