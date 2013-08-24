//
//  MenuLayer.m
//  nine 9
//
//  Created by Mark Bellott on 6/20/12.
//  Copyright MarkBellott 2012. All rights reserved.
//

#import "MenuLayer.h"

@implementation MenuLayer{
    UIViewController *leaderViewController;
    
    CCMenu *currentMenu;
    
    CCDirector *sharedDirector;
    
    CGSize winSize;
    
    CCSprite *backgroundSprite;
    CCSprite *titleSprite;
    CCSprite *tmpSprite01, *tmpSrpite02;
    
    NSMutableArray *howPages, *bestPages;
    
    menuState currentMenuState;
    numberState currentNumber;
    modeState currentMode;
    
    bool locked, animateMode, animateMovementOn, adRemover;
    
    NSInteger howPage, bestPage, tmpBestTime, bestMinutes, bestSeconds, totalSeconds;
    
    NSUserDefaults *defaults;
    NSMutableDictionary *tmpHighScores, *tmpBoolDict, *tmpIAP;
    
    CCLabelTTF *nineDiagonalLabel, *nineDiagonalLockedLabel,
    *nineClassicLabel, *nineClassicLockedLabel,
    *sixteenDiagonalLabel, *sixteenDiagonalLockedLabel,
    *sixteenClassicLabel, *sixteenClassicLockedLabel,
    *twentyfiveClassicLabel, *twentyfiveClassicLockedLabel,
    *twentyfiveDiagonalLabel, *twentyfiveDiagonalLockedLabel;
    
    NSString *nineDiagonalString, *nineDiagonalLockedString,
    *nineClassicString, *nineClassicLockedString,
    *sixteenDiagonalString, *sixteenDiagonalLockedString,
    *sixteenClassicString, *sixteenClassicLockedString,
    *twentyfiveClassicString, *twentyfiveClassicLockedString,
    *twentyfiveDiagonalString, *twentyfiveDiagonalLockedString,
    *highScoresTag, *animateTag, *IAPTag, *AdRemoveTag;
}

@synthesize bannerView, gameCenterManager;

#pragma mark - Scene Management Methods

+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	
	MenuLayer *layer = [MenuLayer node];
    
	[scene addChild: layer];
	
	return scene;
}

-(id) init {
    if( (self=[super init])) {
        defaults = [NSUserDefaults standardUserDefaults];
        
        //Sync leaderboards the first time launched
        if([defaults boolForKey:@"FirstTimeSync"] == NO){
            if([[ABGameKitHelper sharedClass] isAuthenticated] == NO){
                [defaults setBool:NO forKey:@"FirstTimeSync"];
                [defaults synchronize];
            }
            else{
                highScoresTag = @"highScores";
                tmpHighScores = [[NSMutableDictionary alloc] initWithCapacity:12];
                tmpHighScores = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:highScoresTag]];
                
                if([tmpHighScores objectForKey:@"9Classic"] != nil){
                    totalSeconds = [[tmpHighScores objectForKey:@"9Classic"] integerValue];
                    [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"9Classic"];
                }
                
                if([tmpHighScores objectForKey:@"9Diagonal"] != nil){
                    totalSeconds = [[tmpHighScores objectForKey:@"9Diagonal"] integerValue];
                    [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"9Diagonal"];
                }
                
                if([tmpHighScores objectForKey:@"9ClassicLockdown"] != nil){
                    totalSeconds = [[tmpHighScores objectForKey:@"9ClassicLockdown"] integerValue];
                    [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"9ClassicLockdown"];
                }
                
                if([tmpHighScores objectForKey:@"9DiagonalLockdown"] != nil){
                    totalSeconds = [[tmpHighScores objectForKey:@"9DiagonalLockdown"] integerValue];
                    [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"9DiagonalLockdown"];
                    
                }
                
                if([tmpHighScores objectForKey:@"16Classic"] != nil){
                    totalSeconds = [[tmpHighScores objectForKey:@"16Classic"] integerValue];
                    [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"16Classic"];
                }
                
                if([tmpHighScores objectForKey:@"16Diagonal"] != nil){
                    totalSeconds = [[tmpHighScores objectForKey:@"16Diagonal"] integerValue];
                    [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"16Diagonal"];
                }
                
                if([tmpHighScores objectForKey:@"16ClassicLockdown"] != nil){
                    totalSeconds = [[tmpHighScores objectForKey:@"16ClassicLockdown"] integerValue];
                    [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"16ClassicLockdown"];
                }
                
                if([tmpHighScores objectForKey:@"16DiagonalLockdown"] != nil){
                    totalSeconds = [[tmpHighScores objectForKey:@"16DiagonalLockdown"] integerValue]; 
                    [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"16DiagonalLockdown"];
                }
                
                if([tmpHighScores objectForKey:@"25Classic"] != nil){
                    totalSeconds = [[tmpHighScores objectForKey:@"25Classic"] integerValue];
                    [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"25Classic"];
                }
                
                if([tmpHighScores objectForKey:@"25Diagonal"] != nil){
                    totalSeconds = [[tmpHighScores objectForKey:@"25Diagonal"] integerValue];
                    [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"25Diagonal"];
                }
                
                if([tmpHighScores objectForKey:@"25ClassicLockdown"] != nil){
                    totalSeconds = [[tmpHighScores objectForKey:@"25ClassicLockdown"] integerValue];
                    [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"25ClassicLockdown"];
                }
                
                if([tmpHighScores objectForKey:@"25DiagonalLockdown"] != nil){
                    totalSeconds = [[tmpHighScores objectForKey:@"25DiagonalLockdown"] integerValue];
                    [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"25DiagonalLockdown"];
                }
                
                
                [defaults setBool:YES forKey:@"FirstTimeSync"];
                [defaults synchronize];
            }
        }
        
        [self syncGameCenter];
        
        //IAP Methods
        if([nineIAPH sharedHelper].products == nil){
            [[nineIAPH sharedHelper] requestProducts];
        }
        
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"nine9AdRemover"]){
            adRemover = NO;
        }
        else{
            adRemover = YES;
        }
        
        //Init  the leaderboard view controller
        leaderViewController = [[UIViewController alloc] init];
        
        //Load AdBanner
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

        //Initiate variables to default values
        locked = NO;
        animateMode = YES;
        currentNumber = NINE;
        currentMode = CLASSIC;
        currentMenuState = MAIN;
        winSize = [[CCDirector sharedDirector] winSize];
        
        //Load Background Sprite
        backgroundSprite = [CCSprite spriteWithFile:@"menuBackground.png"];
        backgroundSprite.position = ccp(160,winSize.height/2);
        [self addChild:backgroundSprite];
        
        //Load Title Sprite
        titleSprite = [CCSprite spriteWithFile:@"menuTitle.png"];
        titleSprite.position = ccp(480,115+winSize.height/2);
        [self addChild:titleSprite];
        id titleScrollIn = [CCMoveTo actionWithDuration:0.25 position:ccp(160,115+winSize.height/2)];
        [titleSprite runAction: titleScrollIn];
        
        //Set Defaults
        howPage = 0;
        
        animateTag = @"animateBool";
        tmpBoolDict = [NSDictionary dictionaryWithObjectsAndKeys:
                       [NSNumber numberWithBool:YES],animateTag, nil];
        [defaults registerDefaults:tmpBoolDict];
        [defaults synchronize];
        
        animateTileMove = [[defaults objectForKey:animateTag] boolValue];
        
        //Load Main Menu
        currentMenu = [self loadMain];
        
        self.isTouchEnabled = YES;
    }
	
    return self;
}

//Sync scores with Gamecenter
//Note that every score is reported to prevent scores from being lost if achieved offline
-(void) syncGameCenter{
    if([[ABGameKitHelper sharedClass] isAuthenticated] == NO){
        return;
    }
    
    defaults = [NSUserDefaults standardUserDefaults];

    highScoresTag = @"highScores";
    tmpHighScores = [[NSMutableDictionary alloc] initWithCapacity:12];
    tmpHighScores = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:highScoresTag]];
    
    if([tmpHighScores objectForKey:@"9Classic"] != nil){
        totalSeconds = [[tmpHighScores objectForKey:@"9Classic"] integerValue];
        [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"9Classic"];
    }
    
    if([tmpHighScores objectForKey:@"9Diagonal"] != nil){
        totalSeconds = [[tmpHighScores objectForKey:@"9Diagonal"] integerValue];
        [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"9Diagonal"];
    }
    
    if([tmpHighScores objectForKey:@"9ClassicLockdown"] != nil){
        totalSeconds = [[tmpHighScores objectForKey:@"9ClassicLockdown"] integerValue];
        [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"9ClassicLockdown"];
    }
    
    if([tmpHighScores objectForKey:@"9DiagonalLockdown"] != nil){
        totalSeconds = [[tmpHighScores objectForKey:@"9DiagonalLockdown"] integerValue];
        [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"9DiagonalLockdown"];
    }
            
    if([tmpHighScores objectForKey:@"16Classic"] != nil){
        totalSeconds = [[tmpHighScores objectForKey:@"16Classic"] integerValue];
        [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"16Classic"];
    }
    
    if([tmpHighScores objectForKey:@"16Diagonal"] != nil){
        totalSeconds = [[tmpHighScores objectForKey:@"16Diagonal"] integerValue];
        [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"16Diagonal"];
    }
            
    if([tmpHighScores objectForKey:@"16ClassicLockdown"] != nil){
        totalSeconds = [[tmpHighScores objectForKey:@"16ClassicLockdown"] integerValue];
        [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"16ClassicLockdown"];
    }
    
    if([tmpHighScores objectForKey:@"16DiagonalLockdown"] != nil){
        totalSeconds = [[tmpHighScores objectForKey:@"16DiagonalLockdown"] integerValue];
        [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"16DiagonalLockdown"];
    }
            
    if([tmpHighScores objectForKey:@"25Classic"] != nil){
        totalSeconds = [[tmpHighScores objectForKey:@"25Classic"] integerValue];
        [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"25Classic"];
    }
    
    if([tmpHighScores objectForKey:@"25Diagonal"] != nil){
        totalSeconds = [[tmpHighScores objectForKey:@"25Diagonal"] integerValue];
        [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"25Diagonal"];
    }
    
    if([tmpHighScores objectForKey:@"25ClassicLockdown"] != nil){
        totalSeconds = [[tmpHighScores objectForKey:@"25ClassicLockdown"] integerValue];
        [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"25ClassicLockdown"];
    }
            
    if([tmpHighScores objectForKey:@"25DiagonalLockdown"] != nil){
        totalSeconds = [[tmpHighScores objectForKey:@"25DiagonalLockdown"] integerValue];
        [[ABGameKitHelper sharedClass] reportScore:totalSeconds forLeaderboard:@"25DiagonalLockdown"];
    }
    
    [defaults synchronize];
}

