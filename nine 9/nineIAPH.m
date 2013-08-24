//
//  nineIAPH.m
//  nine 9
//
//  Created by Mark Bellott on 8/19/12.
//
//

#import "nineIAPH.h"


@implementation nineIAPH

+ (nineIAPH *) sharedHelper {
    static nineIAPH * _sharedHelper = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHelper = [[nineIAPH alloc] init];
    });

    return _sharedHelper;
    
}

- (id)init {
    NSSet *productIdentifiers = [NSSet setWithObjects:
                                 @"nine9AdRemover",
                                 nil];
    
    if ((self = [super initWithProductIdentifiers:productIdentifiers])) {                
        
    }
    return self;
    
}

@end