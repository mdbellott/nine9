//
//  nineClassicLayer.m
//  nine 9
//
//  Created by Mark Bellott on 7/1/12.
//  Copyright 2012 MarkBellott. All rights reserved.
//

#import "nineClassicLayer.h"


@implementation nineClassicLayer

+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	
	nineClassicLayer *layer = [nineClassicLayer node];
    
	[scene addChild: layer];
	
	return scene;
}

#pragma mark Init Method

-(id) init {
    if( (self=[super init])) {
        
        //Initiate winSize
        winSize = [[CCDirector sharedDirector] winSize];
        
        //Set Puzzle Size
        puzzleSize = 9;
        
        //Set scoreTag
        scoreTag = @"9Classic";
        
        //Set up Initial Position Constants (Off Screen)
        ipos900 = ccp(62,winSize.height/2 - 382); ipos901 = ccp(160,winSize.height/2 - 382);
        ipos902 = ccp(258,winSize.height/2 - 382); ipos903 = ccp(62,winSize.height/2 - 512);
        ipos904 = ccp(160,winSize.height/2 - 512); ipos905 = ccp(258,winSize.height/2 - 512);
        ipos906 = ccp(62,winSize.height/2 - 642); ipos907 = ccp(160,winSize.height/2 - 642);
        ipos908 = ccp(258,winSize.height/2 - 642);
        
        //Set up Textures
        t901no = [[CCTextureCache sharedTextureCache] addImage: @"tile901.png"];
        t902no = [[CCTextureCache sharedTextureCache] addImage: @"tile902.png"];
        t903no = [[CCTextureCache sharedTextureCache] addImage: @"tile903.png"];
        t904no = [[CCTextureCache sharedTextureCache] addImage: @"tile904.png"];
        t905no = [[CCTextureCache sharedTextureCache] addImage: @"tile905.png"];
        t906no = [[CCTextureCache sharedTextureCache] addImage: @"tile906.png"];
        t907no = [[CCTextureCache sharedTextureCache] addImage: @"tile907.png"];
        t908no = [[CCTextureCache sharedTextureCache] addImage: @"tile908.png"];
        t901yes = [[CCTextureCache sharedTextureCache] addImage:@"tile901Counted.png"];
        t902yes = [[CCTextureCache sharedTextureCache] addImage:@"tile902Counted.png"];
        t903yes = [[CCTextureCache sharedTextureCache] addImage:@"tile903Counted.png"];
        t904yes = [[CCTextureCache sharedTextureCache] addImage:@"tile904Counted.png"];
        t905yes = [[CCTextureCache sharedTextureCache] addImage:@"tile905Counted.png"];
        t906yes = [[CCTextureCache sharedTextureCache] addImage:@"tile906Counted.png"];
        t907yes = [[CCTextureCache sharedTextureCache] addImage:@"tile907Counted.png"];
        t908yes = [[CCTextureCache sharedTextureCache] addImage:@"tile908Counted.png"];
        
        //Allocate space for tiles array
        tiles = [[NSMutableArray alloc] init];
        
        //Create Default tileRect
        tileRect = CGRectMake(0, 0, 98, 130);
        
        //Maintain Background
        backgroundSprite = [tile spriteWithFile:@"menuBackground.png"];
        backgroundSprite.position = ccp(160,winSize.height/2);
        [self addChild:backgroundSprite];
        
        //Set Up and Animate Top Bar and Pause Button
        topBar = [tile spriteWithFile:@"playTopBar.png"];
        topBar.position = ccp(480, winSize.height/2 + 176);
        [self addChild:topBar];
        
        pauseSprite = [CCMenuItemImage itemWithNormalImage:@"playPauseNormal.png" selectedImage:@"playPauseSelect.png" target:self selector:@selector(pausePressed)];
        pauseButton = [CCMenu menuWithItems:pauseSprite, nil];
        pauseButton.position = ccp(700,winSize.height/2 + 176.5);
        [self addChild:pauseButton];
        
        id barScrollIn = [CCMoveTo actionWithDuration:0.15 position:ccp(160,winSize.height/2 + 176)];
        id pauseScrollIn =[CCSequence actions:[CCDelayTime actionWithDuration:.1],
                           [CCMoveTo actionWithDuration:0.15 position:ccp(288.5,winSize.height/2 + 176.5)], nil];
        
        [topBar runAction: barScrollIn];
        [pauseButton runAction: pauseScrollIn];
        
        //Load Tiles and Initiate Puzzle
        [self loadTiles];
        [self shuffleTiles];
        [self animateTiles];
        [self loadAdBanner];
        
        //Timer Label
        timeMinutes = timeSeconds = totalSeconds = 0;
        timeString = [NSString stringWithFormat:@"%d:%02d", timeMinutes, timeSeconds];
        timeLabel = [[CCLabelTTF alloc]initWithString:timeString fontName:@"futura" fontSize:19];
        timeLabel.position = ccp(90,winSize.height/2 + 176);
        timeLabel.visible = NO;
        [self addChild:timeLabel];
        [timeLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.15],[CCShow action],nil]];
        
        //Moves Label
        numMoves = 0;
        movesString = [NSString stringWithFormat:@"%d",numMoves];
        movesLabel = [[CCLabelTTF alloc]initWithString:movesString fontName:@"futura" fontSize:19];
        movesLabel.position = ccp(215,winSize.height/2 + 176);
        movesLabel.visible = NO;
        [self addChild:movesLabel];
        [movesLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.15],[CCShow action],nil]];
        
        //Set up Timer
        [self schedule:@selector(tick:) interval:1];
        
        //Initiate boolean variable
        completed = NO;
        paused = NO;
        lockdown = NO;
        
        self.isTouchEnabled = YES;
    }
	
    return self;
}

