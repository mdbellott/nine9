//
//  playLayer.m
//  nine 9
//
//  Created by Mark Bellott on 7/1/12.
//  Copyright 2012 MarkBellott. All rights reserved.
//

#import "playLayer.h"
#import "MenuLayer.h"
#import "GCHelper.h"

@implementation playLayer

+(CCScene *) scene {
	CCScene *scene = [CCScene node];

	playLayer *layer = [playLayer node];
    
	[scene addChild: layer];
	
	return scene;
}

#pragma mark - Init Method

-(id) init {
    if( (self=[super init])) {
        //Each subclass must implement this function
        //Must include a call to loadAdBanner method
    }
	
    return self;
}

#pragma mark - Ad Init Methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [banner setHidden:NO];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [banner setHidden:YES];
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    [banner setHidden:YES];
}

-(void) loadAdBanner{
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"nine9AdRemover"]){
        adRemover = NO;
    }
    else{
        adRemover = YES;
    }
   
    if(!adRemover){
        static NSString * const kADBannerViewClass = @"ADBannerView";
        if (NSClassFromString(kADBannerViewClass) != nil) {
        
            bannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
            [bannerView setRequiredContentSizeIdentifiers:[NSSet setWithObjects:
                                                           ADBannerContentSizeIdentifierPortrait,
                                                           ADBannerContentSizeIdentifierLandscape, nil]];
        
            bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        
            [bannerView setDelegate:self];
        
            [[[CCDirector sharedDirector] view] addSubview:bannerView];
            [bannerView setHidden:YES];
        }
    }

}


#pragma mark - Puzzle Init Methods

-(void) loadTiles {
    //Each sbuclass must implement this function
}

-(void) dismissTiles{
    
    CGFloat tmpX, tmpY, timeDelay = 0.1;
    
    for(NSInteger i =([tiles count]-1); i>=0; i--){
        tile *t = [tiles objectAtIndex:i];
        tmpX = t.position.x; tmpY = (t.position.y - 480);
        [t runAction:[CCSequence actions:[CCDelayTime actionWithDuration:timeDelay],[CCMoveTo actionWithDuration:.1 position:ccp(tmpX,tmpY)], nil]];
        if(t != tileBlank){
            if(puzzleSize == 9){
                timeDelay += 0.075;
            }
            else if (puzzleSize == 16){
                timeDelay += 0.042;
            }
            else if (puzzleSize == 25){
                timeDelay += 0.027;
            }
        }
    }

}

-(void) dismissTopBar{
    id pauseButtonScrollOut = [CCMoveTo actionWithDuration:0.15 position:ccp(700,winSize.height/2 + 176.5)];
    id barScrollOut =[CCSequence actions:[CCDelayTime actionWithDuration:.1],
                      [CCMoveTo actionWithDuration:0.15 position:ccp(480, winSize.height/2 + 176)], nil];
    
    [pauseButton runAction:pauseButtonScrollOut];
    [topBar runAction:barScrollOut];
    
    movesLabel.visible = NO;
    timeLabel.visible = NO;
}

-(void) shuffleTiles{
    //Each subclass must implement this function
}

-(void) animateTiles{
    
    CGFloat tmpX, tmpY, timeDelay = 0.1;
    
    for(tile *t in tiles){
        tmpX = t.position.x; tmpY = (t.position.y + 480);
        [t runAction:[CCSequence actions:[CCDelayTime actionWithDuration:timeDelay],[CCMoveTo actionWithDuration:.1 position:ccp(tmpX,tmpY)], nil]];
        if(t != tileBlank){
            if(puzzleSize == 9){
                timeDelay += 0.075;
            }
            else if (puzzleSize == 16){
                timeDelay += 0.042;
            }
            else if (puzzleSize == 25){
                timeDelay += 0.027;
            }
        }
    }
    
}

#pragma mark - Movement Methods

-(void)findMoves:(tile *)t {
    //Each Subclass must implement this function
}

-(void) shuffleMove:(tile *)t{
    
    CGPoint tmpPosition;
    int tmpInt;
    
    tmpPosition = t.position;
    t.position = tileBlank.position;
    tileBlank.position = tmpPosition;
    
    [tiles replaceObjectAtIndex:tileBlank.currentPos withObject:t];
    [tiles replaceObjectAtIndex:t.currentPos withObject:tileBlank];
    
    tmpInt = t.currentPos;
    t.currentPos = tileBlank.currentPos;
    tileBlank.currentPos = tmpInt;
    
}

