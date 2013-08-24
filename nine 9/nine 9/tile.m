//
//  tile.m
//  nine 9
//
//  Created by Mark Bellott on 6/20/12.
//
//

#import "tile.h"

@implementation tile

@synthesize value, currentPos, originalPos, counted, locked, validMove;

-(void) setTextures:(CCTexture2D*)nTex :(CCTexture2D*)cTex{
    normalTex = nTex;
    countedTex = cTex;
}

-(tile*) changeTexNormal:(tile*)t{
    [t setTexture:normalTex];
    return t;
}

-(tile*) changeTexCounted:(tile*)t{
    [t setTexture:countedTex];
    return t;
}

@end
