#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LSGAccountType) {
    LSGAccountTypeRegist = 1,
    LSGAccountTypeFBRegist = 2,
    LSGAccountTypeQuickRegist = 4,
    LSGAccountTypeVKRegist = 8,
    LSGAccountTypeGoogleRegist = 16,
    LSGAccountTypeWeChatRegist = 32,
    LSGAccountTypeLineRegist = 64,
};

//判断是不是自动登录情况
#define LSGAccountTypeBaseLogin 128

@interface LSGAccount : NSObject

@property(nonatomic, assign) LSGAccountType type;
@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *password;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *sessionKey;
@property(nonatomic, copy) NSString *deviceId;
@property(nonatomic, copy) NSString *sessionInvalidT;

+ (void)saveAccount:(NSString *)service account:(LSGAccount *)account;

+ (LSGAccount *)loadAccount:(NSString *)service;

+ (void)deleteAccount:(NSString *)service;

@end