-(void) dismissTitle {
    id titleScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.4], [CCMoveTo actionWithDuration:0.25 position:ccp(480,115+winSize.height/2)], nil];
    [titleSprite runAction: titleScrollOut];
}

-(void) loadNewScene {
    
    [bannerView setHidden:YES];
    
    if(currentNumber == NINE){
        if(currentMode == DIAGONAL){
            [[CCDirector sharedDirector] replaceScene: [nineDiagonalLayer scene]];
        }
        else if (currentMode == DIAGONALLOCK){
            [[CCDirector sharedDirector] replaceScene: [nineDiagonalLockdown scene]];
        }
        else if (currentMode == CLASSIC){
            [[CCDirector sharedDirector] replaceScene: [nineClassicLayer scene]];
        }
        else if (currentMode == CLASSICLOCK){
            [[CCDirector sharedDirector] replaceScene: [nineClassicLockdown scene]];
        }
    }
    else if(currentNumber == SIXTEEN){
        if(currentMode == DIAGONAL){
            [[CCDirector sharedDirector] replaceScene: [sixteenDiagonalLayer scene]];
        }
        else if(currentMode == DIAGONALLOCK){
            [[CCDirector sharedDirector] replaceScene: [sixteenDiagonalLockdown scene]];
        }
        else if(currentMode == CLASSIC){
            [[CCDirector sharedDirector] replaceScene: [sixteenClassicLayer scene]];
        }
        else if (currentMode == CLASSICLOCK){
           [[CCDirector sharedDirector] replaceScene: [sixteenClassicLockdown scene]];
        }
    }
    else if (currentNumber == TWENTYFIVE){
        if(currentMode == DIAGONAL){
            [[CCDirector sharedDirector] replaceScene: [twentyfiveDiagonalLayer scene]];
        }
        else if(currentMode == DIAGONALLOCK){
            [[CCDirector sharedDirector] replaceScene: [twentyfiveDiagonalLockdown scene]];
        }
        if(currentMode == CLASSIC){
            [[CCDirector sharedDirector] replaceScene: [twentyfiveClassicLayer scene]];
        }
        else if (currentMode == CLASSICLOCK){
            [[CCDirector sharedDirector] replaceScene: [twentyfiveClassicLockdown scene]];
        }
        
        else{
            currentMenu = [self loadMode];
        }
    }
}


#pragma mark - iAd Methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [banner setHidden:NO];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [banner setHidden:YES];
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    [banner setHidden:YES];
}

#pragma mark - Main Menu Methods

-(CCMenu*) loadMain {
    
    currentMenuState = MAIN;
    
    //Build the menu
    CCMenuItemImage *menuPlay = [CCMenuItemImage itemWithNormalImage:@"playButtonNormal.png" selectedImage:@"playButtonSelect.png" target:self selector:@selector(playPressed)];
    
    CCMenuItemImage *menuBest = [CCMenuItemImage itemWithNormalImage:@"bestButtonNormal.png" selectedImage:@"bestButtonSelect.png" target:self selector:@selector(bestPressed)];
    
    CCMenuItemImage *menuSet = [CCMenuItemImage itemWithNormalImage:@"setButtonNormal.png" selectedImage:@"setButtonSelect.png" target:self selector:@selector(settingsPressed)];
    
    CCMenuItemImage *menuAdRemove = [CCMenuItemImage itemWithNormalImage:@"adRemoveNormal.png" selectedImage:@"adRemoveSelect.png" target:self selector:@selector(adRemovePressed)];
    
    CCMenuItemImage *menuAbout = [CCMenuItemImage itemWithNormalImage:@"aboutButtonNormal.png" selectedImage:@"aboutButtonSelect.png" target:self selector:@selector(aboutPressed)];

    if(!adRemover){
        CCMenu *mainMenu = [CCMenu menuWithItems:menuPlay, menuBest, menuSet, menuAbout, menuAdRemove, nil];
        [mainMenu alignItemsVerticallyWithPadding:10];
        mainMenu.position = ccp(160,winSize.height/2 - 60);
        [self addChild:mainMenu];
        
        //Animate the menu
        menuPlay.position = ccp(320,90);
        menuBest.position = ccp(320,35);
        menuSet.position = ccp(320,-20);
        menuAbout.position = ccp(320,-75);
        menuAdRemove.position = ccp(320,-130);
        
        id playScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.4],[CCMoveTo actionWithDuration:0.1 position:ccp(0,90)],nil];
        id bestScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.45],[CCMoveTo actionWithDuration:0.1 position:ccp(0,35)],nil];
        id setScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.55],[CCMoveTo actionWithDuration:0.1 position:ccp(0,-20)],nil];
        id aboutScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.65],[CCMoveTo actionWithDuration:0.1 position:ccp(0,-75)],nil];
        id adRemoveScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.75],[CCMoveTo actionWithDuration:0.1 position:ccp(0,-130)],nil];
        
        [menuPlay runAction:playScrollIn];
        [menuBest runAction:bestScrollIn];
        [menuSet runAction:setScrollIn];
        [menuAbout runAction:aboutScrollIn];
        [menuAdRemove runAction:adRemoveScrollIn];
        
        return mainMenu;
    }
    
    else{
        CCMenu *mainMenu = [CCMenu menuWithItems:menuPlay, menuBest, menuSet, menuAbout, nil];
        [mainMenu alignItemsVerticallyWithPadding:10];
        mainMenu.position = ccp(160,winSize.height/2 - 60);
        [self addChild:mainMenu];
        
        //Animate the menu
        menuPlay.position = ccp(320,90);
        menuBest.position = ccp(320,30);
        menuSet.position = ccp(320,-30);
        menuAbout.position = ccp(320,-90);
        
        id playScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.4],[CCMoveTo actionWithDuration:0.1 position:ccp(0,90)],nil];
        id bestScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.45],[CCMoveTo actionWithDuration:0.1 position:ccp(0,30)],nil];
        id setScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.55],[CCMoveTo actionWithDuration:0.1 position:ccp(0,-30)],nil];
        id aboutScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.65],[CCMoveTo actionWithDuration:0.1 position:ccp(0,-90)],nil];
        
        [menuPlay runAction:playScrollIn];
        [menuBest runAction:bestScrollIn];
        [menuSet runAction:setScrollIn];
        [menuAbout runAction:aboutScrollIn];
        
        return mainMenu;
    }
}

-(void) dismissMain {
    
    //Animate the menu
    id playScrollOut = [CCSequence actions:[CCMoveTo actionWithDuration:0.1 position:ccp(320,90)],nil];
    id bestScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.05],[CCMoveTo actionWithDuration:0.1 position:ccp(320,35)],nil];
    id setScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.15],[CCMoveTo actionWithDuration:0.1 position:ccp(320,-20)],nil];
    id aboutScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.25],[CCMoveTo actionWithDuration:0.1 position:ccp(320,-75)],nil];
    
    CCMenuItemImage *playOut = [currentMenu.children objectAtIndex:0];
    CCMenuItemImage *bestOut = [currentMenu.children objectAtIndex:1];
    CCMenuItemImage *setOut = [currentMenu.children objectAtIndex:2];
    CCMenuItemImage *aboutOut = [currentMenu.children objectAtIndex:3];
    
    [playOut setIsEnabled:NO];
    [bestOut setIsEnabled:NO];
    [setOut setIsEnabled: NO];
    [aboutOut setIsEnabled:NO];
    
    [playOut runAction:playScrollOut];
    [bestOut runAction:bestScrollOut];
    [setOut runAction:setScrollOut];
    [aboutOut runAction:aboutScrollOut];
    
    if(!adRemover){
        id adRemoveScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.35],[CCMoveTo actionWithDuration:0.1 position:ccp(320,-130)],nil];
        CCMenuItemImage *adRemoveOut = [currentMenu.children objectAtIndex:4];
        [adRemoveOut setIsEnabled:NO];
        [adRemoveOut runAction:adRemoveScrollOut];
    }
    
    CCSequence *delayRelease = [CCSequence actions: [CCDelayTime actionWithDuration:0.5],
                                [CCCallFuncN actionWithTarget:currentMenu.children selector:@selector(removeAllObjects)],nil ];
    [self runAction:delayRelease];
}

