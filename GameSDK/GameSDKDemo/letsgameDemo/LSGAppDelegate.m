//
//  LSGAppDelegate.m
//  letsgameDemo
//
//  Created by zhy on 14-5-24.
//
//

#import "LSGAppDelegate.h"
#import "LSGMainViewController.h"
#import "LetsGameAPI.h"

@implementation LSGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    [LetsGameAPI DeviceOrientationIsHorizontal:NO];
    
    LSGMainViewController *viewController = [[LSGMainViewController alloc] init];
    self.window.rootViewController = viewController;
    [self.window addSubview:viewController.view];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    [[LetsGameAPI instance] decideIsDebug:1];
    
    //显示是否侵权的接口
    [[LetsGameAPI instance] gameObtainSafeSetInfoWithAppId:@"10056" ChannelId:@"1000" handleCallBack:^(BOOL resultStatus) {
        if (resultStatus) {
            NSLog(@"YES 侵权");
        }else{
            NSLog(@"NO 不侵权");
        }
    }];

    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[LetsGameAPI instance] registeIapObserver];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[LetsGameAPI instance] handleOpenURL:url sourceApplication:sourceApplication];
    //return [[LetsGameAPI instance].vkBridge processOpenURL:url fromApplication:sourceApplication];
}


@end
