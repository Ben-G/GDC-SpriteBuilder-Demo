//
//  Level.h
//  GDC_Demo
//
//  Created by Benjamin Encz on 3/4/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Level : CCNode

@property (nonatomic, assign) NSInteger levelSpeed;
@property (nonatomic, copy) NSString *nextLevelName;

@end