-(void) moveTile:(tile *)t{
    
    if(t.validMove == NONE){
        return;
    }
    
    if(paused == YES){
        return;
    }
    
    if(lockdown == YES){
        if(t.counted == YES){
            return;
        }
    }
    
    
    CGPoint tmpPoint;
    NSInteger tmpInt;
    
    //Update the Moves Counter
    numMoves++;
    movesString = [NSString stringWithFormat:@"%d",numMoves];
    [movesLabel setString:movesString];
    
    //Change relevant members
    tmpPoint = t.position;
    if(animateTileMove){
        [t runAction:[CCMoveTo actionWithDuration:0.1 position:tileBlank.position]];
    }
    else{
        t.position = tileBlank.position;
    }
    tileBlank.position = tmpPoint;
    
    //Tiles array index manipulation for checking function
    [tiles replaceObjectAtIndex:tileBlank.currentPos withObject:t];
    [tiles replaceObjectAtIndex:t.currentPos withObject:tileBlank];
    
    tmpInt = t.currentPos;
    t.currentPos = tileBlank.currentPos;
    tileBlank.currentPos = tmpInt;
    
}

#pragma mark - Input Handling Methods

-(void) registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
} 

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if(!completed){
        for(tile *moveT in tiles){
            [self findMoves:moveT];
        }
    
        CGPoint location = [self convertTouchToNodeSpace: touch];
        tile *t = [self getTileAtPoint:location];
        if(t != nil){
        if(t.validMove != NONE){
            [self moveTile:t];
            }
        }
    
        [self checkCounted];
        [self changeTextures];
        [self checkCompleted];
    }
}

-(tile*) getTileAtPoint:(CGPoint)p{
    
    CGRect touchRect = CGRectMake(p.x, p.y, 1, 1);
    
    for (tile *t in tiles) {
        if(CGRectIntersectsRect(touchRect, t.boundingBox)){
            return t;
        }
    }
    
    return nil;
}

#pragma mark - Checking Methods

-(void) checkCounted{
    //Each Subclass must implement this function
}

-(void) changeTextures{
    
    for(tile *t in tiles){
        if(t != tileBlank){
            if(t.counted == YES){
                [t changeTexCounted:t];
            }
            else{
                [t changeTexNormal:t];
            }
        }
    }
}

-(void) checkCompleted{
    int totalCounted = 0;
    
    for(tile *t in tiles){
        if(t.counted){
            totalCounted++;
        }
    }
    
    if(totalCounted == puzzleSize){
        completed = YES;
        paused = YES;
        self.isTouchEnabled = NO;
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.2],[CCCallFuncN actionWithTarget:self selector:@selector(loadCompleted)],nil]];
    }
}

#pragma mark - Timer Methods

-(void) tick:(ccTime)dt{
    if(!paused){
        totalSeconds++;
        
        if(timeSeconds<59){
            timeSeconds++;
            timeString = [NSString stringWithFormat:@"%d:%02d", timeMinutes, timeSeconds];
            [timeLabel setString:timeString];
        }
        else{
            timeMinutes++;
            timeSeconds = 0;
            timeString = [NSString stringWithFormat:@"%d:%02d", timeMinutes, timeSeconds];
            [timeLabel setString:timeString];
        }
    }
}

#pragma mark - Pause Methods

-(void) pausePressed {
    paused = YES;
    [pauseSprite setIsEnabled:NO];
    [self loadPause];
}

