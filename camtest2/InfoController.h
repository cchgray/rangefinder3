//
//  InfoController.h
//  camtest2
//
//  Created by Carter Crenshaw Howard Gray on 4/22/14.
//  Copyright (c) 2014 Carter Crenshaw Howard Gray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>


@property (strong, nonatomic) NSArray *numberHeight;
@property (strong, nonatomic) NSArray *userHeight;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)backButton:(id)sender;


@end