#pragma mark Puzzle Init Methods

-(void) loadTiles {
    
    [tiles removeAllObjects];
    
    tile01 = [tile spriteWithTexture:t901no rect:tileRect];
    [tile01 setTextures:t901no :t901yes];
    tile01.position = ipos900;
    tile01.value = 1;
    tile01.originalPos = 0; tile01.currentPos = 0;
    [self addChild: tile01];
    [tiles insertObject:tile01 atIndex:0];
    
    tile02 = [tile spriteWithTexture:t902no rect:tileRect];
    [tile02 setTextures:t902no :t902yes];
    tile02.position = ipos901;
    tile02.value = 2;
    tile02.originalPos = 1; tile02.currentPos = 1;
    [self addChild: tile02];
    [tiles insertObject:tile02 atIndex:1];
    
    tile03 = [tile spriteWithTexture:t903no rect:tileRect];
    [tile03 setTextures:t903no :t903yes];
    tile03.position = ipos902;
    tile03.value = 3;
    tile03.originalPos = 2; tile03.currentPos = 2;
    [self addChild: tile03];
    [tiles insertObject:tile03 atIndex:2];
    
    tile04 = [tile spriteWithTexture:t904no rect:tileRect];
    [tile04 setTextures:t904no :t904yes];
    tile04.position = ipos903;
    tile04.value = 4;
    tile04.originalPos = 3; tile04.currentPos = 3;
    [self addChild: tile04];
    [tiles insertObject:tile04 atIndex:3];
    
    tile05 = [tile spriteWithTexture:t905no rect:tileRect];
    [tile05 setTextures:t905no :t905yes];
    tile05.position = ipos904;
    tile05.value = 5;
    tile05.originalPos = 4; tile05.currentPos = 4;
    [self addChild: tile05];
    [tiles insertObject:tile05 atIndex:4];
    
    tile06 = [tile spriteWithTexture:t906no rect:tileRect];
    [tile06 setTextures:t906no :t906yes];
    tile06.position = ipos905;
    tile06.value = 6;
    tile06.originalPos = 5; tile06.currentPos = 5;
    [self addChild: tile06];
    [tiles insertObject:tile06 atIndex:5];
    
    tile07 = [tile spriteWithTexture:t907no rect:tileRect];
    [tile07 setTextures:t907no :t907yes];
    tile07.position = ipos906;
    tile07.value = 7;
    tile07.originalPos = 6; tile07.currentPos = 6;
    [self addChild: tile07];
    [tiles insertObject:tile07 atIndex:6];
    
    tile08 = [tile spriteWithTexture:t908no rect:tileRect];
    [tile08 setTextures:t908no :t908yes];
    tile08.position = ipos907;
    tile08.value = 8;
    tile08.originalPos = 7; tile08.currentPos = 7;
    [self addChild: tile08];
    [tiles insertObject:tile08 atIndex:7];
    
    tileBlank = [tile spriteWithFile:@"tile9blank.png" rect:tileRect];
    tileBlank.position = ipos908;
    tileBlank.value = 0;
    tileBlank.originalPos = 8; tileBlank.currentPos = 8;
    [self addChild: tileBlank];
    [tiles insertObject:tileBlank atIndex:8];
    
}