-(void) playPressed {
    [self dismissMain];
    currentMenu = [self loadNumber];
}

-(void) bestPressed {
    [self dismissMain];
    currentMenu = [self loadBest];
}

-(void) settingsPressed {
    [self dismissMain];
    currentMenu = [self loadSettings];
}

-(void) adRemovePressed {
    [self dismissMain];
    currentMenu = [self loadAdRemove];
}

-(void) aboutPressed {
    [self dismissMain];
    currentMenu = [self loadAbout];
}

#pragma mark - Best Methods

-(CCMenu*) loadBest{
    currentMenuState = BESTTIMES;
    bestPage = 1;
    
    bestPages = [[NSMutableArray alloc]init];
    
    CCSprite *bestSprite9 = [CCSprite spriteWithFile:@"NineBestTimes.png"];
    CCSprite *bestSprite16 = [CCSprite spriteWithFile:@"SixteenBestTimes.png"];
    CCSprite *bestSprite25 = [CCSprite spriteWithFile:@"TwentyfiveBestTimes.png"];
    
    tmpSprite01 = bestSprite9;
    tmpSrpite02 = bestSprite25;
    
    bestSprite9.position = ccp(160,winSize.height/2 - 500);
    bestSprite16.position = ccp(480,winSize.height/2 - 20);
    bestSprite25.position = ccp(800,winSize.height/2 - 20);
    
    [self addChild:bestSprite9]; [bestPages addObject:bestSprite9];
    [self addChild:bestSprite16]; [bestPages addObject:bestSprite16];
    [self addChild:bestSprite25]; [bestPages addObject:bestSprite25];
    
    CCMenuItemImage *bestBack = [CCMenuItemImage itemWithNormalImage:@"HowBackNormal.png" selectedImage:@"HowBackSelect.png" target:self selector:@selector(bestBackPressed)];
    CCMenuItemImage *bestNext = [CCMenuItemImage itemWithNormalImage:@"HowNextNormal.png" selectedImage:@"HowNextSelect.png" target:self selector:@selector(bestNextPressed)];
    CCMenuItemImage *bestGC = [CCMenuItemImage itemWithNormalImage:@"gc_leaderboards.png" selectedImage:@"gc_leaderboards_select.png" target:self selector:@selector(bestGCPressed)];
    CCMenu *bestMenu = [CCMenu menuWithItems:bestBack, bestNext, bestGC, nil];
    [self addChild:bestMenu];
    bestBack.position = ccp(240,-170);
    bestNext.position = ccp(402,-170);
    bestGC.position = ccp(321,-115);
    
    id bestScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.5],
                        [CCMoveTo actionWithDuration:.2 position:ccp(160,winSize.height/2 - 20)],nil];
    id backScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.7],
                       [CCMoveTo actionWithDuration:.1 position:ccp(-80,-170)],nil];
    id nextScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.7],
                       [CCMoveTo actionWithDuration:.1 position:ccp(80,-170)],nil];
    id gcScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.7],
                       [CCMoveTo actionWithDuration:.1 position:ccp(0,-115)],nil];
    
    [titleSprite runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.7],[CCHide action],nil]];
    [bestSprite9 runAction:bestScrollIn];
    [bestBack runAction:backScrollIn];
    [bestNext runAction:nextScrollIn];
    [bestGC runAction:gcScrollIn];
    
    [self setUpBestLabels];
    
    return bestMenu;
}

