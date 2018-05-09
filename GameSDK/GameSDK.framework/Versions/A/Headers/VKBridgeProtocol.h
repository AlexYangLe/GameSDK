//
//  VKBridgeProtocol.h
//  letsgame
//
//  Created by king on 15/10/29.
//
//

#import <Foundation/Foundation.h>
#import "VKToken.h"

typedef void(^onVKTokenGoten)(NSString*token,NSString*uid);

@protocol VKBridgeProtocol <NSObject>

-(void)setVKBlock:(onVKTokenGoten)block;

-(void)setHoldViewController:(UIViewController*)vc;

-(BOOL)processOpenURL:(NSURL*) url fromApplication:(NSString*)sourceApplication;


-(void)authorize;

-(VKToken *)getToken;

-(void)vkLogout;
@end