//
//  tile.h
//  nine 9
//
//  Created by Mark Bellott on 6/20/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum{
    NONE = 0,
    UP   = 1,
    DOWN = 2,
    RIGHT= 3,
    LEFT = 4,
} moves;

//Define Tile Class
@interface tile : CCSprite {
@public
    moves validMove;
    BOOL counted, locked;
    NSInteger value, currentPos, originalPos;
    
@private
    CCTexture2D *normalTex, *countedTex;
    
}

@property(nonatomic, assign)NSInteger value;
@property(nonatomic, assign)NSInteger currentPos;
@property(nonatomic, assign)NSInteger originalPos;
@property(nonatomic,readwrite)BOOL counted;
@property(nonatomic,readwrite)BOOL locked;
@property(nonatomic, assign)moves validMove;


-(void) setTextures:(CCTexture2D*)nTex :(CCTexture2D*)cTex;
-(tile*) changeTexNormal:(tile*)t;
-(tile*) changeTexCounted:(tile*)t;

@end