-(void) loadPause{
    
    CCSprite *pauseBackSprite = [CCSprite spriteWithFile:@"PauseMenuBackground.png"];
    pauseBackSprite.position = completedSprite.position =
    completedBestSpritre.position = ccp(160,winSize.height/2 - 500);
    [self addChild:pauseBackSprite];
    
    CCMenuItemImage *pauseMenuItem = [CCMenuItemImage itemWithNormalImage:@"PauseMenuNormal.png" selectedImage:@"PauseMenuSelect.png" target:self selector:@selector(menuPressed)];
    CCMenuItemImage *pauseResumeItem = [CCMenuItemImage itemWithNormalImage:@"PauseResumeNormal.png" selectedImage:@"PauseResumeSelect.png" target:self selector:@selector(resumePressed)];
    CCMenuItemImage *pauseRestartItem = [CCMenuItemImage itemWithNormalImage:@"runningRestartNormal.png" selectedImage:@"runningRestartSelect.png" target:self selector:@selector(restartPressed)];
    
    CCMenu *pauseMenu = [CCMenu menuWithItems:pauseMenuItem, pauseResumeItem, pauseRestartItem, nil];
    [self addChild:pauseMenu];
    pauseMenuItem.position = ccp(240,150);
    pauseResumeItem.position = ccp(400,150);
    pauseRestartItem.position = ccp(320,-150);
    pauseBackground = pauseBackSprite;
    tmpMenu = pauseMenu;
    
    
    id pauseScrollIn = [CCMoveTo actionWithDuration:.2 position:ccp(160,winSize.height/2 - 20)];
    id menuScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.2],
                       [CCMoveTo actionWithDuration:.1 position:ccp(-80,150)],nil];
    id resumeScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.2],
                         [CCMoveTo actionWithDuration:.1 position:ccp(80,150)],nil];
    id restartScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.3],
                         [CCMoveTo actionWithDuration:.1 position:ccp(0,-150)],nil];
    
    [pauseBackSprite runAction:pauseScrollIn];
    [pauseMenuItem runAction:menuScrollIn];
    [pauseResumeItem runAction:resumeScrollIn];
    [pauseRestartItem runAction:restartScrollIn];
    
    [topBar runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.2], [CCHide action], nil]];
    [pauseButton runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.2], [CCHide action], nil]];
    
    pauseTime = [[CCLabelTTF alloc]initWithString:timeString fontName:@"futura" fontSize:22];
    pauseTime.position = ccp(235,winSize.height/2 - 26);
    pauseTime.visible = NO;
    [self addChild:pauseTime];
    [pauseTime runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.15],[CCShow action],nil]];
    
    pauseMoves = [[CCLabelTTF alloc]initWithString:movesString fontName:@"futura" fontSize:22];
    pauseMoves.position = ccp(235,winSize.height/2 - 83);
    pauseMoves.visible = NO;
    [self addChild:pauseMoves];
    [pauseMoves runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.15],[CCShow action],nil]];
    
    //Load Best time from defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    scoreDictionaryTag = @"highScores";
    tmpHighScores = [[NSMutableDictionary alloc] initWithCapacity:8];
    tmpHighScores = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:scoreDictionaryTag]];
    
    if([tmpHighScores objectForKey:scoreTag] == nil){
        bestTimeString = [NSString stringWithFormat:@"N/A"];
    }
    else{
        tmpBestTime = [[tmpHighScores objectForKey:scoreTag] integerValue];
        bestMinutes = [self findMinutes:tmpBestTime];
        bestSeconds = [self findSeconds:tmpBestTime];
        bestTimeString = [NSString stringWithFormat:@"%d:%02d",bestMinutes, bestSeconds];
    }
    
    bestTimeLabel = [[CCLabelTTF alloc]initWithString:bestTimeString fontName:@"futura" fontSize:22];
    bestTimeLabel.position = ccp(235, winSize.height/2 + 33);
    bestTimeLabel.visible = NO;
    [self addChild:bestTimeLabel];
    [bestTimeLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.15],[CCShow action],nil]];
   
}

