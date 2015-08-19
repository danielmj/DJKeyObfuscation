//
//  DJKeyObfuscation.h
//  encryptor
//
//  Created by Daniel Jackson on 8/18/15.
//  Copyright (c) 2015 Daniel Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJKeyObfuscation : NSObject

+ (NSString*)keyFromArray:(const unsigned char*)obfuscatedSecretKey length:(int)length;
+ (void)printObfuscationSecretArray:(NSString*)key

@end

