//
//  Enemy.m
//  GDC_Demo
//
//  Created by Benjamin Encz on 3/4/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Enemy.h"

@interface Enemy()

@property (assign) NSInteger speed;

@end

@implementation Enemy

- (void)fixedUpdate:(CCTime)delta {
  self.physicsBody.velocity = ccp(self.speed, self.physicsBody.velocity.y);
}

@end