-(void) dismissPause{
    [topBar runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.1], [CCShow action], nil]];
    [pauseButton runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.1], [CCShow action], nil]];
    
    [pauseTime runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1],[CCHide action],nil]];
    [pauseMoves runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1],[CCHide action],nil]];
    [bestTimeLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1],[CCHide action],nil]];
    
    id menuScrollOut = [CCSequence actions:[CCMoveTo actionWithDuration:0.1 position:ccp(240,150)],nil];
    id resumeScrollOut = [CCSequence actions:[CCMoveTo actionWithDuration:0.1 position:ccp(400,150)],nil];
    id restartScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:0.1],[CCMoveTo actionWithDuration:0.2 position:ccp(320,-150)],nil];
    id pauseScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.15],[CCMoveTo actionWithDuration:0.2 position:ccp(160,-260)],nil];
    
    
    CCMenuItemImage *menuOut = [tmpMenu.children objectAtIndex:0];
    CCMenuItemImage *resumeOut = [tmpMenu.children objectAtIndex:1];
    CCSprite *tmpSprite = pauseBackground;
    
    [menuOut setIsEnabled:NO];
    [resumeOut setIsEnabled:NO];
    
    [menuOut runAction:menuScrollOut];
    [resumeOut runAction:resumeScrollOut];
    if([tmpMenu.children count] == 3){
        CCMenuItemImage *restartOut = [tmpMenu.children objectAtIndex:2];
        [restartOut setIsEnabled:NO];
        [restartOut runAction:restartScrollOut];
    }
    [tmpSprite runAction:pauseScrollOut];
    
    //Release the menu
    CCSequence *delayRelease = [CCSequence actions: [CCDelayTime actionWithDuration:0.4],
                                [CCCallFuncN actionWithTarget:tmpMenu.children selector:@selector(removeAllObjects)],nil ];
    [self runAction:delayRelease];
}

-(void) resumePressed{
    paused = NO;
    [pauseSprite setIsEnabled:YES];
    [self dismissPause];
}

-(void) menuPressed{
   //Each Subclass must be implemented by subclasses
}

#pragma mark - Completed Methods

-(void) loadCompleted{
    
    self.isTouchEnabled = YES;
    
    defaults = [NSUserDefaults standardUserDefaults];
    scoreDictionaryTag = @"highScores";
    tmpHighScores = [[NSMutableDictionary alloc] initWithCapacity:8];
    
    if([[NSMutableDictionary dictionaryWithDictionary:
         [defaults dictionaryForKey:scoreDictionaryTag]] count] == 0)
    {
        [defaults setObject:tmpHighScores forKey:scoreDictionaryTag];
        [defaults synchronize];
    }
    
    tmpHighScores = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:scoreDictionaryTag]];
    
    if([tmpHighScores objectForKey:scoreTag] == nil){
        [tmpHighScores setObject: [NSNumber numberWithInteger:totalSeconds] forKey:scoreTag];
        
        [defaults setObject:tmpHighScores forKey:scoreDictionaryTag];
        [defaults synchronize];
        if(!lockdown){
            [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:scoreTag];
        }
        [self loadCompletedNewBest];
    }
    
    else{
        tmpBestTime = [[tmpHighScores objectForKey:scoreTag] integerValue];
        if(totalSeconds < tmpBestTime){
            [tmpHighScores setObject: [NSNumber numberWithInteger:totalSeconds] forKey:scoreTag];
            [defaults setObject:tmpHighScores forKey:scoreDictionaryTag];
            [defaults synchronize];
            if(!lockdown){
                [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:scoreTag];
            }
            [self loadCompletedNewBest];
        }
        else{
            [self loadCompletedNotBest];
        }
    }
}

