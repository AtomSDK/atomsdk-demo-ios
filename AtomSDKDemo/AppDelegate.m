//
//  AppDelegate.m
//  AtomSDK Demo

#import "AppDelegate.h"

#define ATOM_SDK_SECRET_KEY @"<#YOUR_SECRET_KEY#>"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//  AtomManager instance with Secret key
    [AtomManager sharedInstanceWithSecretKey:ATOM_SDK_SECRET_KEY];
    self.secretKey = ATOM_SDK_SECRET_KEY;
    
//    AtomManager instance with Atom Configuration
//    AtomConfiguration *atomConfiguration = [[AtomConfiguration alloc] init];
//    atomConfig.secretKey = @"<#SECRETKEY_GOES_HERE#>";
//    atomConfig.vpnInterfaceName = @"<#Atom#>";
//    atomConfig.baseUrl = [NSURL URLWithString:@"<#YOUR_BASE_URL#>"];
//    [AtomManager sharedInstanceWithAtomConfiguration:atomConfig];
    
//Installing Profile in settings on Application launch
    
    [[AtomManager sharedInstance] installVPNProfileWithCompletion:^(NSString *success) {
        NSLog(@"profile installed");
    } errorBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    self.bgtask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:self.bgtask];
    }];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        self.bgtask = UIBackgroundTaskInvalid;
        [application endBackgroundTask:self.bgtask];
    });
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[AtomManager sharedInstance] disconnectVPN];
}

+(instancetype)sharedInstance {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
