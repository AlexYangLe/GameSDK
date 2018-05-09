//
//  VKBridge.h
//  VKBridge
//
//  Created by king on 15/10/30.
//  Copyright © 2015年 Gump. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VKSdk/VKSdk.h>
#import "LetsGameAPI.h"

//@interface UIViewController (ForVK)
//-(void)loginWithVkToken:(NSString*)token andUid:(NSString *)uid;
//
//@end
@interface VKBridge : NSObject<VKSdkDelegate,VKBridgeProtocol>


@property (nonatomic,retain)UIViewController *holdViewController;
@property (nonatomic,copy) onVKTokenGoten vKBlock;

-(instancetype)initWithVKAppId:(NSString*)vkAppId;


@end
