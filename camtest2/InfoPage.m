//
//  InfoPage.m
//  Range Finder
//
//  Created by Carter Crenshaw Howard Gray on 5/13/14.
//  Copyright (c) 2014 Carter Crenshaw Howard Gray. All rights reserved.
//

#import "InfoPage.h"
#import "ViewController.h"



@interface InfoPage ()

@end

@implementation InfoPage


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _inLabel.hidden = YES;
    
    _ftLabel.hidden = YES;
    
    _startButton.hidden = YES;
    
    //picker code
    self.feetHeight= [[NSArray alloc] initWithObjects:@"Enter", @"3", @"4", @"5", @"6", nil];
    
    self.inchHeight = [[NSArray alloc] initWithObjects:@"Height!", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10",@"11", nil];
    
    //instructions scroll code
    int PageCount = 5;
    
    UIScrollView *Scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 76, 320, 240)];
    
    Scroller.backgroundColor = [UIColor clearColor];
    
    Scroller.pagingEnabled = YES;
    
    Scroller.contentSize = CGSizeMake(PageCount * Scroller.bounds.size.width, Scroller.bounds.size.height);
    
    CGRect ViewSize = Scroller.bounds;
    
    //Setup and Add Images
    UIImageView *ImgView = [[UIImageView alloc] initWithFrame:ViewSize];
    [ImgView setImage:[UIImage imageNamed:@"height stand chest.png"]];
    [Scroller addSubview:ImgView];
    
    //Offset View Size
    ViewSize = CGRectOffset(ViewSize, Scroller.bounds.size.width, 0);
    
    UIImageView *ImgView2 = [[UIImageView alloc] initWithFrame:ViewSize];
    [ImgView2 setImage:[UIImage imageNamed:@"final basketball.png"]];
    [Scroller addSubview:ImgView2];
    
    //Offset View Size
    ViewSize = CGRectOffset(ViewSize, Scroller.bounds.size.width, 0);
    
    UIImageView *ImgView3 = [[UIImageView alloc] initWithFrame:ViewSize];
    [ImgView3 setImage:[UIImage imageNamed:@"final smart golfer.png"]];
    [Scroller addSubview:ImgView3];
    
    //Offset View Size
    ViewSize = CGRectOffset(ViewSize, Scroller.bounds.size.width, 0);
    
    UIImageView *ImgView4 = [[UIImageView alloc] initWithFrame:ViewSize];
    [ImgView4 setImage:[UIImage imageNamed:@"final dumb golfer.png"]];
    [Scroller addSubview:ImgView4];
    
    //Offset View Size
    ViewSize = CGRectOffset(ViewSize, Scroller.bounds.size.width, 0);
    
    UIImageView *ImgView5 = [[UIImageView alloc] initWithFrame:ViewSize];
    [ImgView5 setImage:[UIImage imageNamed:@"snowunit button instructions.png"]];
    [Scroller addSubview:ImgView5];
    
    
    
    [self.view addSubview:Scroller];
    
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
   // if ([segue.identifier isEqualToString:@"sendChestLevel"]) {
    
        ViewController *destViewController = (ViewController *)[segue destinationViewController];
        
        destViewController.chestLevelPassed = chestLevel;
        
   // }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//pickercode
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if(component == 0)
    {
        return [self.feetHeight objectAtIndex:row];
    }
    else
    {
        return [self.inchHeight objectAtIndex:row];
    }
    return 0;
    
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 2;
    
}