-(void) setUpBestLabels{
    
    //Setup Local UserDefaults
    highScoresTag = @"highScores";
    tmpHighScores = [[NSMutableDictionary alloc] initWithCapacity:12];
    tmpHighScores = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:highScoresTag]];
    
    /*Nine Best Labels*/
    
    //Nine Classic Best
    if([tmpHighScores objectForKey:@"9Classic"] == nil){
        nineClassicString = [NSString stringWithFormat:@"N/A"];
    }
    else{
        tmpBestTime = [[tmpHighScores objectForKey:@"9Classic"] integerValue];
        bestMinutes = [self findMinutes:tmpBestTime];
        bestSeconds = [self findSeconds:tmpBestTime];
        nineClassicString = [NSString stringWithFormat:@"%d:%02d",bestMinutes, bestSeconds];
    }
    
    nineClassicLabel = [[CCLabelTTF alloc]initWithString:nineClassicString fontName:@"futura" fontSize:16];
    nineClassicLabel.position = ccp(224,winSize.height/2 + 50);
    nineClassicLabel.visible = NO;
    [self addChild:nineClassicLabel];
    [nineClassicLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.7],[CCShow action],nil]];
    
    //Nine Diagonal Best
    if([tmpHighScores objectForKey:@"9Diagonal"] == nil){
        nineDiagonalString = [NSString stringWithFormat:@"N/A"];
    }
    else{
        tmpBestTime = [[tmpHighScores objectForKey:@"9Diagonal"] integerValue];
        bestMinutes = [self findMinutes:tmpBestTime];
        bestSeconds = [self findSeconds:tmpBestTime];
        nineDiagonalString = [NSString stringWithFormat:@"%d:%02d",bestMinutes, bestSeconds];
    }
    
    nineDiagonalLabel = [[CCLabelTTF alloc]initWithString:nineDiagonalString fontName:@"futura" fontSize:16];
    nineDiagonalLabel.position = ccp(224,winSize.height/2 + 21);
    nineDiagonalLabel.visible = NO;
    [self addChild:nineDiagonalLabel];
    [nineDiagonalLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.7],[CCShow action],nil]];
    
    //Nine Classic Lockdown Best
    if([tmpHighScores objectForKey:@"9ClassicLockdown"] == nil){
        nineClassicLockedString = [NSString stringWithFormat:@"N/A"];
    }
    else{
        tmpBestTime = [[tmpHighScores objectForKey:@"9ClassicLockdown"] integerValue];
        bestMinutes = [self findMinutes:tmpBestTime];
        bestSeconds = [self findSeconds:tmpBestTime];
        nineClassicLockedString = [NSString stringWithFormat:@"%d:%02d",bestMinutes, bestSeconds];
    }
    
    nineClassicLockedLabel = [[CCLabelTTF alloc]initWithString:nineClassicLockedString fontName:@"futura" fontSize:16];
    nineClassicLockedLabel.position = ccp(224,winSize.height/2 - 51);
    nineClassicLockedLabel.visible = NO;
    [self addChild:nineClassicLockedLabel];
    [nineClassicLockedLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.7],[CCShow action],nil]];
    
    //Nine Diagonal Lockdown Best
    if([tmpHighScores objectForKey:@"9DiagonalLockdown"] == nil){
        nineDiagonalLockedString = [NSString stringWithFormat:@"N/A"];
    }
    else{
        tmpBestTime = [[tmpHighScores objectForKey:@"9DiagonalLockdown"] integerValue];
        bestMinutes = [self findMinutes:tmpBestTime];
        bestSeconds = [self findSeconds:tmpBestTime];
        nineDiagonalLockedString = [NSString stringWithFormat:@"%d:%02d",bestMinutes, bestSeconds];
    }
    
    nineDiagonalLockedLabel = [[CCLabelTTF alloc]initWithString:nineDiagonalLockedString fontName:@"futura" fontSize:16];
    nineDiagonalLockedLabel.position = ccp(224,winSize.height/2 - 79);
    nineDiagonalLockedLabel.visible = NO;
    [self addChild:nineDiagonalLockedLabel];
    [nineDiagonalLockedLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.7],[CCShow action],nil]];
    
    /*Sixteen Best Labels*/
    
    //Sixteen Classic Best
    if([tmpHighScores objectForKey:@"16Classic"] == nil){
        sixteenClassicString = [NSString stringWithFormat:@"N/A"];
    }
    else{
        tmpBestTime = [[tmpHighScores objectForKey:@"16Classic"] integerValue];
        bestMinutes = [self findMinutes:tmpBestTime];
        bestSeconds = [self findSeconds:tmpBestTime];
        sixteenClassicString = [NSString stringWithFormat:@"%d:%02d",bestMinutes, bestSeconds];
    }
    sixteenClassicLabel = [[CCLabelTTF alloc]initWithString:sixteenClassicString fontName:@"futura" fontSize:16];
    sixteenClassicLabel.position = ccp(224,winSize.height/2 + 50);
    sixteenClassicLabel.visible = NO;
    [self addChild:sixteenClassicLabel];
    
    //Sixteen Diagonal Best
    if([tmpHighScores objectForKey:@"16Diagonal"] == nil){
        sixteenDiagonalString = [NSString stringWithFormat:@"N/A"];
    }
    else{
        tmpBestTime = [[tmpHighScores objectForKey:@"16Diagonal"] integerValue];
        bestMinutes = [self findMinutes:tmpBestTime];
        bestSeconds = [self findSeconds:tmpBestTime];
        sixteenDiagonalString = [NSString stringWithFormat:@"%d:%02d",bestMinutes, bestSeconds];
    }
    sixteenDiagonalLabel = [[CCLabelTTF alloc]initWithString:sixteenDiagonalString fontName:@"futura" fontSize:16];
    sixteenDiagonalLabel.position = ccp(224,winSize.height/2 + 21);
    sixteenDiagonalLabel.visible = NO;
    [self addChild:sixteenDiagonalLabel];
    
    //Sixteen Classic Lockdown Best
    if([tmpHighScores objectForKey:@"16ClassicLockdown"] == nil){
        sixteenClassicLockedString = [NSString stringWithFormat:@"N/A"];
    }
    else{
        tmpBestTime = [[tmpHighScores objectForKey:@"16ClassicLockdown"] integerValue];
        bestMinutes = [self findMinutes:tmpBestTime];
        bestSeconds = [self findSeconds:tmpBestTime];
        sixteenClassicLockedString = [NSString stringWithFormat:@"%d:%02d",bestMinutes, bestSeconds];
    }
    sixteenClassicLockedLabel = [[CCLabelTTF alloc]initWithString:sixteenClassicLockedString fontName:@"futura" fontSize:16];
    sixteenClassicLockedLabel.position = ccp(224,winSize.height/2 - 51);
    sixteenClassicLockedLabel.visible = NO;
    [self addChild:sixteenClassicLockedLabel];
    
    //Sixteen Diagonal Lockdown Best
    if([tmpHighScores objectForKey:@"16DiagonalLockdown"] == nil){
        sixteenDiagonalLockedString = [NSString stringWithFormat:@"N/A"];
    }
    else{
        tmpBestTime = [[tmpHighScores objectForKey:@"16DiagonalLockdown"] integerValue];
        bestMinutes = [self findMinutes:tmpBestTime];
        bestSeconds = [self findSeconds:tmpBestTime];
        sixteenDiagonalLockedString = [NSString stringWithFormat:@"%d:%02d",bestMinutes, bestSeconds];
    }
    sixteenDiagonalLockedLabel = [[CCLabelTTF alloc]initWithString:sixteenDiagonalLockedString fontName:@"futura" fontSize:16];
    sixteenDiagonalLockedLabel.position = ccp(224,winSize.height/2 - 79);
    sixteenDiagonalLockedLabel.visible = NO;
    [self addChild:sixteenDiagonalLockedLabel];

    /*Twentyfive Best Labels*/
    
    //Twentyfive Classic Best
    if([tmpHighScores objectForKey:@"25Classic"] == nil){
        twentyfiveClassicString = [NSString stringWithFormat:@"N/A"];
    }
    else{
        tmpBestTime = [[tmpHighScores objectForKey:@"25Classic"] integerValue];
        bestMinutes = [self findMinutes:tmpBestTime];
        bestSeconds = [self findSeconds:tmpBestTime];
        twentyfiveClassicString = [NSString stringWithFormat:@"%d:%02d",bestMinutes, bestSeconds];
    }
    twentyfiveClassicLabel = [[CCLabelTTF alloc]initWithString:twentyfiveClassicString fontName:@"futura" fontSize:16];
    twentyfiveClassicLabel.position = ccp(224,winSize.height/2 + 50);
    twentyfiveClassicLabel.visible = NO;
    [self addChild:twentyfiveClassicLabel];
    
    //Twentyfive Diagonal Best
    if([tmpHighScores objectForKey:@"25Diagonal"] == nil){
        twentyfiveDiagonalString = [NSString stringWithFormat:@"N/A"];
    }
    else{
        tmpBestTime = [[tmpHighScores objectForKey:@"25Diagonal"] integerValue];
        bestMinutes = [self findMinutes:tmpBestTime];
        bestSeconds = [self findSeconds:tmpBestTime];
        twentyfiveDiagonalString = [NSString stringWithFormat:@"%d:%02d",bestMinutes, bestSeconds];
    }
    twentyfiveDiagonalLabel = [[CCLabelTTF alloc]initWithString:twentyfiveDiagonalString fontName:@"futura" fontSize:16];
    twentyfiveDiagonalLabel.position = ccp(224,winSize.height/2 + 21);
    twentyfiveDiagonalLabel.visible = NO;
    [self addChild:twentyfiveDiagonalLabel];
    
    //Twentyfive Classic Lockdown Best
    if([tmpHighScores objectForKey:@"25ClassicLockdown"] == nil){
        twentyfiveClassicLockedString = [NSString stringWithFormat:@"N/A"];
    }
    else{
        tmpBestTime = [[tmpHighScores objectForKey:@"25ClassicLockdown"] integerValue];
        bestMinutes = [self findMinutes:tmpBestTime];
        bestSeconds = [self findSeconds:tmpBestTime];
        twentyfiveClassicLockedString = [NSString stringWithFormat:@"%d:%02d",bestMinutes, bestSeconds];
    }
    twentyfiveClassicLockedLabel = [[CCLabelTTF alloc]initWithString:twentyfiveClassicLockedString fontName:@"futura" fontSize:16];
    twentyfiveClassicLockedLabel.position = ccp(224,winSize.height/2 - 51);
    twentyfiveClassicLockedLabel.visible = NO;
    [self addChild:twentyfiveClassicLockedLabel];
    
    //Twentyfive Diagonal Lockdown Best
    if([tmpHighScores objectForKey:@"25DiagonalLockdown"] == nil){
        twentyfiveDiagonalLockedString = [NSString stringWithFormat:@"N/A"];
    }
    else{
        tmpBestTime = [[tmpHighScores objectForKey:@"25DiagonalLockdown"] integerValue];
        bestMinutes = [self findMinutes:tmpBestTime];
        bestSeconds = [self findSeconds:tmpBestTime];
        twentyfiveDiagonalLockedString = [NSString stringWithFormat:@"%d:%02d",bestMinutes, bestSeconds];
    }
    twentyfiveDiagonalLockedLabel = [[CCLabelTTF alloc]initWithString:twentyfiveDiagonalLockedString fontName:@"futura" fontSize:16];
    twentyfiveDiagonalLockedLabel.position = ccp(224,winSize.height/2 -79);
    twentyfiveDiagonalLockedLabel.visible = NO;
    [self addChild:twentyfiveDiagonalLockedLabel];

}

-(void) dismissBest{
    titleSprite.visible = YES;
    
    id backScrollOut = [CCSequence actions:[CCMoveTo actionWithDuration:0.1 position:ccp(240,-170)],nil];
    id nextScrollOut = [CCSequence actions:[CCMoveTo actionWithDuration:0.1 position:ccp(402,-170)],nil];
    id gcScrollOut = [CCSequence actions:[CCMoveTo actionWithDuration:0.1 position:ccp(321,-115)],nil];
    id bestScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.1],[CCMoveTo actionWithDuration:0.2 position:ccp(160,winSize.height/2 - 500)],nil];
    
    CCMenuItemImage *backOut = [currentMenu.children objectAtIndex:0];
    CCMenuItemImage *nextOut = [currentMenu.children objectAtIndex:1];
    CCMenuItemImage *gcOut = [currentMenu.children objectAtIndex:2];
    
    [backOut setIsEnabled:NO];
    [nextOut setIsEnabled:NO];
    [gcOut setIsEnabled:NO];
    
    [backOut runAction:backScrollOut];
    [nextOut runAction:nextScrollOut];
    [gcOut runAction:gcScrollOut];
    
    if(bestPage == 1){
        [tmpSprite01 runAction:bestScrollOut];
        
        [nineDiagonalLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1],[CCHide action],nil]];
        [nineDiagonalLockedLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1],[CCHide action],nil]];
        [nineClassicLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1],[CCHide action],nil]];
        [nineClassicLockedLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1],[CCHide action],nil]];
    }
    else{
        [tmpSrpite02 runAction:bestScrollOut];
        
        [twentyfiveDiagonalLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1],[CCHide action],nil]];
        [twentyfiveDiagonalLockedLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1],[CCHide action],nil]];
        [twentyfiveClassicLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1],[CCHide action],nil]];
        [twentyfiveClassicLockedLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.1],[CCHide action],nil]];
    }
    
    CCSequence *delayRelease = [CCSequence actions: [CCDelayTime actionWithDuration:0.5],
                                [CCCallFuncN actionWithTarget:currentMenu.children selector:@selector(removeAllObjects)],nil ];
    
    [self runAction:delayRelease];
}

-(void) bestBackPressed{
    CGPoint tmpPoint;
    
    if(bestPage == 1){
        [self dismissBest];
        currentMenu = [self loadMain];
    }
    else{
        bestPage--;
        [self changeBestLabels];
        for(CCSprite *s in bestPages){
            tmpPoint = s.position;
            tmpPoint.x += 320;
            [s runAction: [CCMoveTo actionWithDuration:.15 position:tmpPoint]];
        }
    }
}

-(void) bestNextPressed{
    CGPoint tmpPoint;
    
    if(bestPage == 3){
        [self dismissBest];
        currentMenu = [self loadMain];
    }
    else{
        bestPage++;
        [self changeBestLabels];
        for(CCSprite *s in bestPages){
            tmpPoint = s.position;
            tmpPoint.x -= 320;
            [s runAction: [CCMoveTo actionWithDuration:.15 position:tmpPoint]];
        }
    }

}

