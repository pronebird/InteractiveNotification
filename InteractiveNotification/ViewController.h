//
//  ViewController.h
//  InteractiveNotification
//
//  Created by pronebird on 7/26/15.
//  Copyright (c) 2015 pronebird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (void)showReplyAlertWithMessage:(NSString *)message completion:(void(^)())completion;
- (void)showReplyPromptForNotification:(UILocalNotification *)notification;

@end

