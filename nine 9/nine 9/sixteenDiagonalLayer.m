//
//  sixteenDiagonalLayer.m
//  nine 9
//
//  Created by Mark Bellott on 7/1/12.
//  Copyright 2012 MarkBellott. All rights reserved.
//

#import "sixteenDiagonalLayer.h"


@implementation sixteenDiagonalLayer

+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	
	sixteenDiagonalLayer *layer = [sixteenDiagonalLayer node];
    
	[scene addChild: layer];
	
	return scene;
}

#pragma mark Init Method

-(id) init {
    if( (self=[super init])) {
        
        //Initiate winSize
        winSize = [[CCDirector sharedDirector] winSize];
        
        //Set Puzzle Size
        puzzleSize = 16;
        
        //Set scoreTag
        scoreTag = @"16Diagonal";
        
        //Set up Initial Position Constants (Off Screen)
        ipos1600 = ccp(50,winSize.height/2 - 366); ipos1601 = ccp(123.5,winSize.height/2 - 366);
        ipos1602 = ccp(197,winSize.height/2 - 366); ipos1603 = ccp(270.5,winSize.height/2 - 366);
        ipos1604 = ccp(50,winSize.height/2 - 464); ipos1605 = ccp(123.5,winSize.height/2 - 464);
        ipos1606 = ccp(197,winSize.height/2 - 464); ipos1607 = ccp(270.5,winSize.height/2 - 464);
        ipos1608 = ccp(50,winSize.height/2 - 562); ipos1609 = ccp(123.5,winSize.height/2 - 562);
        ipos1610 = ccp(197,winSize.height/2 - 562); ipos1611 = ccp(270.5,winSize.height/2 - 562);
        ipos1612 = ccp(50,winSize.height/2 - 660); ipos1613 = ccp(123.5,winSize.height/2 - 660);
        ipos1614 = ccp(197,winSize.height/2 - 660); ipos1615 = ccp(270.5,winSize.height/2 - 660);
        
        //Set up Textures
        t1601no = [[CCTextureCache sharedTextureCache] addImage: @"tile1601.png"];
        t1602no = [[CCTextureCache sharedTextureCache] addImage: @"tile1602.png"];
        t1603no = [[CCTextureCache sharedTextureCache] addImage: @"tile1603.png"];
        t1604no = [[CCTextureCache sharedTextureCache] addImage: @"tile1604.png"];
        t1605no = [[CCTextureCache sharedTextureCache] addImage: @"tile1605.png"];
        t1606no = [[CCTextureCache sharedTextureCache] addImage: @"tile1606.png"];
        t1607no = [[CCTextureCache sharedTextureCache] addImage: @"tile1607.png"];
        t1608no = [[CCTextureCache sharedTextureCache] addImage: @"tile1608Ignored.png"];
        t1609no = [[CCTextureCache sharedTextureCache] addImage: @"tile1609.png"];
        t1610no = [[CCTextureCache sharedTextureCache] addImage: @"tile1610.png"];
        t1611no = [[CCTextureCache sharedTextureCache] addImage: @"tile1611.png"];
        t1612no = [[CCTextureCache sharedTextureCache] addImage: @"tile1612.png"];
        t1613no = [[CCTextureCache sharedTextureCache] addImage: @"tile1613.png"];
        t1614no = [[CCTextureCache sharedTextureCache] addImage: @"tile1614.png"];
        t1615no = [[CCTextureCache sharedTextureCache] addImage: @"tile1615.png"];
        
        t1601yes = [[CCTextureCache sharedTextureCache] addImage:@"tile1601Counted.png"];
        t1602yes = [[CCTextureCache sharedTextureCache] addImage:@"tile1602Counted.png"];
        t1603yes = [[CCTextureCache sharedTextureCache] addImage:@"tile1603Counted.png"];
        t1604yes = [[CCTextureCache sharedTextureCache] addImage:@"tile1604Counted.png"];
        t1605yes = [[CCTextureCache sharedTextureCache] addImage:@"tile1605Counted.png"];
        t1606yes = [[CCTextureCache sharedTextureCache] addImage:@"tile1606Counted.png"];
        t1607yes = [[CCTextureCache sharedTextureCache] addImage:@"tile1607Counted.png"];
        t1608yes = [[CCTextureCache sharedTextureCache] addImage:@"tile1608Ignored.png"];
        t1609yes = [[CCTextureCache sharedTextureCache] addImage:@"tile1609Counted.png"];
        t1610yes = [[CCTextureCache sharedTextureCache] addImage:@"tile1610Counted.png"];
        t1611yes = [[CCTextureCache sharedTextureCache] addImage:@"tile1611Counted.png"];
        t1612yes = [[CCTextureCache sharedTextureCache] addImage:@"tile1612Counted.png"];
        t1613yes = [[CCTextureCache sharedTextureCache] addImage:@"tile1613Counted.png"];
        t1614yes = [[CCTextureCache sharedTextureCache] addImage:@"tile1614Counted.png"];
        t1615yes = [[CCTextureCache sharedTextureCache] addImage:@"tile1615Counted.png"];
        
        //Allocate space for tiles array
        tiles = [[NSMutableArray alloc] init];
        
        //Create Default tileRect
        tileRect = CGRectMake(0, 0, 73.5, 98);
        
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
    
    tile01 = [tile spriteWithTexture:t1601no rect:tileRect];
    [tile01 setTextures:t1601no :t1601yes];
    tile01.position = ipos1600;
    tile01.value = 1;
    tile01.originalPos = 0; tile01.currentPos = 0;
    [self addChild: tile01];
    [tiles insertObject:tile01 atIndex:0];
    
    tile02 = [tile spriteWithTexture:t1602no rect:tileRect];
    [tile02 setTextures:t1602no :t1602yes];
    tile02.position = ipos1601;
    tile02.value = 2;
    tile02.originalPos = 1; tile02.currentPos = 1;
    [self addChild: tile02];
    [tiles insertObject:tile02 atIndex:1];
    
    tile03 = [tile spriteWithTexture:t1603no rect:tileRect];
    [tile03 setTextures:t1603no :t1603yes];
    tile03.position = ipos1602;
    tile03.value = 3;
    tile03.originalPos = 2; tile03.currentPos = 2;
    [self addChild: tile03];
    [tiles insertObject:tile03 atIndex:2];
    
    tile04 = [tile spriteWithTexture:t1604no rect:tileRect];
    [tile04 setTextures:t1604no :t1604yes];
    tile04.position = ipos1603;
    tile04.value = 4;
    tile04.originalPos = 3; tile04.currentPos = 3;
    [self addChild: tile04];
    [tiles insertObject:tile04 atIndex:3];
    
    tile05 = [tile spriteWithTexture:t1605no rect:tileRect];
    [tile05 setTextures:t1605no :t1605yes];
    tile05.position = ipos1604;
    tile05.value = 5;
    tile05.originalPos = 4; tile05.currentPos = 4;
    [self addChild: tile05];
    [tiles insertObject:tile05 atIndex:4];
    
    tile06 = [tile spriteWithTexture:t1606no rect:tileRect];
    [tile06 setTextures:t1606no :t1606yes];
    tile06.position = ipos1605;
    tile06.value = 6;
    tile06.originalPos = 5; tile06.currentPos = 5;
    [self addChild: tile06];
    [tiles insertObject:tile06 atIndex:5];
    
    tile07 = [tile spriteWithTexture:t1607no rect:tileRect];
    [tile07 setTextures:t1607no :t1607yes];
    tile07.position = ipos1606;
    tile07.value = 7;
    tile07.originalPos = 6; tile07.currentPos = 6;
    [self addChild: tile07];
    [tiles insertObject:tile07 atIndex:6];
    
    tile08 = [tile spriteWithTexture:t1608no rect:tileRect];
    [tile08 setTextures:t1608no :t1608yes];
    tile08.position = ipos1607;
    tile08.value = 8;
    tile08.originalPos = 7; tile08.currentPos = 7;
    [self addChild: tile08];
    [tiles insertObject:tile08 atIndex:7];
    
    tile09 = [tile spriteWithTexture:t1609no rect:tileRect];
    [tile09 setTextures:t1609no :t1609yes];
    tile09.position = ipos1608;
    tile09.value = 9;
    tile09.originalPos = 8; tile09.currentPos = 8;
    [self addChild: tile09];
    [tiles insertObject:tile09 atIndex:8];
    
    tile10 = [tile spriteWithTexture:t1610no rect:tileRect];
    [tile10 setTextures:t1610no :t1610yes];
    tile10.position = ipos1609;
    tile10.value = 10;
    tile10.originalPos = 9; tile10.currentPos = 9;
    [self addChild: tile10];
    [tiles insertObject:tile10 atIndex:9];
    
    tile11 = [tile spriteWithTexture:t1611no rect:tileRect];
    [tile11 setTextures:t1611no :t1611yes];
    tile11.position = ipos1610;
    tile11.value = 11;
    tile11.originalPos = 10; tile11.currentPos = 10;
    [self addChild: tile11];
    [tiles insertObject:tile11 atIndex:10];
    
    tile12 = [tile spriteWithTexture:t1612no rect:tileRect];
    [tile12 setTextures:t1612no :t1612yes];
    tile12.position = ipos1611;
    tile12.value = 12;
    tile12.originalPos = 11; tile12.currentPos = 11;
    [self addChild: tile12];
    [tiles insertObject:tile12 atIndex:11];
    
    tile13 = [tile spriteWithTexture:t1613no rect:tileRect];
    [tile13 setTextures:t1613no :t1613yes];
    tile13.position = ipos1612;
    tile13.value = 13;
    tile13.originalPos = 12; tile13.currentPos = 12;
    [self addChild: tile13];
    [tiles insertObject:tile13 atIndex:12];
    
    tile14 = [tile spriteWithTexture:t1614no rect:tileRect];
    [tile14 setTextures:t1614no :t1614yes];
    tile14.position = ipos1613;
    tile14.value = 14;
    tile14.originalPos = 13; tile14.currentPos = 13;
    [self addChild: tile14];
    [tiles insertObject:tile14 atIndex:13];
    
    tile15 = [tile spriteWithTexture:t1615no rect:tileRect];
    [tile15 setTextures:t1615no :t1615yes];
    tile15.position = ipos1614;
    tile15.value = 15;
    tile15.originalPos = 14; tile15.currentPos = 14;
    [self addChild: tile15];
    [tiles insertObject:tile15 atIndex:14];
    
    tileBlank = [tile spriteWithFile:@"tile16blank.png" rect:tileRect];
    tileBlank.position = ipos1615;
    tileBlank.value = 0;
    tileBlank.originalPos = 15; tileBlank.currentPos = 15;
    [self addChild: tileBlank];
    [tiles insertObject:tileBlank atIndex:15];
}

-(void) shuffleTiles{
    
    NSMutableArray *tilesWithMoves = [[NSMutableArray alloc] init];
    numberCounted = 17;
    
    srandom(time(NULL));
    while (numberCounted>1){
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
    tmpX = blankX; tmpY = (blankY - 98);
    if((t.position.x == tmpX)&&(t.position.y == tmpY)){
        t.validMove = UP;
        return;
    }
    
    //Blank Below
    tmpX = blankX; tmpY = (blankY + 98);
    if((t.position.x == tmpX)&&(t.position.y == tmpY)){
        t.validMove = DOWN;
        return;
    }
    
    //Blank Left
    tmpX = (blankX + 73.5); tmpY = (blankY);
    if((t.position.x == tmpX)&&(t.position.y == tmpY)){
        t.validMove = LEFT;
        return;
    }
    
    //Blank Right
    tmpX = (blankX - 73.5); tmpY = (blankY);
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
    tile *t, *tmpT1, *tmpT2, *tmpT3, *tmpT4,
    *tmpT5;
    
    //Check pos1600
    t = [tiles objectAtIndex:0];
    tmpT1 = [tiles objectAtIndex:5];
    tmpT2 = [tiles objectAtIndex:10];
    tmpT3 = [tiles objectAtIndex:15];
    if((t.value + tmpT1.value == 16)||
       (t.value + tmpT2.value == 16)||
       (t.value + tmpT3.value == 16)){
        t.counted = YES;
        numberCounted++;
    }
    else {
        t.counted = NO;
    }
    
    //Check pos1601
    t = [tiles objectAtIndex:1];
    tmpT1 = [tiles objectAtIndex:4];
    tmpT2 = [tiles objectAtIndex:6];
    tmpT3 = [tiles objectAtIndex:11];
    if((t.value + tmpT1.value == 16)||
       (t.value + tmpT2.value == 16)||
       (t.value + tmpT3.value == 16)){
        t.counted = YES;
        numberCounted++;
    }
    else {
        t.counted = NO;
    }
    
    //Check pos1602
    t = [tiles objectAtIndex:2];
    tmpT1 = [tiles objectAtIndex:5];
    tmpT2 = [tiles objectAtIndex:7];
    tmpT3 = [tiles objectAtIndex:8];
    if((t.value + tmpT1.value == 16)||
       (t.value + tmpT2.value == 16)||
       (t.value + tmpT3.value == 16)){
        t.counted = YES;
        numberCounted++;
    }
    else {
        t.counted = NO;
    }
    
    //Check pos1603
    t = [tiles objectAtIndex:3];
    tmpT1 = [tiles objectAtIndex:6];
    tmpT2 = [tiles objectAtIndex:9];
    tmpT3 = [tiles objectAtIndex:12];
    if((t.value + tmpT1.value == 16)||
       (t.value + tmpT2.value == 16)||
       (t.value + tmpT3.value == 16)){
        t.counted = YES;
        numberCounted++;
    }
    else {
        t.counted = NO;
    }
    
    //Check pos1604
    t = [tiles objectAtIndex:4];
    tmpT1 = [tiles objectAtIndex:1];
    tmpT2 = [tiles objectAtIndex:9];
    tmpT3 = [tiles objectAtIndex:14];
    if((t.value + tmpT1.value == 16)||
       (t.value + tmpT2.value == 16)||
       (t.value + tmpT3.value == 16)){
        t.counted = YES;
        numberCounted++;
    }
    else {
        t.counted = NO;
    }
    
    //Check pos1605
    t = [tiles objectAtIndex:5];
    tmpT1 = [tiles objectAtIndex:0];
    tmpT2 = [tiles objectAtIndex:2];
    tmpT3 = [tiles objectAtIndex:8];
    tmpT4 = [tiles objectAtIndex:10];
    tmpT5 = [tiles objectAtIndex:15];
    if((t.value + tmpT1.value == 16)||
       (t.value + tmpT2.value == 16)||
       (t.value + tmpT3.value == 16)||
       (t.value + tmpT4.value == 16)||
       (t.value + tmpT5.value == 16)){
        t.counted = YES;
        numberCounted++;
    }
    else {
        t.counted = NO;
    }
    
    //Check pos1606
    t = [tiles objectAtIndex:6];
    tmpT1 = [tiles objectAtIndex:1];
    tmpT2 = [tiles objectAtIndex:3];
    tmpT3 = [tiles objectAtIndex:9];
    tmpT4 = [tiles objectAtIndex:11];
    tmpT5 = [tiles objectAtIndex:12];
    if((t.value + tmpT1.value == 16)||
       (t.value + tmpT2.value == 16)||
       (t.value + tmpT3.value == 16)||
       (t.value + tmpT4.value == 16)||
       (t.value + tmpT5.value == 16)){
        t.counted = YES;
        numberCounted++;
    }
    else {
        t.counted = NO;
    }
    
    //Check pos1607
    t = [tiles objectAtIndex:7];
    tmpT1 = [tiles objectAtIndex:2];
    tmpT2 = [tiles objectAtIndex:10];
    tmpT3 = [tiles objectAtIndex:13];
    if((t.value + tmpT1.value == 16)||
       (t.value + tmpT2.value == 16)||
       (t.value + tmpT3.value == 16)){
        t.counted = YES;
        numberCounted++;
    }
    else {
        t.counted = NO;
    }
    
    //Check pos1608
    t = [tiles objectAtIndex:8];
    tmpT1 = [tiles objectAtIndex:2];
    tmpT2 = [tiles objectAtIndex:5];
    tmpT3 = [tiles objectAtIndex:13];
    if((t.value + tmpT1.value == 16)||
       (t.value + tmpT2.value == 16)||
       (t.value + tmpT3.value == 16)){
        t.counted = YES;
        numberCounted++;
    }
    else {
        t.counted = NO;
    }
    
    //Check pos1609
    t = [tiles objectAtIndex:9];
    tmpT1 = [tiles objectAtIndex:3];
    tmpT2 = [tiles objectAtIndex:4];
    tmpT3 = [tiles objectAtIndex:6];
    tmpT4 = [tiles objectAtIndex:12];
    tmpT5 = [tiles objectAtIndex:14];
    if((t.value + tmpT1.value == 16)||
       (t.value + tmpT2.value == 16)||
       (t.value + tmpT3.value == 16)||
       (t.value + tmpT4.value == 16)||
       (t.value + tmpT5.value == 16)){
        t.counted = YES;
        numberCounted++;
    }
    else {
        t.counted = NO;
    }
    
    //Check pos1610
    t = [tiles objectAtIndex:10];
    tmpT1 = [tiles objectAtIndex:0];
    tmpT2 = [tiles objectAtIndex:5];
    tmpT3 = [tiles objectAtIndex:7];
    tmpT4 = [tiles objectAtIndex:13];
    tmpT5 = [tiles objectAtIndex:15];
    if((t.value + tmpT1.value == 16)||
       (t.value + tmpT2.value == 16)||
       (t.value + tmpT3.value == 16)||
       (t.value + tmpT4.value == 16)||
       (t.value + tmpT5.value == 16)){
        t.counted = YES;
        numberCounted++;
    }
    else {
        t.counted = NO;
    }
    
    //Check pos1611
    t = [tiles objectAtIndex:11];
    tmpT1 = [tiles objectAtIndex:1];
    tmpT2 = [tiles objectAtIndex:6];
    tmpT3 = [tiles objectAtIndex:14];
    if((t.value + tmpT1.value == 16)||
       (t.value + tmpT2.value == 16)||
       (t.value + tmpT3.value == 16)){
        t.counted = YES;
        numberCounted++;
    }
    else {
        t.counted = NO;
    }
    
    //Check pos1612
    t = [tiles objectAtIndex:12];
    tmpT1 = [tiles objectAtIndex:3];
    tmpT2 = [tiles objectAtIndex:6];
    tmpT3 = [tiles objectAtIndex:9];
    if((t.value + tmpT1.value == 16)||
       (t.value + tmpT2.value == 16)||
       (t.value + tmpT3.value == 16)){
        t.counted = YES;
        numberCounted++;
    }
    else {
        t.counted = NO;
    }
    
    //Check pos1613
    t = [tiles objectAtIndex:13];
    tmpT1 = [tiles objectAtIndex:7];
    tmpT2 = [tiles objectAtIndex:8];
    tmpT3 = [tiles objectAtIndex:10];
    if((t.value + tmpT1.value == 16)||
       (t.value + tmpT2.value == 16)||
       (t.value + tmpT3.value == 16)){
        t.counted = YES;
        numberCounted++;
    }
    else {
        t.counted = NO;
    }
    
    //Check pos1614
    t = [tiles objectAtIndex:14];
    tmpT1 = [tiles objectAtIndex:4];
    tmpT2 = [tiles objectAtIndex:9];
    tmpT3 = [tiles objectAtIndex:11];
    if((t.value + tmpT1.value == 16)||
       (t.value + tmpT2.value == 16)||
       (t.value + tmpT3.value == 16)){
        t.counted = YES;
        numberCounted++;
    }
    else {
        t.counted = NO;
    }
    
    //Check pos1615
    t = [tiles objectAtIndex:15];
    tmpT1 = [tiles objectAtIndex:0];
    tmpT2 = [tiles objectAtIndex:5];
    tmpT3 = [tiles objectAtIndex:10];
    if((t.value + tmpT1.value == 16)||
       (t.value + tmpT2.value == 16)||
       (t.value + tmpT3.value == 16)){
        t.counted = YES;
        numberCounted++;
    }
    else {
        t.counted = NO;
    }
    
    for(t in tiles){
        if(t.value == 8){
            t.counted = YES;
            numberCounted++;
        }
    }
    
    //Reset slider_blank.counted to YES
    tileBlank.counted = YES;
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
    [[CCDirector sharedDirector]replaceScene: [sixteenDiagonalLayer scene]];
}

-(void) menuPressed{
    [self dismissPause];
    [self runAction:[CCSequence actions: [CCDelayTime actionWithDuration:.3],[CCCallFuncN actionWithTarget:self selector:@selector(dismissTiles)],nil]];
    [self runAction:[CCSequence actions: [CCDelayTime actionWithDuration:1],[CCCallFuncN actionWithTarget:self selector:@selector(dismissTopBar)],nil]];
    [self runAction:[CCSequence actions: [CCDelayTime actionWithDuration:1.25],[CCCallFuncN actionWithTarget:self selector:@selector(returnToMenu)],nil]];
}

@end
