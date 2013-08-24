//
//  playLayer.h
//  nine 9
//
//  Created by Mark Bellott on 7/1/12.
//  Copyright 2012 MarkBellott. All rights reserved.
//
//  The playLayer Super Class, from which the real playLayers are subclassed

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import <iAd/iAd.h>
#import "cocos2d.h"
#import "tile.h"
#import "CCTouchDispatcher.h"

@class MenuLayer;
@class GCHelper;

@interface playLayer : CCLayer <ADBannerViewDelegate> {
    
    ADBannerView *bannerView;
    
    GKAchievement *aL, *a9, *a16, *a25, *aM;
    
    tile *tileBlank;
    
    NSMutableArray *tiles;
    NSMutableDictionary *tmpHighScores;
    
    CGSize winSize;
    CGRect tileRect;
    NSInteger numberCounted, numMoves, timeMinutes, timeSeconds, totalSeconds,
    tmpBestTime, bestMinutes, bestSeconds, puzzleSize;
    
    NSString *movesString, *timeString, *bestTimeString, *scoreTag, *scoreDictionaryTag;
    CCLabelTTF *movesLabel, *timeLabel, *pauseMoves, *pauseTime, *bestTimeLabel;
    
    CCMenu *pauseButton, *tmpMenu;
    CCMenuItemImage *pauseSprite;
    
    CCSprite *backgroundSprite, *topBar,
    *pauseBackground, *completedSprite,
    *completedBestSpritre;
    
    BOOL paused, completed, lockdown, animateMove, adRemover;
    
    CCScene *tmpScene;
    
    NSUserDefaults *defaults;
    
}

+(CCScene*) scene;

//Puzzle Init Methods
-(void) loadAdBanner;
-(void) loadTiles;
-(void) dismissTiles;
-(void) dismissTopBar;
-(void) shuffleTiles;
-(void) animateTiles;

//Movement Methods
-(void) findMoves:(tile*) t;
-(void) shuffleMove:(tile*) t;
-(void) moveTile:(tile*) t;

//Input Handling Methods
-(void) registerWithTouchDispatcher;
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
-(tile*) getTileAtPoint:(CGPoint) p;

//Checking Methods
-(void) checkCounted;
-(void) changeTextures;
-(void) checkCompleted;

//Timer Methods
-(void) tick:(ccTime) dt;

//Pause Methods
-(void) pausePressed;
-(void) loadPause;
-(void) dismissPause;
-(void) resumePressed;
-(void) menuPressed;

//Completed Methods
-(void) loadCompleted;
-(void) loadCompletedNotBest;
-(void) loadCompletedNewBest;
-(void) restartPressed;
-(void) reloadCurrentScene;
-(void) achievementChecker;
-(void) reportAchievements;

//Return to Main
-(void) returnToMenu;

//Best time methods
-(NSInteger) findMinutes: (NSInteger) seconds;
-(NSInteger) findSeconds: (NSInteger) seconds;

@end