-(void) shuffleTiles{
    
    NSMutableArray *tilesWithMoves = [[NSMutableArray alloc] init];
    numberCounted = 8;
    
    srandom(time(NULL));
    while (numberCounted>0){
        for(int i=0; i<100; i++){
            [tilesWithMoves removeAllObjects];
            
            for(int j=0; j<[tiles count]; j++){
                tile *t = [tiles objectAtIndex:j];
                [self findMoves:t];
                if(t.validMove != NONE){
                    [tilesWithMoves addObject: t];
                }
            }
            if([tilesWithMoves count]!=0){
                NSInteger randomIndex = random()%[tilesWithMoves count];
                [self shuffleMove:(tile*)[tilesWithMoves objectAtIndex:randomIndex]];
            }
        }
        [self checkCounted];
    }
}

#pragma mark Movement Methods

-(void)findMoves:(tile *)t {
    
    CGFloat blankX = tileBlank.position.x;
    CGFloat blankY = tileBlank.position.y;
    CGFloat tmpX, tmpY;
    
    //Blank Above
    tmpX = blankX; tmpY = (blankY - 130);
    if((t.position.x == tmpX)&&(t.position.y == tmpY)){
        t.validMove = UP;
        return;
    }
    
    //Blank Below
    tmpX = blankX; tmpY = (blankY + 130);
    if((t.position.x == tmpX)&&(t.position.y == tmpY)){
        t.validMove = DOWN;
        return;
    }
    
    //Blank Left
    tmpX = (blankX + 98); tmpY = (blankY);
    if((t.position.x == tmpX)&&(t.position.y == tmpY)){
        t.validMove = LEFT;
        return;
    }
    
    //Blank Right
    tmpX = (blankX - 98); tmpY = (blankY);
    if((t.position.x == tmpX)&&(t.position.y == tmpY)){
        t.validMove = RIGHT;
        return;
    }
    
    t.validMove = NONE;
    return;
}

#pragma mark Checking Method

-(void) checkCounted{
    
    numberCounted = 0;
    
    for(tile *t in tiles){
        if(t.currentPos == t.originalPos){
            t.counted = YES;
            numberCounted++;
        }
        else{
            t.counted = NO;
        }
    }
}

#pragma mark Return Method

-(void) restartPressed{
    [self dismissPause];
    [self runAction:[CCSequence actions: [CCDelayTime actionWithDuration:.3],[CCCallFuncN actionWithTarget:self selector:@selector(dismissTiles)],nil]];
    [self runAction:[CCSequence actions: [CCDelayTime actionWithDuration:1],[CCCallFuncN actionWithTarget:self selector:@selector(dismissTopBar)],nil]];
    [self runAction:[CCSequence actions: [CCDelayTime actionWithDuration:1.25],[CCCallFuncN actionWithTarget:self selector:@selector(reloadCurrentScene)],nil]];
}

-(void) reloadCurrentScene{
    [bannerView setHidden:YES];
    [[CCDirector sharedDirector]replaceScene: [nineClassicLayer scene]];
}

-(void) menuPressed{
    [self dismissPause];
    [self runAction:[CCSequence actions: [CCDelayTime actionWithDuration:.3],[CCCallFuncN actionWithTarget:self selector:@selector(dismissTiles)],nil]];
    [self runAction:[CCSequence actions: [CCDelayTime actionWithDuration:1],[CCCallFuncN actionWithTarget:self selector:@selector(dismissTopBar)],nil]];
    [self runAction:[CCSequence actions: [CCDelayTime actionWithDuration:1.25],[CCCallFuncN actionWithTarget:self selector:@selector(returnToMenu)],nil]];
}

@end
