#import "MainScene.h"
#define CP_ALLOW_PRIVATE_ACCESS 1
#import "CCPhysics+ObjectiveChipmunk.h"

@interface MainScene()

@property (nonatomic, strong) CCNode *hero;
@property (nonatomic, weak) CCPhysicsNode *physicsNode;
@property (nonatomic, weak) CCNode *heroStartPosition;
@property (nonatomic, weak) CCNode *level;


@end

@implementation MainScene {
  BOOL _jumped;
  // stores three version of the scrolling background (to allow endless scrolling)
  NSArray *_backgrounds;
}

- (void)didLoadFromCCB {
  self.userInteractionEnabled = YES;
  
  self.level = [CCBReader load:@"Level1" owner:self];
  [self.physicsNode addChild:self.level];
  
  self.hero = [CCBReader load:@"Hero"];
  [self.physicsNode addChild:self.hero];
  self.hero.positionInPoints = self.heroStartPosition.positionInPoints;
  
  CCActionFollow *actionFollow = [CCActionFollow actionWithTarget:self.hero worldBoundary:self.level.boundingBox];
  [self runAction:actionFollow];
  
  // load initial background
  NSString *spriteFrameName = @"backgrounds/anger_background.png";
  CCSpriteFrame* spriteFrame = [CCSpriteFrame frameWithImageNamed:spriteFrameName];
  
  // position backgrounds
  CCSprite *bg1 = [CCSprite spriteWithSpriteFrame:spriteFrame];
  CCSprite *bg2 = [CCSprite spriteWithSpriteFrame:spriteFrame];
  CCSprite *bg3 = [CCSprite spriteWithSpriteFrame:spriteFrame];
  bg1.anchorPoint = ccp(0, 0);
  bg1.position = ccp(0, 0);
  bg2.anchorPoint = ccp(0, 0);
  bg2.position = ccp(bg1.contentSize.width-1, 0);
  bg3.anchorPoint = ccp(0, 0);
  bg3.position = ccp(2*bg1.contentSize.width-1, 0);
  _backgrounds = @[bg1, bg2, bg3];
  
  [self.physicsNode addChild:bg1 z:INT_MIN];
  [self.physicsNode addChild:bg2 z:INT_MIN];
  [self.physicsNode addChild:bg3 z:INT_MIN];

}

#pragma mark - Touch Handling

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  [self.hero.physicsBody.chipmunkObjects[0] eachArbiter:^(cpArbiter *arbiter) {
    if (!_jumped) {
      [self.hero.physicsBody applyImpulse:ccp(0, 700)];
      _jumped = YES;
      [self performSelector:@selector(resetJump) withObject:nil afterDelay:0.3f];
    }
  }];
}

#pragma mark - Game Over

- (void)gameOver {
  CCScene *restartScene = [CCBReader loadAsScene:@"MainScene"];
  CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
  [[CCDirector sharedDirector] presentScene:restartScene withTransition:transition];
}

#pragma mark - Physics

- (void)resetJump {
  _jumped = NO;
}

- (void)fixedUpdate:(CCTime)delta {
  self.hero.physicsBody.velocity = ccp(80, self.hero.physicsBody.velocity.y);
  
  if (CGRectGetMaxY([self.hero boundingBox]) <   CGRectGetMinY([self.level boundingBox])) {
    [self gameOver];
  }
  
  // endless scrolling for backgrounds
  for (CCSprite *bg in _backgrounds) {
    if ([self convertToWorldSpace:bg.position].x < -1 * (bg.contentSize.width)) {
      bg.position = ccp(bg.position.x + (bg.contentSize.width*2)-2, 0);
    }
  }
}

@end