-(void) bestGCPressed{
    if(bestPage == 1){
        [[ABGameKitHelper sharedClass] showLeaderboard:@"9Classic"];
    }
    else if(bestPage == 2){
        [[ABGameKitHelper sharedClass] showLeaderboard:@"16Classic"];
    }
    else if(bestPage == 3){
        [[ABGameKitHelper sharedClass] showLeaderboard:@"25Classic"];
    }
}

-(void) changeBestLabels{
    
    if(bestPage == 1){
        [nineClassicLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.125],[CCShow action],nil]];
        [nineDiagonalLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.125],[CCShow action],nil]];
        [nineClassicLockedLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.125],[CCShow action],nil]];
        [nineDiagonalLockedLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.125],[CCShow action],nil]];
        
        [sixteenClassicLabel runAction:[CCHide action]];
        [sixteenDiagonalLabel runAction:[CCHide action]];
        [sixteenClassicLockedLabel runAction:[CCHide action]];
        [sixteenDiagonalLockedLabel runAction:[CCHide action]];
    }
    else if (bestPage == 2){
        [sixteenClassicLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.125],[CCShow action],nil]];
        [sixteenDiagonalLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.125],[CCShow action],nil]];
        [sixteenClassicLockedLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.125],[CCShow action],nil]];
        [sixteenDiagonalLockedLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.125],[CCShow action],nil]];
        
        [nineClassicLabel runAction:[CCHide action]];
        [nineDiagonalLabel runAction:[CCHide action]];
        [nineClassicLockedLabel runAction:[CCHide action]];;
        [nineDiagonalLockedLabel runAction:[CCHide action]];
        
        [twentyfiveClassicLabel runAction:[CCHide action]];
        [twentyfiveDiagonalLabel runAction:[CCHide action]];
        [twentyfiveClassicLockedLabel runAction:[CCHide action]];
        [twentyfiveDiagonalLockedLabel runAction:[CCHide action]];
    }
    else if (bestPage == 3){
        [twentyfiveClassicLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.125],[CCShow action],nil]];
        [twentyfiveDiagonalLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.125],[CCShow action],nil]];
        [twentyfiveClassicLockedLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.125],[CCShow action],nil]];
        [twentyfiveDiagonalLockedLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.125],[CCShow action],nil]];
        
        [sixteenClassicLabel runAction:[CCHide action]];
        [sixteenDiagonalLabel runAction:[CCHide action]];
        [sixteenClassicLockedLabel runAction:[CCHide action]];
        [sixteenDiagonalLockedLabel runAction:[CCHide action]];
    }
}

//Use Maths to find the minute:second values to display from a total seconds score
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

#pragma mark - Settings Methods

-(CCMenu*) loadSettings{
    currentMenuState = SETTINGS;
    
    CCSprite *settingsSprite = [CCSprite spriteWithFile:@"nineSettings.png"];
    settingsSprite.position = ccp(160,winSize.height/2 - 500);
    [self addChild:settingsSprite];
    tmpSprite01 = settingsSprite;
    
    //Build the menu
    CCMenuItemImage *animateOn = [CCMenuItemImage itemWithNormalImage:@"animateOnNormal.png" selectedImage:@"animateOnSelect.png" target:self selector:@selector(turnAnimationOff)];
    
    CCMenuItemImage *animateOff = [CCMenuItemImage itemWithNormalImage:@"animateOffNormal.png" selectedImage:@"animateOffSelect.png" target:self selector:@selector(turnAnimationOn)];
    
    CCMenuItemImage *resetTimes = [CCMenuItemImage itemWithNormalImage:@"resetNormal.png" selectedImage:@"resetSelect.png" target:self selector:@selector(areYouSureLoad)];
    
    CCMenuItemImage *resetConfirm = [CCMenuItemImage itemWithNormalImage:@"resetConfirmNormal.png" selectedImage:@"resetConfirmSelect.png" target:self selector:@selector(resetBestTimes)];
    
    CCMenuItemImage *settingsBack = [CCMenuItemImage itemWithNormalImage:@"backButtonNormal.png" selectedImage:@"backButtonSelect.png" target:self selector:@selector(settingsBackPressed)];
   
    CCMenu *settingsMenu = [CCMenu menuWithItems:animateOn, animateOff,
                            resetTimes, resetConfirm, settingsBack, nil];
    [self addChild:settingsMenu];
    
    animateOn.position = ccp(320,12);
    animateOff.position = ccp(320,12);
    resetTimes.position = ccp(320,-120);
    resetConfirm.position = ccp(320,-120);
    settingsBack.position = ccp(320,-190);
    
    id settingsScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.4],
                        [CCMoveTo actionWithDuration:.2 position:ccp(160,winSize.height/2 - 20)],nil];
    id onOffScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.6],
                       [CCMoveTo actionWithDuration:.1 position:ccp(0,12)],nil];
    id resetScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.7],
                        [CCMoveTo actionWithDuration:0.1 position:ccp(0,-120)],nil];
    id settingsBackScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.8],
                               [CCMoveTo actionWithDuration:0.1 position:ccp(0,-190)],nil];

    animateTileMove = [[defaults objectForKey:animateTag] boolValue];
    
    [settingsSprite runAction:settingsScrollIn];
    if(animateTileMove){
        [animateOn runAction:onOffScrollIn];
    }
    else{
        [animateOff runAction:onOffScrollIn];
    }
    [resetTimes runAction:resetScrollIn];
    [settingsBack runAction:settingsBackScrollIn];
    
    return settingsMenu;

}

-(void) dismissSettings{
    
    CCMenuItemImage *onOut = [currentMenu.children objectAtIndex:0];
    CCMenuItemImage *offOut = [currentMenu.children objectAtIndex:1];
    CCMenuItemImage *resetOut = [currentMenu.children objectAtIndex:2];
    CCMenuItemImage *confirmOut = [currentMenu.children objectAtIndex:3];
    CCMenuItemImage *backOut = [currentMenu.children objectAtIndex:4];
    
    [onOut setIsEnabled:NO];
    [offOut setIsEnabled:NO];
    [resetOut setIsEnabled:NO];
    [confirmOut setIsEnabled:NO];
    [backOut setIsEnabled:NO];
    
    id onScrollOut = [CCSequence actions:[CCMoveTo actionWithDuration:0.1 position:ccp(320,12)],nil];
    id offScrollOut = [CCSequence actions:[CCMoveTo actionWithDuration:0.1 position:ccp(320,12)],nil];
    id resetScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.1],
                         [CCMoveTo actionWithDuration:0.1 position:ccp(320,-120)],nil];
    id confirmScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.1],
                         [CCMoveTo actionWithDuration:0.1 position:ccp(320,-120)],nil];
    id backScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.2],
                        [CCMoveTo actionWithDuration:0.1 position:ccp(320,-190)],nil];
    id settingsScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.3],[CCMoveTo actionWithDuration:0.2 position:ccp(160,winSize.height/2 - 500)],nil];
    
    [onOut runAction: onScrollOut];
    [offOut runAction:offScrollOut];
    [resetOut runAction:resetScrollOut];
    [confirmOut runAction:confirmScrollOut];
    [backOut runAction: backScrollOut];
    [tmpSprite01 runAction:settingsScrollOut];
    
    CCSequence *delayRelease = [CCSequence actions: [CCDelayTime actionWithDuration:0.5],
                                [CCCallFuncN actionWithTarget:currentMenu.children selector:@selector(removeAllObjects)],nil ];
    [self runAction:delayRelease];
    
}

-(void) turnAnimationOn{
    animateTileMove = YES;
    [defaults setObject:[NSNumber numberWithBool:YES]forKey:animateTag];
    [defaults synchronize];
    
    CCMenuItemImage *onIn = [currentMenu.children objectAtIndex:0];
    CCMenuItemImage *offOut = [currentMenu.children objectAtIndex:1];
    
    id offScrollOut = [CCSequence actions:[CCMoveTo actionWithDuration:0.2 position:ccp(320,12)],nil];
    id onScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.2],
                        [CCMoveTo actionWithDuration:.2 position:ccp(0,12)],nil];
    
    [offOut runAction:offScrollOut];
    [onIn runAction:onScrollIn];

}

-(void) turnAnimationOff{
    animateTileMove = NO;
    [defaults setObject:[NSNumber numberWithBool:NO]forKey:animateTag];
    [defaults synchronize];
    
    CCMenuItemImage *onOut = [currentMenu.children objectAtIndex:0];
    CCMenuItemImage *offIn = [currentMenu.children objectAtIndex:1];
    
    id onScrollOut = [CCSequence actions:[CCMoveTo actionWithDuration:0.2 position:ccp(320,12)],nil];
    id offScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.2],
                        [CCMoveTo actionWithDuration:.2 position:ccp(0,12)],nil];
    
    [onOut runAction:onScrollOut];
    [offIn runAction:offScrollIn];
}

-(void) areYouSureLoad{
    CCMenuItemImage *resetOut = [currentMenu.children objectAtIndex:2];
    CCMenuItemImage *confirmIn = [currentMenu.children objectAtIndex:3];
    
    id resetScrollOut = [CCSequence actions:[CCMoveTo actionWithDuration:0.2 position:ccp(320,-120)],nil];
    id confirmScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.2],
                      [CCMoveTo actionWithDuration:.2 position:ccp(0,-120)],nil];
    
    [resetOut runAction:resetScrollOut];
    [confirmIn runAction:confirmScrollIn];
}

