//
//  twentyfiveClassicLayer.m
//  nine 9
//
//  Created by Mark Bellott on 7/23/12.
//  Copyright 2012 MarkBellott. All rights reserved.
//

#import "twentyfiveClassicLayer.h"


@implementation twentyfiveClassicLayer

+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	
	twentyfiveClassicLayer *layer = [twentyfiveClassicLayer node];
    
	[scene addChild: layer];
	
	return scene;
}

#pragma mark Init Method

-(id) init {
    if( (self=[super init])) {
        
        //Initiate winSize
        winSize = [[CCDirector sharedDirector] winSize];
        
        //Set Puzzle Size
        puzzleSize = 25;
        
        //Set scoreTag
        scoreTag = @"25Classic";
        
        //Set up Initial Position Constants (Off Screen)
        ipos2500 = ccp(43,winSize.height/2 - 356); ipos2501 = ccp(102,winSize.height/2 - 356); ipos2502 = ccp(161,winSize.height/2 - 356);
        ipos2503 = ccp(220,winSize.height/2 - 356); ipos2504 = ccp(279,winSize.height/2 - 356); ipos2505 = ccp(43,winSize.height/2 - 434.5);
        ipos2506 = ccp(102,winSize.height/2 - 434.5); ipos2507 = ccp(161,winSize.height/2 - 434.5); ipos2508 = ccp(220,winSize.height/2 - 434.5);
        ipos2509 = ccp(279,winSize.height/2 - 434.5); ipos2510 = ccp(43,winSize.height/2 - 513); ipos2511 = ccp(102,winSize.height/2 - 513);
        ipos2512 = ccp(161,winSize.height/2 - 513); ipos2513 = ccp(220,winSize.height/2 - 513); ipos2514 = ccp(279,winSize.height/2 - 513);
        ipos2515 = ccp(43,winSize.height/2 - 591.5); ipos2516 = ccp(102,winSize.height/2 - 591.5); ipos2517 = ccp(161,winSize.height/2 - 591.5);
        ipos2518 = ccp(220,winSize.height/2 - 591.5); ipos2519 = ccp(279,winSize.height/2 - 591.5); ipos2520 = ccp(43,winSize.height/2 - 670);
        ipos2521 = ccp(102,winSize.height/2 - 670); ipos2522 = ccp(161,winSize.height/2 - 670); ipos2523 = ccp(220,winSize.height/2 - 670);
        ipos2524 = ccp(279,winSize.height/2 - 670);
        
        //Set up Textures
        t2501no = [[CCTextureCache sharedTextureCache] addImage: @"tile2501.png"];
        t2502no = [[CCTextureCache sharedTextureCache] addImage: @"tile2502.png"];
        t2503no = [[CCTextureCache sharedTextureCache] addImage: @"tile2503.png"];
        t2504no = [[CCTextureCache sharedTextureCache] addImage: @"tile2504.png"];
        t2505no = [[CCTextureCache sharedTextureCache] addImage: @"tile2505.png"];
        t2506no = [[CCTextureCache sharedTextureCache] addImage: @"tile2506.png"];
        t2507no = [[CCTextureCache sharedTextureCache] addImage: @"tile2507.png"];
        t2508no = [[CCTextureCache sharedTextureCache] addImage: @"tile2508.png"];
        t2509no = [[CCTextureCache sharedTextureCache] addImage: @"tile2509.png"];
        t2510no = [[CCTextureCache sharedTextureCache] addImage: @"tile2510.png"];
        t2511no = [[CCTextureCache sharedTextureCache] addImage: @"tile2511.png"];
        t2512no = [[CCTextureCache sharedTextureCache] addImage: @"tile2512.png"];
        t2513no = [[CCTextureCache sharedTextureCache] addImage: @"tile2513.png"];
        t2514no = [[CCTextureCache sharedTextureCache] addImage: @"tile2514.png"];
        t2515no = [[CCTextureCache sharedTextureCache] addImage: @"tile2515.png"];
        t2516no = [[CCTextureCache sharedTextureCache] addImage: @"tile2516.png"];
        t2517no = [[CCTextureCache sharedTextureCache] addImage: @"tile2517.png"];
        t2518no = [[CCTextureCache sharedTextureCache] addImage: @"tile2518.png"];
        t2519no = [[CCTextureCache sharedTextureCache] addImage: @"tile2519.png"];
        t2520no = [[CCTextureCache sharedTextureCache] addImage: @"tile2520.png"];
        t2521no = [[CCTextureCache sharedTextureCache] addImage: @"tile2521.png"];
        t2522no = [[CCTextureCache sharedTextureCache] addImage: @"tile2522.png"];
        t2523no = [[CCTextureCache sharedTextureCache] addImage: @"tile2523.png"];
        t2524no = [[CCTextureCache sharedTextureCache] addImage: @"tile2524.png"];
        
        
        t2501yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2501Counted.png"];
        t2502yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2502Counted.png"];
        t2503yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2503Counted.png"];
        t2504yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2504Counted.png"];
        t2505yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2505Counted.png"];
        t2506yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2506Counted.png"];
        t2507yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2507Counted.png"];
        t2508yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2508Counted.png"];
        t2509yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2509Counted.png"];
        t2510yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2510Counted.png"];
        t2511yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2511Counted.png"];
        t2512yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2512Counted.png"];
        t2513yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2513Counted.png"];
        t2514yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2514Counted.png"];
        t2515yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2515Counted.png"];
        t2516yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2516Counted.png"];
        t2517yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2517Counted.png"];
        t2518yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2518Counted.png"];
        t2519yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2519Counted.png"];
        t2520yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2520Counted.png"];
        t2521yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2521Counted.png"];
        t2522yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2522Counted.png"];
        t2523yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2523Counted.png"];
        t2524yes = [[CCTextureCache sharedTextureCache] addImage: @"tile2524Counted.png"];
        
        //Allocate space for tiles array
        tiles = [[NSMutableArray alloc] init];
        
        //Create Default tileRect
        tileRect = CGRectMake(0, 0, 59, 78.5);
        
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
    
    tile01 = [tile spriteWithTexture:t2501no rect:tileRect];
    [tile01 setTextures:t2501no :t2501yes];
    tile01.position = ipos2500;
    tile01.value = 1;
    tile01.originalPos = 0; tile02.currentPos = 0;
    [self addChild: tile01];
    [tiles insertObject:tile01 atIndex:0];
    
    tile02 = [tile spriteWithTexture:t2502no rect:tileRect];
    [tile02 setTextures:t2502no :t2502yes];
    tile02.position = ipos2501;
    tile02.value = 2;
    tile02.originalPos = 1; tile02.currentPos = 1;
    [self addChild: tile02];
    [tiles insertObject:tile02 atIndex:1];
    
    tile03 = [tile spriteWithTexture:t2503no rect:tileRect];
    [tile03 setTextures:t2503no :t2503yes];
    tile03.position = ipos2502;
    tile03.value = 3;
    tile03.originalPos = 2; tile03.currentPos = 2;
    [self addChild: tile03];
    [tiles insertObject:tile03 atIndex:2];
    
    tile04 = [tile spriteWithTexture:t2504no rect:tileRect];
    [tile04 setTextures:t2504no :t2504yes];
    tile04.position = ipos2503;
    tile04.value = 4;
    tile04.originalPos = 3; tile04.currentPos = 3;
    [self addChild: tile04];
    [tiles insertObject:tile04 atIndex:3];
    
    tile05 = [tile spriteWithTexture:t2505no rect:tileRect];
    [tile05 setTextures:t2505no :t2505yes];
    tile05.position = ipos2504;
    tile05.value = 5;
    tile05.originalPos = 4; tile05.currentPos = 4;
    [self addChild: tile05];
    [tiles insertObject:tile05 atIndex:4];
    
    tile06 = [tile spriteWithTexture:t2506no rect:tileRect];
    [tile06 setTextures:t2506no :t2506yes];
    tile06.position = ipos2505;
    tile06.value = 6;
    tile06.originalPos = 5; tile06.currentPos = 5;
    [self addChild: tile06];
    [tiles insertObject:tile06 atIndex:5];
 
    tile07 = [tile spriteWithTexture:t2507no rect:tileRect];
    [tile07 setTextures:t2507no :t2507yes];
    tile07.position = ipos2506;
    tile07.value = 7;
    tile07.originalPos = 6; tile07.currentPos = 6;
    [self addChild: tile07];
    [tiles insertObject:tile07 atIndex:6];
    
    tile08 = [tile spriteWithTexture:t2508no rect:tileRect];
    [tile08 setTextures:t2508no :t2508yes];
    tile08.position = ipos2507;
    tile08.value = 8;
    tile08.originalPos = 7; tile08.currentPos = 7;
    [self addChild: tile08];
    [tiles insertObject:tile08 atIndex:7];
    
    tile09 = [tile spriteWithTexture:t2509no rect:tileRect];
    [tile09 setTextures:t2509no :t2509yes];
    tile09.position = ipos2508;
    tile09.value = 9;
    tile09.originalPos = 8; tile09.currentPos = 8;
    [self addChild: tile09];
    [tiles insertObject:tile09 atIndex:8];
    
    tile10 = [tile spriteWithTexture:t2510no rect:tileRect];
    [tile10 setTextures:t2510no :t2510yes];
    tile10.position = ipos2509;
    tile10.value = 10;
    tile10.originalPos = 9; tile10.currentPos = 9;
    [self addChild: tile10];
    [tiles insertObject:tile10 atIndex:9];
    
    tile11 = [tile spriteWithTexture:t2511no rect:tileRect];
    [tile11 setTextures:t2511no :t2511yes];
    tile11.position = ipos2510;
    tile11.value = 11;
    tile11.originalPos = 10; tile11.currentPos = 10;
    [self addChild: tile11];
    [tiles insertObject:tile11 atIndex:10];
    
    tile12 = [tile spriteWithTexture:t2512no rect:tileRect];
    [tile12 setTextures:t2512no :t2512yes];
    tile12.position = ipos2511;
    tile12.value = 12;
    tile12.originalPos = 11; tile12.currentPos = 11;
    [self addChild: tile12];
    [tiles insertObject:tile12 atIndex:11];
    
    tile13 = [tile spriteWithTexture:t2513no rect:tileRect];
    [tile13 setTextures:t2513no :t2513yes];
    tile13.position = ipos2512;
    tile13.value = 13;
    tile13.originalPos = 12; tile13.currentPos = 12;
    [self addChild: tile13];
    [tiles insertObject:tile13 atIndex:12];
    
    tile14 = [tile spriteWithTexture:t2514no rect:tileRect];
    [tile14 setTextures:t2514no :t2514yes];
    tile14.position = ipos2513;
    tile14.value = 14;
    tile14.originalPos = 13; tile14.currentPos = 13;
    [self addChild: tile14];
    [tiles insertObject:tile14 atIndex:13];
    
    tile15 = [tile spriteWithTexture:t2515no rect:tileRect];
    [tile15 setTextures:t2515no :t2515yes];
    tile15.position = ipos2514;
    tile15.value = 15;
    tile15.originalPos = 14; tile15.currentPos = 14;
    [self addChild: tile15];
    [tiles insertObject:tile15 atIndex:14];
    
    tile16 = [tile spriteWithTexture:t2516no rect:tileRect];
    [tile16 setTextures:t2516no :t2516yes];
    tile16.position = ipos2515;
    tile16.value = 16;
    tile16.originalPos = 15; tile16.currentPos = 15;
    [self addChild: tile16];
    [tiles insertObject:tile16 atIndex:15];
    
    tile17 = [tile spriteWithTexture:t2517no rect:tileRect];
    [tile17 setTextures:t2517no :t2517yes];
    tile17.position = ipos2516;
    tile17.value = 17;
    tile17.originalPos = 16; tile17.currentPos = 16;
    [self addChild: tile17];
    [tiles insertObject:tile17 atIndex:16];
    
    tile18 = [tile spriteWithTexture:t2518no rect:tileRect];
    [tile18 setTextures:t2518no :t2518yes];
    tile18.position = ipos2517;
    tile18.value = 18;
    tile18.originalPos = 17; tile18.currentPos = 17;
    [self addChild: tile18];
    [tiles insertObject:tile18 atIndex:17];
    
    tile19 = [tile spriteWithTexture:t2519no rect:tileRect];
    [tile19 setTextures:t2519no :t2519yes];
    tile19.position = ipos2518;
    tile19.value = 19;
    tile19.originalPos = 18; tile19.currentPos = 18;
    [self addChild: tile19];
    [tiles insertObject:tile19 atIndex:18];
    
    tile20 = [tile spriteWithTexture:t2520no rect:tileRect];
    [tile20 setTextures:t2520no :t2520yes];
    tile20.position = ipos2519;
    tile20.value = 20;
    tile20.originalPos = 19; tile20.currentPos = 19;
    [self addChild: tile20];
    [tiles insertObject:tile20 atIndex:19];
    
    tile21 = [tile spriteWithTexture:t2521no rect:tileRect];
    [tile21 setTextures:t2521no :t2521yes];
    tile21.position = ipos2520;
    tile21.value = 21;
    tile21.originalPos = 20; tile21.currentPos = 20;
    [self addChild: tile21];
    [tiles insertObject:tile21 atIndex:20];
    
    tile22 = [tile spriteWithTexture:t2522no rect:tileRect];
    [tile22 setTextures:t2522no :t2522yes];
    tile22.position = ipos2521;
    tile22.value = 22;
    tile22.originalPos = 21; tile22.currentPos = 21;
    [self addChild: tile22];
    [tiles insertObject:tile22 atIndex:21];
    
    tile23 = [tile spriteWithTexture:t2523no rect:tileRect];
    [tile23 setTextures:t2523no :t2523yes];
    tile23.position = ipos2522;
    tile23.value = 23;
    tile23.originalPos = 22; tile23.currentPos = 22;
    [self addChild: tile23];
    [tiles insertObject:tile23 atIndex:22];
    
    tile24 = [tile spriteWithTexture:t2524no rect:tileRect];
    [tile24 setTextures:t2524no :t2524yes];
    tile24.position = ipos2523;
    tile24.value = 24;
    tile24.originalPos = 23; tile24.currentPos = 23;
    [self addChild: tile24];
    [tiles insertObject:tile24 atIndex:23];
    
    tileBlank = [tile spriteWithFile:@"tile25blank.png" rect:tileRect];
    tileBlank.position = ipos2524;
    tileBlank.value = 0;
    tileBlank.originalPos = 24; tileBlank.currentPos = 24;
    [self addChild: tileBlank];
    [tiles insertObject:tileBlank atIndex:24];
    
}

-(void) shuffleTiles{
    
    NSMutableArray *tilesWithMoves = [[NSMutableArray alloc] init];
    numberCounted = 17;
    
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
    tmpX = blankX; tmpY = (blankY - 78.5);
    if((t.position.x == tmpX)&&(t.position.y == tmpY)){
        t.validMove = UP;
        return;
    }
    
    //Blank Below
    tmpX = blankX; tmpY = (blankY + 78.5);
    if((t.position.x == tmpX)&&(t.position.y == tmpY)){
        t.validMove = DOWN;
        return;
    }
    
    //Blank Left
    tmpX = (blankX + 59); tmpY = (blankY);
    if((t.position.x == tmpX)&&(t.position.y == tmpY)){
        t.validMove = LEFT;
        return;
    }
    
    //Blank Right
    tmpX = (blankX - 59); tmpY = (blankY);
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
    [self runAction:[CCSequence actions: [CCDelayTime actionWithDuration:1.5],[CCCallFuncN actionWithTarget:self selector:@selector(dismissTopBar)],nil]];
    [self runAction:[CCSequence actions: [CCDelayTime actionWithDuration:1.75],[CCCallFuncN actionWithTarget:self selector:@selector(reloadCurrentScene)],nil]];
}

-(void) reloadCurrentScene{
    [bannerView setHidden:YES];
    [[CCDirector sharedDirector]replaceScene: [twentyfiveClassicLayer scene]];
}


-(void) menuPressed{
    [self dismissPause];
    [self runAction:[CCSequence actions: [CCDelayTime actionWithDuration:.3],[CCCallFuncN actionWithTarget:self selector:@selector(dismissTiles)],nil]];
    [self runAction:[CCSequence actions: [CCDelayTime actionWithDuration:1],[CCCallFuncN actionWithTarget:self selector:@selector(dismissTopBar)],nil]];
    [self runAction:[CCSequence actions: [CCDelayTime actionWithDuration:1.25],[CCCallFuncN actionWithTarget:self selector:@selector(returnToMenu)],nil]];
}

@end