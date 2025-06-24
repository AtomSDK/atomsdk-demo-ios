//
//  AppDelegate.h
//  AtomSDK Demo

#import <UIKit/UIKit.h>
#import <AtomSDK/AtomManager.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;
@property (nonatomic) NSString *UDID;
@property (nonatomic) NSString *secretKey;
@property UIBackgroundTaskIdentifier bgtask;

+(instancetype)sharedInstance;

@end