-(void) resetBestTimes{
    
    highScoresTag = @"highScores";
    tmpHighScores = [[NSMutableDictionary alloc] initWithCapacity:8];
    tmpHighScores = [NSMutableDictionary dictionaryWithDictionary:[defaults dictionaryForKey:highScoresTag]];
    
    [tmpHighScores removeAllObjects];
    
    [defaults setObject:tmpHighScores forKey:highScoresTag];
    [defaults synchronize];
    
    CCMenuItemImage *resetIn = [currentMenu.children objectAtIndex:2];
    CCMenuItemImage *confirmOut = [currentMenu.children objectAtIndex:3];
    
    id confirmScrollOut = [CCSequence actions:[CCMoveTo actionWithDuration:0.2 position:ccp(320,-120)],nil];
    id resetScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.2],
                          [CCMoveTo actionWithDuration:.2 position:ccp(0,-120)],nil];
    
    [confirmOut runAction:confirmScrollOut];
    [resetIn runAction:resetScrollIn];
}

-(void) settingsBackPressed{
    [self dismissSettings];
    currentMenu = [self loadMain];
}


#pragma mark - About Methods

-(CCMenu*) loadAbout{
    currentMenuState = ABOUT;
    
    CCSprite *aboutSprite = [CCSprite spriteWithFile:@"NineAboutPage.png"];
    aboutSprite.position = ccp(160,winSize.height/2 - 500);
    [self addChild:aboutSprite];
    tmpSprite01 = aboutSprite;
    
    CCMenuItemImage *aboutBack = [CCMenuItemImage itemWithNormalImage:@"backButtonNormal.png" selectedImage:@"backButtonSelect.png" target:self selector:@selector(aboutBackPressed)];
    CCMenu *aboutMenu = [CCMenu menuWithItems:aboutBack, nil];
    [self addChild:aboutMenu];
    aboutBack.position = ccp(320,-150);
    
    id aboutScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.4],
                        [CCMoveTo actionWithDuration:.2 position:ccp(160,winSize.height/2 - 20)],nil];
    id backScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.6],
                        [CCMoveTo actionWithDuration:.1 position:ccp(0,-150)],nil];
    
    [aboutSprite runAction:aboutScrollIn];
    [aboutBack runAction:backScrollIn];
    
    return aboutMenu;
}

-(void) dismissAbout{
    id backScrollOut = [CCSequence actions:[CCMoveTo actionWithDuration:0.1 position:ccp(320,-150)],nil];
    id aboutScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.1],[CCMoveTo actionWithDuration:0.2 position:ccp(160,winSize.height/2 - 500)],nil];
    
    CCMenuItemImage *backOut = [currentMenu.children objectAtIndex:0];
    
    [backOut setIsEnabled:NO];
    
    [backOut runAction:backScrollOut];
    [tmpSprite01 runAction:aboutScrollOut];
    
    CCSequence *delayRelease = [CCSequence actions: [CCDelayTime actionWithDuration:0.4],
                                [CCCallFuncN actionWithTarget:currentMenu.children selector:@selector(removeAllObjects)],nil ];
    [self runAction:delayRelease];    
}

-(void) aboutBackPressed{
    [self dismissAbout];
    currentMenu = [self loadMain];
}

#pragma mark - AdRemove Methods

-(CCMenu*) loadAdRemove{
    currentMenuState = ADREMOVE;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    
    CCSprite *adRemoveSprite = [CCSprite spriteWithFile:@"NineAdRemoverPage.png"];
    adRemoveSprite.position = ccp(160,winSize.height/2 - 500);
    [self addChild:adRemoveSprite];
    tmpSprite01 = adRemoveSprite;
    
    CCMenuItemImage *activate = [CCMenuItemImage itemWithNormalImage:@"activateButtonNormal.png" selectedImage:@"activateButtonSelect.png" target:self selector:@selector(activatePressed)];
    
    CCMenuItemImage *adRemoveBack = [CCMenuItemImage itemWithNormalImage:@"backButtonNormal.png" selectedImage:@"backButtonSelect.png" target:self selector:@selector(adRemoveBackPressed)];
    
    CCMenu *aboutMenu = [CCMenu menuWithItems: activate, adRemoveBack, nil];
    [self addChild:aboutMenu];
    
    activate.position = ccp(320, -75);
    adRemoveBack.position = ccp(320,-150);
    
    id adScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.4],
                        [CCMoveTo actionWithDuration:.2 position:ccp(160,winSize.height/2 - 20)],nil];
    id activateScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.6],
                       [CCMoveTo actionWithDuration:.1 position:ccp(0,-75)],nil];
    id backScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.7],
                       [CCMoveTo actionWithDuration:.1 position:ccp(0,-150)],nil];
    
    [adRemoveSprite runAction:adScrollIn];
    [activate runAction:activateScrollIn];
    [adRemoveBack runAction:backScrollIn];
    
    return aboutMenu;
}

-(void) dismissAdRemove{
    id activateScrollOut = [CCSequence actions:[CCMoveTo actionWithDuration:0.1 position:ccp(320,-75)],nil];
    id backScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.1], [CCMoveTo actionWithDuration:0.1 position:ccp(320,-150)],nil];
    id aboutScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.2],[CCMoveTo actionWithDuration:0.2 position:ccp(160,winSize.height/2 - 500)],nil];
    
    CCMenuItemImage *activateOut = [currentMenu.children objectAtIndex:0];
    CCMenuItemImage *backOut = [currentMenu.children objectAtIndex:1];
    
    [activateOut setIsEnabled:NO];
    [backOut setIsEnabled:NO];
    
    [activateOut runAction: activateScrollOut];
    [backOut runAction:backScrollOut];
    [tmpSprite01 runAction:aboutScrollOut];
    
    CCSequence *delayRelease = [CCSequence actions: [CCDelayTime actionWithDuration:0.4],
                                [CCCallFuncN actionWithTarget:currentMenu.children selector:@selector(removeAllObjects)],nil ];
    [self runAction:delayRelease];
}

-(void) activatePressed{
    SKProduct *product = [[nineIAPH sharedHelper].products objectAtIndex:0];
    
    CCMenuItemImage *activateButton = [currentMenu.children objectAtIndex:0];
    CCMenuItemImage *backButton = [currentMenu.children objectAtIndex:1];
    
    [activateButton setIsEnabled:NO];
    [backButton setIsEnabled:NO];
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.5],
                     [CCCallFuncN actionWithTarget:self selector:@selector(enableButtons)], nil]];
    
    [[nineIAPH sharedHelper] buyProductIdentifier:product.productIdentifier];

}

-(void) enableButtons{
    CCMenuItemImage *activateButton = [currentMenu.children objectAtIndex:0];
    CCMenuItemImage *backButton = [currentMenu.children objectAtIndex:1];
    
    [activateButton setIsEnabled:YES];
    [backButton setIsEnabled:YES];
}
     
- (void) productPurchased:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    NSString *productIdentifier = (NSString *) notification.object;
    NSLog(@"Purchased: %@", productIdentifier);
    
    [self savePurchase];
        
}

-(void) savePurchase{
    AdRemoveTag = @"nine9AdRemover";
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AdRemoveTag];
    [bannerView setHidden:YES];
    
    [[CCDirector sharedDirector] replaceScene: [MenuLayer scene]];

}

-(void) productPurchaseFailed:(NSNotification *)notification {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;
    if (transaction.error.code != SKErrorPaymentCancelled) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                         message:transaction.error.localizedDescription
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil];
        
        [alert show];
    }
    
}

-(void) adRemoveBackPressed{
    [self dismissAdRemove];
    currentMenu = [self loadMain];
}

#pragma mark - Number Menu Methods

-(CCMenu*) loadNumber {
    
    currentMenuState = CHOOSENUMBER;
    
    //Build the menu
    CCMenuItemImage *menuNine = [CCMenuItemImage itemWithNormalImage:@"nineButtonNormal.png" selectedImage:@"nineButtonSelect.png" target:self selector:@selector(ninePressed)];
    
    CCMenuItemImage *menuSixteen = [CCMenuItemImage itemWithNormalImage:@"sixteenButtonNormal.png" selectedImage:@"sixteenButtonSelect.png" target:self selector:@selector(sixteenPressed)];
    
    CCMenuItemImage *menuTwentyfive = [CCMenuItemImage itemWithNormalImage:@"twentyfiveButtonNormal.png" selectedImage:@"twentyfiveButtonSelect.png" target:self selector:@selector(twentyfivePressed)];
    
    CCMenuItemImage *menuHow = [CCMenuItemImage itemWithNormalImage:@"howButtonNormal.png" selectedImage:@"howButtonSelect.png" target:self selector:@selector(howPressed)];
    
    CCMenuItemImage *menuNumBack = [CCMenuItemImage itemWithNormalImage:@"backButtonNormal.png" selectedImage:@"backButtonSelect.png" target:self selector:@selector(numBackPressed)];
    
    CCMenu *numberMenu = [CCMenu menuWithItems:menuNine, menuSixteen, menuTwentyfive, menuHow, menuNumBack, nil];
    [numberMenu alignItemsVerticallyWithPadding:10];
    numberMenu.position = ccp(160,winSize.height/2 - 60);
    [self addChild:numberMenu];
    
    //Animate the menu
    menuNine.position = ccp(320,90);
    menuSixteen.position = ccp(320,35);
    menuTwentyfive.position = ccp(320,-20);
    menuHow.position = ccp(320,-75);
    menuNumBack.position = ccp(320,-130);
    
    id nineScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.4],[CCMoveTo actionWithDuration:0.1 position:ccp(0,90)],nil];
    id sixteenScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.45],[CCMoveTo actionWithDuration:0.1 position:ccp(0,35)],nil];
    id twentyfiveScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.55],[CCMoveTo actionWithDuration:0.1 position:ccp(0,-20)],nil];
    id howScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.65],[CCMoveTo actionWithDuration:0.1 position:ccp(0,-75)],nil];
    id numBackScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.75],[CCMoveTo actionWithDuration:0.1 position:ccp(0,-130)],nil];
    
    [menuNine runAction:nineScrollIn]; 
    [menuSixteen runAction:sixteenScrollIn]; 
    [menuTwentyfive runAction:twentyfiveScrollIn];
    [menuHow runAction:howScrollIn];
    [menuNumBack runAction:numBackScrollIn];
    
    return numberMenu;
}