-(void) loadCompletedNotBest{
    CCSprite *completedNotSprite = [CCSprite spriteWithFile:@"PuzzleCompletedNotBest.png"];
    completedNotSprite.position = completedSprite.position =
    completedBestSpritre.position = ccp(160,winSize.height/2 - 500);
    [self addChild:completedNotSprite];
    
    CCMenuItemImage *pauseMenuItem = [CCMenuItemImage itemWithNormalImage:@"PauseMenuNormal.png" selectedImage:@"PauseMenuSelect.png" target:self selector:@selector(menuPressed)];
    CCMenuItemImage *pauseRestartItem = [CCMenuItemImage itemWithNormalImage:@"PauseRestartNormal.png" selectedImage:@"PauseRestartSelect.png" target:self selector:@selector(restartPressed)];
    
    CCMenu *pauseMenu = [CCMenu menuWithItems:pauseMenuItem, pauseRestartItem, nil];
    [self addChild:pauseMenu];
    pauseMenuItem.position = ccp(240,150);
    pauseRestartItem.position = ccp(400,150);
    
    pauseBackground = completedNotSprite;
    tmpMenu = pauseMenu;
    
    
    id pauseScrollIn = [CCMoveTo actionWithDuration:.2 position:ccp(160,winSize.height/2 - 20)];
    id menuScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.2],
                       [CCMoveTo actionWithDuration:.1 position:ccp(-80,150)],nil];
    id resumeScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.2],
                         [CCMoveTo actionWithDuration:.1 position:ccp(80,150)],nil];
    
    [completedNotSprite runAction:pauseScrollIn];
    [pauseMenuItem runAction:menuScrollIn];
    [pauseRestartItem runAction:resumeScrollIn];
    
    [topBar runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.2], [CCHide action], nil]];
    [pauseButton runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.2], [CCHide action], nil]];
    
    pauseTime = [[CCLabelTTF alloc]initWithString:timeString fontName:@"futura" fontSize:22];
    pauseTime.position = ccp(235,winSize.height/2 - 26);
    pauseTime.visible = NO;
    [self addChild:pauseTime];
    [pauseTime runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.15],[CCShow action],nil]];
    
    pauseMoves = [[CCLabelTTF alloc]initWithString:movesString fontName:@"futura" fontSize:22];
    pauseMoves.position = ccp(235,winSize.height/2 - 83);
    pauseMoves.visible = NO;
    [self addChild:pauseMoves];
    [pauseMoves runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.15],[CCShow action],nil]];
    
    //Load Best time from defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    scoreDictionaryTag = @"highScores";
    tmpHighScores = [[NSMutableDictionary alloc] initWithCapacity:8];
    tmpHighScores = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:scoreDictionaryTag]];
    
    if([tmpHighScores objectForKey:scoreTag] == nil){
        bestTimeString = [NSString stringWithFormat:@"N/A"];
    }
    else{
        tmpBestTime = [[tmpHighScores objectForKey:scoreTag] integerValue];
        bestMinutes = [self findMinutes:tmpBestTime];
        bestSeconds = [self findSeconds:tmpBestTime];
        bestTimeString = [NSString stringWithFormat:@"%d:%02d",bestMinutes, bestSeconds];
    }
    
    bestTimeLabel = [[CCLabelTTF alloc]initWithString:bestTimeString fontName:@"futura" fontSize:22];
    bestTimeLabel.position = ccp(235, winSize.height/2 + 33);
    bestTimeLabel.visible = NO;
    [self addChild:bestTimeLabel];
    [bestTimeLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.15],[CCShow action],nil]];

    [self achievementChecker];
}

-(void) loadCompletedNewBest{
    CCSprite *completedNewSprite = [CCSprite spriteWithFile:@"PuzzleCompletedNewBest.png"];
    completedNewSprite.position = completedSprite.position =
    completedBestSpritre.position = ccp(160,winSize.height/2 - 500);
    [self addChild:completedNewSprite];

    CCMenuItemImage *pauseMenuItem = [CCMenuItemImage itemWithNormalImage:@"PauseMenuNormal.png" selectedImage:@"PauseMenuSelect.png" target:self selector:@selector(menuPressed)];
    CCMenuItemImage *pauseRestartItem = [CCMenuItemImage itemWithNormalImage:@"PauseRestartNormal.png" selectedImage:@"PauseRestartSelect.png" target:self selector:@selector(restartPressed)];
    
    CCMenu *pauseMenu = [CCMenu menuWithItems:pauseMenuItem, pauseRestartItem, nil];
    [self addChild:pauseMenu];
    pauseMenuItem.position = ccp(240,150);
    pauseRestartItem.position = ccp(400,150);
    
    pauseBackground = completedNewSprite;
    tmpMenu = pauseMenu;
    
    
    id pauseScrollIn = [CCMoveTo actionWithDuration:.2 position:ccp(160,winSize.height/2 - 20)];
    id menuScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.2],
                       [CCMoveTo actionWithDuration:.1 position:ccp(-80,150)],nil];
    id resumeScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.2],
                         [CCMoveTo actionWithDuration:.1 position:ccp(80,150)],nil];
    
    [completedNewSprite runAction:pauseScrollIn];
    [pauseMenuItem runAction:menuScrollIn];
    [pauseRestartItem runAction:resumeScrollIn];
    
    [topBar runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.2], [CCHide action], nil]];
    [pauseButton runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.2], [CCHide action], nil]];
    
    pauseTime = [[CCLabelTTF alloc]initWithString:timeString fontName:@"futura" fontSize:22];
    pauseTime.position = ccp(235,winSize.height/2 + 33);
    pauseTime.visible = NO;
    [self addChild:pauseTime];
    [pauseTime runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.15],[CCShow action],nil]];
    
    pauseMoves = [[CCLabelTTF alloc]initWithString:movesString fontName:@"futura" fontSize:22];
    pauseMoves.position = ccp(235,winSize.height/2 - 26);
    pauseMoves.visible = NO;
    [self addChild:pauseMoves];
    [pauseMoves runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.15],[CCShow action],nil]];
    
    [self achievementChecker];
}

