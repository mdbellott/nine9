//
//  twentyfiveDiagonalLayer.h
//  nine 9
//
//  Created by Mark Bellott on 7/25/12.
//  Copyright 2012 MarkBellott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "playLayer.h"

@interface twentyfiveDiagonalLayer : playLayer {
    
    //Declare Tiles
    tile *tile01, *tile02, *tile03, *tile04, *tile05, *tile06,
    *tile07, *tile08, *tile09, *tile10, *tile11, *tile12, *tile13,
    *tile14, *tile15, *tile16, *tile17, *tile18, *tile19, *tile20,
    *tile21, *tile22, *tile23, *tile24;
    
    //Declare Positions
    CGPoint  ipos2500, ipos2501, ipos2502, ipos2503,
    ipos2504, ipos2505, ipos2506, ipos2507, ipos2508,
    ipos2509, ipos2510, ipos2511, ipos2512, ipos2513,
    ipos2514, ipos2515, ipos2516, ipos2517, ipos2518,
    ipos2519, ipos2520, ipos2521, ipos2522, ipos2523,
    ipos2524;
    
    //Declare Textures
    CCTexture2D *t2501no, *t2501yes,
    *t2502no, *t2502yes, *t2503no, *t2503yes,
    *t2504no, *t2504yes, *t2505no, *t2505yes,
    *t2506no, *t2506yes, *t2507no, *t2507yes,
    *t2508no, *t2508yes, *t2509no, *t2509yes,
    *t2510no, *t2510yes, *t2511no, *t2511yes,
    *t2512no, *t2512yes, *t2513no, *t2513yes,
    *t2514no, *t2514yes, *t2515no, *t2515yes,
    *t2516no, *t2516yes, *t2517no, *t2517yes,
    *t2518no, *t2518yes, *t2519no, *t2519yes,
    *t2520no, *t2520yes, *t2521no, *t2521yes,
    *t2522no, *t2522yes, *t2523no, *t2523yes,
    *t2524no, *t2524yes;
    
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