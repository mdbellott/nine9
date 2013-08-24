//
//  GCHelper.h
//  nine 9
//
//  Created by Mark Bellott on 10/2/12.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@class GKLeaderboard, GKPlayer;

@protocol GCHelperDelegate <NSObject>
@optional
- (void) processGameCenterAuth: (NSError*) error;
- (void) scoreReported: (NSError*) error;
- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error;
- (void) mappedPlayerIDToPlayer: (GKPlayer*) player error: (NSError*) error;
@end

@interface GCHelper : NSObject {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    NSMutableDictionary *earnedAchievementCache;
    UIViewController *leaderViewController;
    id <GCHelperDelegate, NSObject> __unsafe_unretained delegate;
}

@property (assign, readonly) BOOL gameCenterAvailable;
@property (nonatomic, readonly) BOOL userHasBeenAuthenticated;
@property (strong) NSMutableDictionary* earnedAchievementCache;
@property (nonatomic, unsafe_unretained)  id <GCHelperDelegate> delegate;

+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;

- (void) reportScore: (int64_t) score forCategory: (NSString*) category;
- (void) reloadHighScoresForCategory: (NSString*) category;

- (void) submitAchievement: (NSString*) identifier percentComplete: (double) percentComplete;
- (void) resetAchievements;

@end
