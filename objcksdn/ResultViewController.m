//
//  ResultViewController.m
//  objcksdn
//
//  Created by MS on 6/20/16.
//  Copyright © 2016 Sarbasov inc. All rights reserved.
//

#import "ResultViewController.h"
#import "NSViewController+BFNavigationController.h"
#import "BFNavigationController.h"

@interface ResultViewController ()
@property (weak) IBOutlet NSTextField *resultLabel;

@end

@implementation ResultViewController
{
    double result;
}

- (instancetype)initWithResult:(double) res
{
    self = [super init];
    if (self) {
        result = res;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    int percent;
    if (result < 1.4) {
        percent = 99;
    } else if (result > 2.5) {
        percent = 1;
    } else {
        percent = round((2.5 - result)/1.1 * 100);
    }
    
    
    
    self.resultLabel.stringValue = [NSString stringWithFormat:@"%d%%", percent];
    // Do view setup here.
}

- (IBAction)createNew:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)tryAgain:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