-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if(component == 0)
    {
        return [self.feetHeight count];
    }
    else if (component == 1)
    {
        return [self.inchHeight count];
    }
    return 0;
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    
    NSInteger firstComponentRow = [self.pickerHeight selectedRowInComponent:0];
    NSInteger secondComponentRow = [self.pickerHeight selectedRowInComponent:1];
    
    
    switch(firstComponentRow) {
        case 0:
            caseFeet = 0;
            switchHeight = caseInches + caseFeet;
            chestLevel = (switchHeight * 0.9);
            _ftLabel.hidden = YES;
            break;
        case 1:
            caseFeet = 3;
            switchHeight = caseInches + caseFeet;
            chestLevel = (switchHeight * 0.9);
            _ftLabel.hidden = NO;
            _swipeLabelBackground.hidden = YES;
            _startButton.hidden = NO;
            _swipeLabel.text = @"Start!";
            break;
        case 2:
            caseFeet = 4;
            switchHeight = caseInches + caseFeet;
            chestLevel = (switchHeight * 0.9);
            _ftLabel.hidden = NO;
            _swipeLabelBackground.hidden = YES;
            _startButton.hidden = NO;
            _swipeLabel.text = @"Start!";
            break;
        case 3:
            caseFeet = 5;
            switchHeight = caseInches + caseFeet;
            chestLevel = (switchHeight * 0.9);
            _ftLabel.hidden = NO;
            _swipeLabelBackground.hidden = YES;
            _startButton.hidden = NO;
            _swipeLabel.text = @"Start!";
            break;
        case 4:
            caseFeet = 6;
            switchHeight = caseInches + caseFeet;
            chestLevel = (switchHeight * 0.9);
            _ftLabel.hidden = NO;
            _swipeLabelBackground.hidden = YES;
            _startButton.hidden = NO;
            _swipeLabel.text = @"Start!";
            break;
    }
    
    switch(secondComponentRow)
    {
        case 0:
            caseInches = 0;
            switchHeight = caseInches + caseFeet;
            chestLevel = (switchHeight * 0.9);
            _inLabel.hidden = YES;
            break;
        case 1:
            caseInches = 0;
            switchHeight = caseInches + caseFeet;
            chestLevel = (switchHeight * 0.9);
            _inLabel.hidden = NO;
            _swipeLabelBackground.hidden = YES;
            _startButton.hidden = NO;
            _swipeLabel.text = @"Start!";
            break;
        case 2:
            caseInches = 0.08333333;
            switchHeight = caseInches + caseFeet;
            chestLevel = (switchHeight * 0.9);
            _inLabel.hidden = NO;
            _swipeLabelBackground.hidden = YES;
            _startButton.hidden = NO;
            _swipeLabel.text = @"Start!";
            break;
        case 3:
            caseInches = .166666666;
            switchHeight = caseInches + caseFeet;
            chestLevel = (switchHeight * 0.9);
            _inLabel.hidden = NO;
            _swipeLabelBackground.hidden = YES;
            _startButton.hidden = NO;
            _swipeLabel.text = @"Start!";
            break;
        case 4:
            caseInches = .25;
            switchHeight = caseInches + caseFeet;
            chestLevel = (switchHeight * 0.9);
            _inLabel.hidden = NO;
            _swipeLabelBackground.hidden = YES;
            _startButton.hidden = NO;
            _swipeLabel.text = @"Start!";
            break;
        case 5:
            caseInches  = .33333333;
            switchHeight = caseInches + caseFeet;
            chestLevel = (switchHeight * 0.9);
            _inLabel.hidden = NO;
            _swipeLabelBackground.hidden = YES;
            _startButton.hidden = NO;
            _swipeLabel.text = @"Start!";
            break;
        case 6:
            caseInches  = .41666666;
            switchHeight = caseInches + caseFeet;
            chestLevel = (switchHeight * 0.9);
            _inLabel.hidden = NO;
            _swipeLabelBackground.hidden = YES;
            _startButton.hidden = NO;
            _swipeLabel.text = @"Start!";
        case 7:
            caseInches = .5;
            switchHeight = caseInches + caseFeet;
            chestLevel = (switchHeight * 0.9);
            _inLabel.hidden = NO;
            _swipeLabelBackground.hidden = YES;
            _startButton.hidden = NO;
            _swipeLabel.text = @"Start!";
            break;
        case 8:
            caseInches = .58333333;
            switchHeight = caseInches + caseFeet;
            chestLevel = (switchHeight * 0.9);
            _inLabel.hidden = NO;
            _swipeLabelBackground.hidden = YES;
            _startButton.hidden = NO;
            _swipeLabel.text = @"Start!";
            break;
        case 9:
            caseInches = .66666666;
            switchHeight = caseInches + caseFeet;
            chestLevel = (switchHeight * 0.9);
            _inLabel.hidden = NO;
            _swipeLabelBackground.hidden = YES;
            _startButton.hidden = NO;
            _swipeLabel.text = @"Start!";
            break;
        case 10:
            caseInches = .75;
            switchHeight = caseInches + caseFeet;
            chestLevel = (switchHeight * 0.9);
            _inLabel.hidden = NO;
            _swipeLabelBackground.hidden = YES;
            _startButton.hidden = NO;
            _swipeLabel.text = @"Start!";
            break;
        case 11:
            caseInches  = .833333333;
            switchHeight = caseInches + caseFeet;
            chestLevel = (switchHeight * 0.9);
            _inLabel.hidden = NO;
            _swipeLabelBackground.hidden = YES;
            _startButton.hidden = NO;
            _swipeLabel.text = @"Start!";
            break;
        case 12:
            caseInches  = .916666666;
            switchHeight = caseInches + caseFeet;
            chestLevel = (switchHeight * 0.9);
            _inLabel.hidden = NO;
            _swipeLabelBackground.hidden = YES;
            _startButton.hidden = NO;
            _swipeLabel.text = @"Start!";
            break;
    }
}

@end