-(void) dismissNumber {
    
    //Animate the menu
    id nineScrollOut = [CCSequence actions:[CCMoveTo actionWithDuration:0.1 position:ccp(320,90)],nil];
    id sixteenScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.05],[CCMoveTo actionWithDuration:0.1 position:ccp(320,35)],nil];
    id twentyfiveScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.15],[CCMoveTo actionWithDuration:0.1 position:ccp(320,-20)],nil];
    id howScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.25],[CCMoveTo actionWithDuration:0.1 position:ccp(320,-75)],nil];
    id numBackScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.35],[CCMoveTo actionWithDuration:0.1 position:ccp(320,-130)],nil];
    
    CCMenuItemImage *nineOut = [currentMenu.children objectAtIndex:0];
    CCMenuItemImage *sixteenOut = [currentMenu.children objectAtIndex:1];
    CCMenuItemImage *twentyfiveOut = [currentMenu.children objectAtIndex:2];
    CCMenuItemImage *howOut = [currentMenu.children objectAtIndex:3];
    CCMenuItemImage *numBackOut = [currentMenu.children objectAtIndex:4];
    
    [nineOut setIsEnabled:NO];
    [sixteenOut setIsEnabled:NO];
    [twentyfiveOut setIsEnabled:NO];
    [howOut setIsEnabled:NO];
    [numBackOut setIsEnabled:NO];
    
    [nineOut runAction:nineScrollOut];
    [sixteenOut runAction:sixteenScrollOut];
    [twentyfiveOut runAction:twentyfiveScrollOut];
    [howOut runAction:howScrollOut];
    [numBackOut runAction:numBackScrollOut];
    
    CCSequence *delayRelease = [CCSequence actions: [CCDelayTime actionWithDuration:0.5],
                                [CCCallFuncN actionWithTarget:currentMenu.children selector:@selector(removeAllObjects)],nil ];
    [self runAction:delayRelease];
}

-(void) ninePressed {
    currentNumber = NINE;
    
    [self dismissNumber];
    currentMenu = [self loadMode];
}

-(void) sixteenPressed {
    currentNumber = SIXTEEN;
    
    [self dismissNumber];
    currentMenu = [self loadMode];
}

-(void) twentyfivePressed {
    currentNumber = TWENTYFIVE;
    
    [self dismissNumber];
    currentMenu = [self loadMode];
}

-(void) howPressed {
    [self dismissNumber];
    currentMenu = [self loadHowTo];
}

-(void) numBackPressed {
    [self dismissNumber];
    currentMenu = [self loadMain];
}

#pragma mark - How To Play Methods

-(CCMenu*) loadHowTo{
    currentMenuState = HOWTO;
    howPage = 1;
    
    howPages = [[NSMutableArray alloc]init];
    
    CCSprite *howBackgroundSprite01 = [CCSprite spriteWithFile:@"NineHowPage01.png"];
    CCSprite *howBackgroundSprite02 = [CCSprite spriteWithFile:@"NineHowPage02.png"];
    CCSprite *howBackgroundSprite03 = [CCSprite spriteWithFile:@"NineHowPage03.png"];
    CCSprite *howBackgroundSprite04 = [CCSprite spriteWithFile:@"NineHowPage04.png"];
    
    howBackgroundSprite01.position = ccp(160,winSize.height/2 - 500);
    howBackgroundSprite02.position = ccp(480,winSize.height/2 - 20);
    howBackgroundSprite03.position = ccp(800,winSize.height/2 - 20);
    howBackgroundSprite04.position = ccp(1120,winSize.height/2 - 20);
    
    [self addChild:howBackgroundSprite01]; [howPages addObject:howBackgroundSprite01];
    [self addChild:howBackgroundSprite02]; [howPages addObject:howBackgroundSprite02];
    [self addChild:howBackgroundSprite03]; [howPages addObject:howBackgroundSprite03];
    [self addChild:howBackgroundSprite04]; [howPages addObject:howBackgroundSprite04];
    
    tmpSprite01 = howBackgroundSprite01;
    tmpSrpite02 = howBackgroundSprite04;
    
    CCMenuItemImage *howToBack = [CCMenuItemImage itemWithNormalImage:@"HowBackNormal.png" selectedImage:@"HowBackSelect.png" target:self selector:@selector(howBackPressed)];
    CCMenuItemImage *howToNext = [CCMenuItemImage itemWithNormalImage:@"HowNextNormal.png" selectedImage:@"HowNextSelect.png" target:self selector:@selector(howNextPressed)];
    
    CCMenu *howToMenu = [CCMenu menuWithItems:howToBack, howToNext, nil];
    [self addChild:howToMenu];
    howToBack.position = ccp(240,-170);
    howToNext.position = ccp(402,-170);
    
    id howScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.5],
                        [CCMoveTo actionWithDuration:.2 position:ccp(160,winSize.height/2 - 20)],nil];
    id backScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.7],
                       [CCMoveTo actionWithDuration:.1 position:ccp(-80,-170)],nil];
    id nextScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.7],
                       [CCMoveTo actionWithDuration:.1 position:ccp(80,-170)],nil];
    
    [titleSprite runAction:[CCSequence actions:[CCDelayTime actionWithDuration:.6],[CCHide action],nil]];
    [howBackgroundSprite01 runAction:howScrollIn];
    [howToBack runAction:backScrollIn];
    [howToNext runAction:nextScrollIn];
    
    
    return howToMenu;
}

-(void) dismissHowTo{
    titleSprite.visible = YES;
    
    id backScrollOut = [CCSequence actions:[CCMoveTo actionWithDuration:0.1 position:ccp(240,-170)],nil];
    id nextScrollOut = [CCSequence actions:[CCMoveTo actionWithDuration:0.1 position:ccp(402,-170)],nil];
    id howScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.1],[CCMoveTo actionWithDuration:0.2 position:ccp(160,winSize.height/2 - 500)],nil];
    
    CCMenuItemImage *backOut = [currentMenu.children objectAtIndex:0];
    CCMenuItemImage *nextOut = [currentMenu.children objectAtIndex:1];
    
    [backOut setIsEnabled:NO];
    [nextOut setIsEnabled:NO];
    
    [backOut runAction:backScrollOut];
    [nextOut runAction:nextScrollOut];
    
    if(howPage == 1){
        [tmpSprite01 runAction:howScrollOut];
    }
    else{
        [tmpSrpite02 runAction:howScrollOut];
    }
    
    CCSequence *delayRelease = [CCSequence actions: [CCDelayTime actionWithDuration:0.4],
                                [CCCallFuncN actionWithTarget:currentMenu.children selector:@selector(removeAllObjects)],nil ];
    [self runAction:delayRelease];
}

-(void) howNextPressed{
    CGPoint tmpPoint;
    
    if(howPage == 4){
        [self dismissHowTo];
        currentMenu = [self loadNumber];
    }
    else{
        howPage++;
        for(CCSprite *s in howPages){
            tmpPoint = s.position;
            tmpPoint.x -= 320;
            [s runAction: [CCMoveTo actionWithDuration:.15 position:tmpPoint]];
        }
    }

}

-(void) howBackPressed{
    CGPoint tmpPoint;
    
    if(howPage == 1){
        [self dismissHowTo];
        currentMenu = [self loadNumber];
    }
    else{
        howPage--;
        for(CCSprite *s in howPages){
            tmpPoint = s.position;
            tmpPoint.x += 320;
            [s runAction: [CCMoveTo actionWithDuration:.15 position:tmpPoint]];
        }
    }
}


#pragma mark - Mode Menu Methods

