//
//  InfoController.m
//  camtest2
//
//  Created by Carter Crenshaw Howard Gray on 4/22/14.
//  Copyright (c) 2014 Carter Crenshaw Howard Gray. All rights reserved.
//

#import "InfoController.h"


@interface InfoController ()
@property (strong, nonatomic) NSArray *array;

@end

@implementation InfoController



- (void)viewDidLoad {
    [super viewDidLoad];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Picker Delegate Methods

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    // This method provides the data for a specific row in a specific component.
    
    return [_array objectAtIndex:row];
    
}

#pragma mark Picker Data Source Methods


- (IBAction)backButton:(id)sender {
}
@end