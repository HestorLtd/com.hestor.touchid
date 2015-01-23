//
//  TouchID.m
//  Copyright (c) 2014 Simon Smith - http://www.hestor.com
//

#import "TouchID.h"

#import <LocalAuthentication/LocalAuthentication.h>

NSString *password123 = nil;

CDVInvokedUrlCommand* command123;

NSError *error123;

@implementation TouchID

- (void) errorMsg:(NSError *)error1 command1:(CDVInvokedUrlCommand*)command; {
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[error1 localizedDescription]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) authenticate:(CDVInvokedUrlCommand*)command; {
	NSString *text = [command.arguments objectAtIndex:0];
	password123 = [command.arguments objectAtIndex:1];
	__block CDVPluginResult* pluginResult = nil;
	if (NSClassFromString(@"LAContext") != nil) {
		LAContext *laContext = [[LAContext alloc] init];
		NSError *authError = nil;
		if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]){
			[laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:text reply:^(BOOL success, NSError *error){
				if (success){
					pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
					[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
				}else{
					switch (error.code) {
						case LAErrorAuthenticationFailed:
							NSLog(@"Authentication failed");
							[self errorMsg:error command1:command];
						break;
						case LAErrorUserCancel:
							NSLog(@"User canceled");
							[self errorMsg:error command1:command];
						break;
						case LAErrorUserFallback:{
							NSLog(@"User Fallback");
							if([password123 isEqual:@""]){
								NSLog(@"Empty Password, Dont Show Password Panel");
								[self errorMsg:error command1:command];
							}else{
								error123 = error;
								command123 = command;
								[[NSOperationQueue mainQueue] addOperationWithBlock:^{
									NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
									UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:appName message:@"Enter Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
									alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
									[alertView show];
									UITextField *textfield = [alertView textFieldAtIndex:0];
									[textfield becomeFirstResponder];
								}];
							}
						}
						break;
						case LAErrorSystemCancel:
							NSLog(@"System canceled");
							[self errorMsg:error command1:command];
						break;
						case LAErrorPasscodeNotSet:
							NSLog(@"Passcode not set");
							[self errorMsg:error command1:command];
						break;
						case LAErrorTouchIDNotAvailable:
							NSLog(@"TouchID not available");
							[self errorMsg:error command1:command];
						break;
						case LAErrorTouchIDNotEnrolled:
							NSLog(@"TouchID not enrolled");
							[self errorMsg:error command1:command];
						break;
						default:
							NSLog(@"Unknown");
							[self errorMsg:error command1:command];
						break;
					}
				}
			}];
		}else{
			[self errorMsg:authError command1:command];
		}
	}else{
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}
}

- (void) checkSupport:(CDVInvokedUrlCommand*)command;{
	__block CDVPluginResult* pluginResult = nil;
	if (NSClassFromString(@"LAContext") != nil){
		LAContext *laContext = [[LAContext alloc] init];
		NSError *authError = nil;
		if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]){
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
		}else{
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[authError localizedDescription]];
		}
	}else{
		pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	}
	[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	__block CDVPluginResult* pluginResult = nil;
	if (buttonIndex == 0) { // cancel
		[self errorMsg:error123 command1:command123];
	}else if (buttonIndex == 1) { // login
		UITextField *textfield = [alertView textFieldAtIndex:0];
		if ([textfield.text isEqualToString:password123]){
			NSLog(@"same");
			pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
			[self.commandDelegate sendPluginResult:pluginResult callbackId:command123.callbackId]; 
		}else{
			NSLog(@"not same");
			[self errorMsg:error123 command1:command123];
		}
	}
}

@end
