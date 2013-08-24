//
//  MenuLayer.h
//  nine 9
//
//  Created by Mark Bellott on 6/20/12.
//  Copyright MarkBellott 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "nineIAPH.h"
#import "ABGameKitHelper.h"

#import "nineDiagonalLayer.h"
#import "nineClassicLayer.h"
#import "nineDiagonalLockdown.h"
#import "nineClassicLockdown.h"
#import "sixteenClassicLayer.h"
#import "sixteenDiagonalLayer.h"
#import "sixteenClassicLockdown.h"
#import "sixteenDiagonalLockdown.h"
#import "twentyfiveClassicLayer.h"
#import "twentyfiveClassicLockdown.h"
#import "twentyfiveDiagonalLayer.h"
#import "twentyfiveDiagonalLockdown.h"

//Declare enum for tracking current menu state
typedef enum {
    MAIN, BESTTIMES,
    SETTINGS, ABOUT,
    ADREMOVE, HOWTO,
    CHOOSENUMBER, CHOOSEMODE,
    CHOOSEMODELOCK
} menuState;

typedef enum {
    NINE, SIXTEEN, TWENTYFIVE
} numberState;

typedef enum {
    DIAGONAL, DIAGONALLOCK,
    CLASSIC, CLASSICLOCK
} modeState;

BOOL animateTileMove;

@class GameCenterManager;

@interface MenuLayer : CCLayer <ADBannerViewDelegate>

@property (nonatomic,strong) ADBannerView *bannerView;
@property (nonatomic, strong) GameCenterManager *gameCenterManager;

+(CCScene*) scene;

@end
