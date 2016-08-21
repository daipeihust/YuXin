//
//  UIViewController+MailComposer.m
//  PopU
//
//  Created by zhao wei on 13-11-14.
//  Copyright (c) 2013年 Pinssible. All rights reserved.
//

#import "UIViewController+MailComposer.h"
#import "UserHelper.h"

#define SUPPORT_EMAIL       @"daipei@hust.edu.cn"

@implementation UIViewController (MailComposer)

#pragma mark - MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Privite Method

- (void)sendMessageWithSubject:(NSString *)subject toAddress:(NSString *)address {
    NSString *model = [[UIDevice currentDevice] name];
    NSString *systemName = [[UIDevice currentDevice] systemName];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    CGSize screenSize = [UIScreen mainScreen].currentMode.size;
    
    NSString *userName = [UserHelper sharedInstance].userName;
    NSString *contactMessageBody;
    contactMessageBody = @"\n\n\n\n\n Username: %@\n OS Name : %@\n OS Version : %@\n Device Model : %@\n Device Resolution : %.0f*%.0f";
    NSString *mailMessageBody = [NSString stringWithFormat:contactMessageBody, userName, systemName, systemVersion, model, screenSize.width, screenSize.height];
    NSString *mailSubject = subject;
    
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail]) {
        mailViewController.mailComposeDelegate = self;
        [mailViewController setToRecipients:[NSArray arrayWithObjects:address, nil]];
        [mailViewController setSubject:mailSubject];
        [mailViewController setMessageBody:mailMessageBody isHTML:NO];
        mailViewController.modalPresentationStyle = UIModalPresentationPageSheet;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self presentViewController:mailViewController animated:YES completion:nil];
        });
    }
}

#pragma mark - Public Method

- (void)sendContactMessageWithSubject:(NSString *)subject {
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"Simulator cann't use email.");
#else
    [self sendMessageWithSubject:subject toAddress:SUPPORT_EMAIL];
#endif
}

@end
