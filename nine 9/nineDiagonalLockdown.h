//
//  nineDiagonalLockdown.h
//  nine 9
//
//  Created by Mark Bellott on 7/1/12.
//  Copyright 2012 MarkBellott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "playLayer.h"

@interface nineDiagonalLockdown : playLayer {
    
    //Declare Tiles
    tile *tile01, *tile02, *tile03,
    *tile04, *tile05, *tile06,
    *tile07, *tile08;
    
    //Declare Positions
    CGPoint ipos900, ipos901, ipos902, ipos903,
    ipos904, ipos905, ipos906, ipos907, ipos908;
    
    //Declare Textures
    CCTexture2D *t901no, *t901yes,
    *t902no, *t902yes,*t903no, *t903yes,
    *t904no, *t904yes,*t905no, *t905yes,
    *t906no, *t906yes,*t907no, *t907yes,
    *t908no, *t908yes;
    
}

+(CCScene*) scene;

//Puzzle Init Methods
-(void) loadTiles;
-(void) shuffleTiles;

//Movement Methods
-(void) findMoves:(tile*) t;

//Checking Methods
-(void) checkCounted;

//Return Method
-(void) restartPressed;
-(void) reloadCurrentScene;
-(void) menuPressed;

@end
