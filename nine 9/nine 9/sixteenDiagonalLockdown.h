//
//  sixteenDiagonalLockdown.h
//  nine 9
//
//  Created by Mark Bellott on 7/1/12.
//  Copyright 2012 MarkBellott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "playLayer.h"

@interface sixteenDiagonalLockdown : playLayer {
    
    //Declare Tiles
    tile *tile01, *tile02, *tile03,
    *tile04, *tile05, *tile06,
    *tile07, *tile08, *tile09,
    *tile10, *tile11, *tile12,
    *tile13, *tile14, *tile15;
    
    //Declare Positions
    CGPoint  ipos1600, ipos1601, ipos1602, ipos1603,
    ipos1604, ipos1605, ipos1606, ipos1607, ipos1608,
    ipos1609, ipos1610, ipos1611, ipos1612, ipos1613,
    ipos1614, ipos1615;
    
    //Declare Textures
    CCTexture2D *t1601no, *t1601yes,
    *t1602no, *t1602yes, *t1603no, *t1603yes,
    *t1604no, *t1604yes, *t1605no, *t1605yes,
    *t1606no, *t1606yes, *t1607no, *t1607yes,
    *t1608no, *t1608yes, *t1609no, *t1609yes,
    *t1610no, *t1610yes, *t1611no, *t1611yes,
    *t1612no, *t1612yes, *t1613no, *t1613yes,
    *t1614no, *t1614yes, *t1615no, *t1615yes;
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