-(void) restartPressed{
   //Each subclass must implement this function
}

-(void) reloadCurrentScene{
 //Each subclass must implement this finction
}

-(void) achievementChecker{
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *tmpScores = [[NSMutableDictionary alloc] initWithCapacity:12];
    tmpScores= [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:@"highScores"]];
    
    NSString *nc = @"9Classic", *ncl = @"9ClassicLockdown",
    *nd = @"9Diagonal", *ndl = @"9DiagonalLockdown",
    *sc = @"16Classic", *scl = @"16ClassicLockdown",
    *sd = @"16Diagonal", *sdl = @"16DiagonalLockdown",
    *tc = @"25Classic", *tcl = @"25ClassicLockdown",
    *td = @"25Diagonal", *tdl = @"25DiagonalLockdown";
    
    if([defaults boolForKey:nc]==NO){
        if([tmpScores objectForKey:nc] != nil){
            [defaults setBool:YES forKey:nc];
        }
    }
    
    if([defaults boolForKey:ncl]==NO){
        if([tmpScores objectForKey:ncl] != nil){
            [defaults setBool:YES forKey:ncl];
        }
    }
    
    if([defaults boolForKey:nd]==NO){
        if([tmpScores objectForKey:nd] != nil){
        [defaults setBool:YES forKey:nd];
        }
    }
    
    if([defaults boolForKey:ndl]==NO){
        if([tmpScores objectForKey:ndl] != nil){
        [defaults setBool:YES forKey:ndl];
        }
    }
    
    if([defaults boolForKey:sc]==NO){
        if([tmpScores objectForKey:sc] != nil){
        [defaults setBool:YES forKey:sc];
        }
    }
    
    if([defaults boolForKey:scl]==NO){
        if([tmpScores objectForKey:scl] != nil){
            [defaults setBool:YES forKey:scl];
        }
    }
    
    if([defaults boolForKey:sd]==NO){
        if([tmpScores objectForKey:sd] != nil){
            [defaults setBool:YES forKey:sd];
        }
    }
    
    if([defaults boolForKey:sdl]==NO){
        if([tmpScores objectForKey:sdl] != nil){
            [defaults setBool:YES forKey:sdl];
        }
    }
    
    if([defaults boolForKey:tc]==NO){
        if([tmpScores objectForKey:tc] != nil){
            [defaults setBool:YES forKey:tc];
        }
    }
    
    if([defaults boolForKey:tcl]==NO){
        if([tmpScores objectForKey:tcl] != nil){
            [defaults setBool:YES forKey:tcl];
        }
    }
    
    if([defaults boolForKey:td]==NO){
        if([tmpScores objectForKey:td] != nil){
            [defaults setBool:YES forKey:td];
        }
    }
    
    if([defaults boolForKey:tdl]==NO){
        if([tmpScores objectForKey:tdl] != nil){
            [defaults setBool:YES forKey:tdl];
        }
    }
    
    [defaults synchronize];
    
    [self reportAchievements];
}

