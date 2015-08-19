//
//  DJKeyObfuscation.m
//
//  Created by Daniel Jackson on 8/18/15.
//  Copyright (c) 2015 Daniel Jackson. All rights reserved.
//

#import "DJKeyObfuscation.h"
#include <CommonCrypto/CommonCrypto.h>

@interface DJKeyObfuscation ()

@end

@implementation DJKeyObfuscation

//LIMIT 48 chars.
+ (void)printObfuscationSecretArray:(NSString*)key
{
    const unsigned char* obfuscatedSecretKey = (const unsigned char*)[key UTF8String];
    
    unsigned char obfuscator[CC_SHA384_DIGEST_LENGTH];
    NSData *className = [NSStringFromClass([ViewController class])
                         dataUsingEncoding:NSUTF8StringEncoding];
    CC_SHA384(className.bytes, (CC_LONG)className.length, obfuscator);
    
    NSMutableString* hexString = [NSMutableString new];
    unsigned char actualSecretKey[key.length];
    for (int i=0; i<key.length; i++) {
        
        if (i!=0) {
            [hexString appendString:@", "];
        }
        
        actualSecretKey[i] = obfuscatedSecretKey[i] ^ obfuscator[i];
        [hexString appendFormat:@"%02x", (unsigned int)actualSecretKey[i]];
    }
    
    NSLog(@"{ %@ }", hexString);
}

+ (NSString*)keyFromArray:(const unsigned char*)obfuscatedSecretKey length:(int)length
{
    // Get the SHA1 of a class name, to form the obfuscator.
    unsigned char obfuscator[CC_SHA384_DIGEST_LENGTH];
    NSData *className = [NSStringFromClass([ViewController class])
                         dataUsingEncoding:NSUTF8StringEncoding];
    CC_SHA384(className.bytes, (CC_LONG)className.length, obfuscator);
    
    // XOR the class name against the obfuscated key, to form the real key.
    unsigned char actualSecretKey[length];
    for (int i=0; i<length; i++) {
        actualSecretKey[i] = obfuscatedSecretKey[i] ^ obfuscator[i];
    }
    
    return [[NSString alloc] initWithBytes:actualSecretKey length:length encoding:NSUTF8StringEncoding];
}

- (id)init {
    self = [super init];
    if (self)
    {
        [self work];
    }
    return self;
}

- (void)work
{
    NSLog(@"Starting Hashing!");
    
    // Max chars must be < SHA value. (currently 48)
    // REMOVE IN PROD
    NSString* secret = @"e2cc765a81604edb99658aed289276d6";
    
    // This will print the SHA(class name) XOR secret byte array. To be used below
    // REMOVE IN PROD
    [self.class printObfuscationSecretArray:secret];
    
    
    // Stored as binary array to prevent strings attack
    // Stored using SHA(class name) XOR secret
    unsigned char obfuscatedSecretKey[] = { 0x3e, 0xcc, 0x9d, 0xca, 0x2f, 0x8a, 0xf2, 0xc1, 0x57, 0x01, 0xc2, 0x2e, 0x44, 0xea, 0x0d, 0xf5, 0x60, 0x09, 0x99, 0xe7, 0xb1, 0x13, 0x2a, 0x6f, 0x2c, 0xa2, 0xfe, 0x12, 0xbb, 0x58, 0x90, 0x85 };
    
    // Converts the XORed value back to the secret.
    NSLog(@"%@", [self.class keyFromArray:obfuscatedSecretKey length:32]);
}

@end
