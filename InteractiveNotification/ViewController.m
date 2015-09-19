//
//  ViewController.m
//  InteractiveNotification
//
//  Created by pronebird on 7/26/15.
//  Copyright (c) 2015 pronebird. All rights reserved.
//

#import "ViewController.h"
#import "NotificationDispatch.h"
#import "NotificationDispatch+Actions.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NotificationDispatch registerForAction:NotificationActionReplyIdent handler:^(NSDictionary *responseInfo) {
        NSString *message = responseInfo[UIUserNotificationActionResponseTypedTextKey];
        
        [self showReplyAlertWithMessage:message];
    }];
    
    [NotificationDispatch registerForLocalNotificationCategory:NotificationCategoryIdent handler:^(UILocalNotification *notification) {
        [self showReplyPromptForNotification:notification];
    }];
}

- (void)showReplyAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reply" message:[NSString stringWithFormat:@"You have replied: %@", message] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showReplyPromptForNotification:(UILocalNotification *)notification {
    __weak UIAlertController *weakAlert;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:notification.alertTitle message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
    
    weakAlert = alert;
    
    UIAlertAction *ignore = [UIAlertAction actionWithTitle:@"Ignore" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    
    UIAlertAction *reply = [UIAlertAction actionWithTitle:@"Reply" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = weakAlert.textFields[0];
        
        [self showReplyAlertWithMessage:textField.text];
    }];

    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Type in your reply...";
    }];

    [alert addAction:ignore];
    [alert addAction:reply];

    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)showNotification:(id)sender {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.category = NotificationCategoryIdent;
    notification.alertBody = @"Pull down to reply.";
    notification.alertTitle = @"Incoming message";
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.fireDate = [[NSDate date] dateByAddingTimeInterval:5];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
