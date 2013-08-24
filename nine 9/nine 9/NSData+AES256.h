//
//  NSData+AES256.h
//  nine 9 -- Mark Bellott
//
//  Created by Alexander Blunck on 08.05.12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)

- (NSData*) encryptedWithKey:(NSData*) key;

- (NSData*) decryptedWithKey:(NSData*) key;

@end

