//
//  HelloWorldLayer.m
//  PaddleFX
//
//  Created by Nicholas Kostelnik on 03/03/2011.
//  Copyright Forward 2011. All rights reserved.
//

#import "Scene.h"
#import "Logic.h"
#import "UI.h"

@implementation Scene

+(id) scene
{
	CCScene *scene = [CCScene node];
	Scene *layer = [Scene node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super init] )) {    
    self.isTouchEnabled = YES;
    gameLogic = [[Logic alloc] initWithScene:self];
    [self schedule:@selector(update:) interval:1.0f/120.0f];
    
	}
	return self;
}

- (void)update:(ccTime)dt {
  [gameLogic update:dt]; 
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
  for (UITouch* touch in touches) {
    [gameLogic touchBegan:touch withEvent:event];
  }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
  for (UITouch* touch in touches) {
    [gameLogic touchEnded:touch withEvent:event];
  }
}

@end