-(CCMenu*) loadMode {
    
    currentMenuState = CHOOSEMODE;
    
    //Build the menu
    CCMenuItemImage *menuDiagonal = [CCMenuItemImage itemWithNormalImage:@"diagonalButtonNormal.png" selectedImage:@"diagonalButtonSelect.png" target:self selector:@selector(diagonalPressed)];
    
    CCMenuItemImage *menuClassic = [CCMenuItemImage itemWithNormalImage:@"classicButtonNormal.png" selectedImage:@"classicButtonSelect.png" target:self selector:@selector(classicPressed)];
    
    CCMenuItemImage *menuLockdown = [CCMenuItemImage itemWithNormalImage:@"lockButtonNormal.png" selectedImage:@"lockButtonSelect.png" target:self selector:@selector(lockPressed)];
    
    CCMenuItemImage *menuModBack = [CCMenuItemImage itemWithNormalImage:@"backButtonNormal.png" selectedImage:@"backButtonSelect.png" target:self selector:@selector(modBackPressed)];
    
    CCMenu *modeMenu = [CCMenu menuWithItems: menuDiagonal, menuClassic, menuLockdown, menuModBack, nil];
    [modeMenu alignItemsVerticallyWithPadding:10];
    modeMenu.position = ccp(160,winSize.height/2 - 60);
    [self addChild:modeMenu];
    
    //Animate the menu
    if(animateMode){
        menuClassic.position = ccp(320,90);
        menuDiagonal.position = ccp(320,30);
        menuLockdown.position = ccp(320,-30);
        menuModBack.position = ccp(320,-90);
    
        id classicScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.5],[CCMoveTo  actionWithDuration:0.1 position:ccp(0,90)],nil];
        id diagonalScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.55],[CCMoveTo actionWithDuration:0.1 position:ccp(0,30)],nil];
        id lockScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.65],[CCMoveTo actionWithDuration:0.1 position:ccp(0,-30)],nil];
        id modBackScrollIn = [CCSequence actions:[CCDelayTime actionWithDuration:.75],[CCMoveTo actionWithDuration:0.1 position:ccp(0,-90)],nil];
    
        [menuClassic runAction:classicScrollIn];
        [menuDiagonal runAction:diagonalScrollIn];
        [menuLockdown runAction:lockScrollIn];
        [menuModBack runAction:modBackScrollIn];
    }
    else{
        menuClassic.position = ccp(0,90);
        menuDiagonal.position = ccp(0,30);
        menuLockdown.position = ccp(0,-30);
        menuModBack.position = ccp(0,-90);
    }
   
    return modeMenu;
}

-(void) dismissMode {
    
    //Animate the menu
    if(animateMode){
        id classicScrollOut = [CCSequence actions:[CCMoveTo actionWithDuration:0.1 position:ccp(320,90)],nil];
        id diagonalScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.05],[CCMoveTo actionWithDuration:0.1 position:ccp(320,30)],nil];
        id lockScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.15],[CCMoveTo actionWithDuration:0.1 position:ccp(320,-30)],nil];
        id modBackScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.25],[CCMoveTo actionWithDuration:0.1 position:ccp(320,-90)],nil];
    
        CCMenuItemImage *diagonalOut = [currentMenu.children objectAtIndex:0];
        CCMenuItemImage *classicOut = [currentMenu.children objectAtIndex:1];
        CCMenuItemImage *lockOut = [currentMenu.children objectAtIndex:2];
        CCMenuItemImage *modBackOut = [currentMenu.children objectAtIndex:3];
        
        [diagonalOut setIsEnabled:NO];
        [classicOut setIsEnabled:NO];
        [lockOut setIsEnabled:NO];
        [modBackOut setIsEnabled:NO];
        
        [diagonalOut runAction:diagonalScrollOut];
        [classicOut runAction:classicScrollOut];
        [lockOut runAction:lockScrollOut];
        [modBackOut runAction:modBackScrollOut];
    
        CCSequence *delayRelease = [CCSequence actions: [CCDelayTime actionWithDuration:0.4],
                                [CCCallFuncN actionWithTarget:currentMenu.children selector:@selector(removeAllObjects)], nil];
        [self runAction:delayRelease];
    }
    
    else{
        
        CCSequence *delayRelease = [CCSequence actions: [CCDelayTime actionWithDuration:0.01],
                                    [CCCallFuncN actionWithTarget:currentMenu.children selector:@selector(removeAllObjects)], nil];
        [self runAction:delayRelease];

    }
}

-(void) diagonalPressed {
    
    currentMode = DIAGONAL;
    animateMode = YES;
    [self dismissMode];
    [self dismissTitle];
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.75], [CCCallFuncN actionWithTarget:self selector:@selector(loadNewScene)], nil]];
    
}

-(void) classicPressed {
    
    currentMode = CLASSIC;
    animateMode = YES;
    [self dismissMode];
    [self dismissTitle];
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.75], [CCCallFuncN actionWithTarget:self selector:@selector(loadNewScene)], nil]];
}

-(void) lockPressed {
    locked = YES;
    animateMode = NO;
    [self dismissMode];
    currentMenu = [self loadModeLock];
}

-(void) modBackPressed {
    locked = NO;
    animateMode = YES;
    [self dismissMode];
    currentMenu = [self loadNumber];
}

#pragma mark - Lockdown Mode Methods

-(CCMenu*) loadModeLock{
    
    currentMenuState = CHOOSEMODELOCK;
    
    //Build the menu
    CCMenuItemImage *menuLockDiagonal = [CCMenuItemImage itemWithNormalImage:@"diagonalButtonLockNormal.png" selectedImage:@"diagonalButtonLockSelect.png" target:self selector:@selector(diagonalLockPressed)];
    
    CCMenuItemImage *menuLockClassic = [CCMenuItemImage itemWithNormalImage:@"classicButtonLockNormal.png" selectedImage:@"classicButtonLockSelect.png" target:self selector:@selector(classicLockPressed)];
    
    CCMenuItemImage *menuLockLockdown = [CCMenuItemImage itemWithNormalImage:@"unlockButtonNormal.png" selectedImage:@"unlockButtonSelect.png" target:self selector:@selector(unlockPressed)];
    
    CCMenuItemImage *menuLockBack = [CCMenuItemImage itemWithNormalImage:@"backButtonLockNormal.png" selectedImage:@"backButtonLockSelect.png" target:self selector:@selector(lockModBackPressed)];
    
    CCMenu *lockModeMenu = [CCMenu menuWithItems:menuLockDiagonal, menuLockClassic, menuLockLockdown, menuLockBack, nil];
    [lockModeMenu alignItemsVerticallyWithPadding:10];
    lockModeMenu.position = ccp(160,winSize.height/2 - 60);
    [self addChild:lockModeMenu];
    
    menuLockClassic.position = ccp(0,90);
    menuLockDiagonal.position = ccp(0,30);
    menuLockLockdown.position = ccp(0,-30);
    menuLockBack.position = ccp(0,-90);
    
    return lockModeMenu;
}

-(void) dismissModeLock {
    
    //Animate the menu
    if(animateMode){
        id classicScrollOut = [CCSequence actions:[CCMoveTo actionWithDuration:0.1 position:ccp(320,90)],nil];
        id diagonalScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.05],[CCMoveTo actionWithDuration:0.1 position:ccp(320,30)],nil];
        id lockScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.15],[CCMoveTo actionWithDuration:0.1 position:ccp(320,-30)],nil];
        id modBackScrollOut = [CCSequence actions:[CCDelayTime actionWithDuration:.25],[CCMoveTo actionWithDuration:0.1 position:ccp(320,-90)],nil];
    
        CCMenuItemImage *diagonalOut = [currentMenu.children objectAtIndex:0];
        CCMenuItemImage *classicOut = [currentMenu.children objectAtIndex:1];
        CCMenuItemImage *lockOut = [currentMenu.children objectAtIndex:2];
        CCMenuItemImage *modBackOut = [currentMenu.children objectAtIndex:3];
        
        [diagonalOut setIsEnabled:NO];
        [classicOut setIsEnabled:NO];
        [lockOut setIsEnabled:NO];
        [modBackOut setIsEnabled:NO];
    
        [diagonalOut runAction:diagonalScrollOut];
        [classicOut runAction:classicScrollOut];
        [lockOut runAction:lockScrollOut];
        [modBackOut runAction:modBackScrollOut];
    
        CCSequence *delayRelease = [CCSequence actions: [CCDelayTime actionWithDuration:0.4],
                                [CCCallFuncN actionWithTarget:currentMenu.children selector:@selector(removeAllObjects)], nil];
        [self runAction:delayRelease];
    }
    else{
        CCSequence *delayRelease = [CCSequence actions: [CCDelayTime actionWithDuration:0.01],
                                    [CCCallFuncN actionWithTarget:currentMenu.children selector:@selector(removeAllObjects)], nil];
        [self runAction:delayRelease];
    }
}

-(void) diagonalLockPressed {
    
    currentMode = DIAGONALLOCK;
    animateMode = YES;
    [self dismissModeLock];
    [self dismissTitle];
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.75], [CCCallFuncN actionWithTarget:self selector:@selector(loadNewScene)], nil]];
    
}

-(void) classicLockPressed {
    
    currentMode = CLASSICLOCK;
    animateMode = YES;
    [self dismissModeLock];
    [self dismissTitle];
    
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.75], [CCCallFuncN actionWithTarget:self selector:@selector(loadNewScene)], nil]];
    
}

-(void) unlockPressed {
    locked = NO;
    animateMode = NO;
    [self dismissModeLock];
    currentMenu = [self loadMode];
}

-(void) lockModBackPressed {
    locked = NO;
    animateMode = YES;
    [self dismissModeLock];
    currentMenu = [self loadNumber];
}

@end