-(void) reportAchievements{
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    float locknum = 0.0, nCount = 0.0, sCount = 0.0, tCount = 0.0, mCount = 0.0;
    
    NSString *nc = @"9Classic", *ncl = @"9ClassicLockdown",
    *nd = @"9Diagonal", *ndl = @"9DiagonalLockdown",
    *sc = @"16Classic", *scl = @"16ClassicLockdown",
    *sd = @"16Diagonal", *sdl = @"16DiagonalLockdown",
    *tc = @"25Classic", *tcl = @"25ClassicLockdown",
    *td = @"25Diagonal", *tdl = @"25DiagonalLockdown";
    
    aL = [[GKAchievement alloc] initWithIdentifier:@"masterlock"];
    aL.showsCompletionBanner = YES;
    aL.percentComplete = 100.0;
    
    a9 = [[GKAchievement alloc] initWithIdentifier:@"finenine"];
    a9.showsCompletionBanner = YES;
    
    a16 = [[GKAchievement alloc] initWithIdentifier:@"sweetsixteen"];
    a16.showsCompletionBanner = YES;
    
    a25 = [[GKAchievement alloc] initWithIdentifier:@"bigtwentyfive"];
    a25.showsCompletionBanner = YES;
    
    aM = [[GKAchievement alloc] initWithIdentifier:@"masterslider"];
    aM.showsCompletionBanner = YES;
    
    
    if([defaults boolForKey:nc] == YES){
        nCount += 25.0;
        mCount += 9.0;
    }
    if([defaults boolForKey:ncl] == YES){
        nCount += 25.0;
        mCount += 9.0;
        locknum++;
    }
    if([defaults boolForKey:nd] == YES){
        nCount += 25.0;
        mCount += 9.0;
    }
    if([defaults boolForKey:ndl] == YES){
        nCount += 25.0;
        mCount += 9.0;
        locknum++;
    }
    
    if([defaults boolForKey:sc] == YES){
        sCount += 25.0;
        mCount += 9.0;
    }
    if([defaults boolForKey:scl] == YES){
        sCount += 25.0;
        mCount += 9.0;
        locknum++;
    }
    if([defaults boolForKey:sd] == YES){
        sCount += 25.0;
        mCount += 9.0;
    }
    if([defaults boolForKey:sdl] == YES){
        sCount += 25.0;
        mCount += 9.0;
        locknum++;
    }
    
    if([defaults boolForKey:tc] == YES){
        tCount += 25.0;
        mCount += 9.0;
    }
    if([defaults boolForKey:tcl] == YES){
        tCount += 25.0;
        mCount += 9.0;
        locknum++;
    }
    if([defaults boolForKey:td] == YES){
        tCount += 25.0;
        mCount += 9.0;
    }
    if([defaults boolForKey:tdl] == YES){
        tCount += 25.0;
        mCount += 9.0;
        locknum++;
    }
    
    if([defaults boolForKey:@"masterlock"] == NO){
        if(locknum > 0){
            [defaults setBool:YES forKey:@"masterlock"];
            [aL reportAchievementWithCompletionHandler:nil];
            [defaults synchronize];
        }
    }
    
    if([defaults boolForKey:@"finenine"] == NO){
        a9.percentComplete = nCount;
        [a9 reportAchievementWithCompletionHandler:nil];
        if(nCount >= 100.0){
            [defaults setBool:YES forKey:@"finenine"];
            [defaults synchronize];
        }
    }
    
    if([defaults boolForKey:@"sweetsixteen"] == NO){
        a16.percentComplete = sCount;
        [a16 reportAchievementWithCompletionHandler:nil];
        if(sCount >= 100.0){
            [defaults setBool:YES forKey:@"sweetsixteen"];
            [defaults synchronize];
        }
    }
    
    if([defaults boolForKey:@"bigtwentyfive"] == NO){
        a25.percentComplete = tCount;
        [a25 reportAchievementWithCompletionHandler:nil];
        if(tCount >= 100.0){
            [defaults setBool:YES forKey:@"bigtwentyfive"];
            [defaults synchronize];
        }
    }
    
    if([defaults boolForKey:@"masterslider"] == NO){
        aM.percentComplete = mCount;
        [aM reportAchievementWithCompletionHandler:nil];
        if(mCount >= 100.0){
            [defaults setBool:YES forKey:@"masterslider"];
            [defaults synchronize];
        }
    }
    
    [defaults synchronize];
    
}

#pragma mark - Return to Menu

-(void) returnToMenu{
    [bannerView setHidden:YES];
    [[CCDirector sharedDirector] replaceScene: [MenuLayer scene]];
}

#pragma mark - Best Time Methods

-(NSInteger) findMinutes: (NSInteger) seconds{
    NSInteger tmpMinutes;
    tmpMinutes = (seconds/60);
    return tmpMinutes;
}

-(NSInteger) findSeconds: (NSInteger) seconds{
    NSInteger tmpSeconds;
    tmpSeconds = (seconds%60);
    return tmpSeconds;
}

@end