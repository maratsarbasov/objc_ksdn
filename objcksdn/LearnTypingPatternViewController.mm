//
//  LearnTypingPatternViewController.m
//  objcksdn
//
//  Created by MS on 6/18/16.
//  Copyright © 2016 Sarbasov inc. All rights reserved.
//

#import "LearnTypingPatternViewController.h"
#include "Types.h"
#include "Keycodes.h"
#include "KeystrokeCaptureData.hpp"
#include "FeatureExtractor.hpp"
#include "Adjecent.hpp"
#include "Fingerprint.hpp"
#import "TestViewController.h"
#import "NSViewController+BFNavigationController.h"
#import "BFNavigationController.h"


@interface LearnTypingPatternViewController () <NSTextDelegate>
@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSButton *button;

@end

@implementation LearnTypingPatternViewController
{
    KeystrokeCaptureData kcdata;
    FeatureExtractor fe;
    NSEvent *monitor;
}



- (void)viewWillAppear
{
    [super viewWillAppear];
    monitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask|NSKeyUpMask|NSFlagsChangedMask handler:^NSEvent * _Nullable(NSEvent * _Nonnull e) {
        int keycode = int(e.keyCode);
        time_t timestamp = e.timestamp * 1000.0;
        //NSLog(@"%@", e);
        EventType type;
        switch (e.type) {
            case NSKeyDown:
                type = KEY_DOWN;
                break;
            case NSKeyUp:
                type = KEY_UP;
                break;
            case NSFlagsChanged:
                if ([e modifierFlags] & NSShiftKeyMask && keycode == kVK_Shift) {
                    type = KEY_DOWN;
                } else if (keycode == kVK_Shift) {
                    type = KEY_UP;
                }
                break;
            default:
                break;
        }
        kcdata.on_key(keycode, type, timestamp);
        return e;
    }];
    
    [self.textField setStringValue:@""];
    kcdata = KeystrokeCaptureData();
    fe = FeatureExtractor();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    


}

- (IBAction)learnPattern:(id)sender
{
    kcdata.feed(fe);
    auto features = fe.extract_features();
    Fingerprint fingerprint = Fingerprint(features);
    
    TestViewController *testVC = [[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil];
    testVC.geniuneFingerprint = fingerprint;
    [self.navigationController pushViewController:testVC animated:YES];
    

    [NSEvent removeMonitor:monitor];
}



@end
