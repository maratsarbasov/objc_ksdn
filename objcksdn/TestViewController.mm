//
//  TestViewController.m
//  objcksdn
//
//  Created by MS on 6/18/16.
//  Copyright © 2016 Sarbasov inc. All rights reserved.
//

#import "TestViewController.h"
#include "Keycodes.h"
#include "Types.h"
#include "KeystrokeCaptureData.hpp"
#include "FeatureExtractor.hpp"
#include "Adjecent.hpp"
#include "Fingerprint.hpp"
#import "ResultViewController.h"
#import "NSViewController+BFNavigationController.h"
#import "BFNavigationController.h"

@interface TestViewController ()
@property (weak) IBOutlet NSTextField *textField;

@end

@implementation TestViewController {
    KeystrokeCaptureData kcdata;
    FeatureExtractor fe;
    NSEvent *monitor;
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    NSLog(@"TestVC appeared");
    [self.textField setStringValue:@""];
    kcdata = KeystrokeCaptureData();
    fe = FeatureExtractor();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    // Do view setup here.
}

- (IBAction)getScore:(id)sender
{
    kcdata.feed(fe);
    auto features = fe.extract_features();
    Fingerprint fingerprint = Fingerprint(features);
    
    ResultViewController *result = [[ResultViewController alloc] initWithResult:fingerprint.canberra_distance(_geniuneFingerprint)];

    
    NSLog(@"%f", fingerprint.canberra_distance(_geniuneFingerprint));
    
    
    [self.navigationController pushViewController:result animated:YES];
    
    
}

@end
