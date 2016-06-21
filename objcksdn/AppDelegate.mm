//
//  AppDelegate.m
//  objcksdn
//
//  Created by MS on 6/15/16.
//  Copyright © 2016 Sarbasov inc. All rights reserved.
//

#import "AppDelegate.h"
#include "KeystrokeCaptureData.hpp"
#include "FeatureExtractor.hpp"
#include "Types.h"
#include <iostream>
#include <vector>
#include "Keycodes.h"
#import "LearnTypingPatternViewController.h"
#import "BFNavigationController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong, nonatomic) LearnTypingPatternViewController *lt;
@property KeystrokeCaptureData kcdata;
@property FeatureExtractor fe;
@end

@implementation AppDelegate
{
    BFNavigationController *nav;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    LearnTypingPatternViewController *lt = [[LearnTypingPatternViewController alloc] init];
    nav = [[BFNavigationController alloc] initWithFrame:lt.view.frame rootViewController:lt];
    
    
    [self.window.contentView addSubview:nav.view];

}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    
}

@end
