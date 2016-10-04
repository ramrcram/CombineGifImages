//
//  LinkedList.h
//  FloodFillAlgo2
//
//  Created by Gaurav Singh on 10/10/13.
//  Copyright (c) 2013 Gaurav Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FINAL_NODE_OFFSET -1
#define INVALID_NODE_CONTENT nil

//typedef struct PointNode
//{
//    id point;
//    
//} PointNode;

@interface LinkedListStack : NSObject
{
    NSMutableData *nodeCache;
    
    int freeNodeOffset;
    int topNodeOffset;
    int _cacheSizeIncrements;
    
    int multiplier;
}

- (id)initWithCapacity:(int)capacity incrementSize:(int)increment andMultiplier:(int)mul;
- (id)initWithCapacity:(int)capacity;

- (void)pushFrontX:(NSDictionary*)dict;
- (NSDictionary*)popFront:(NSDictionary**)dict;
- (NSDictionary*)popFront;
@end
