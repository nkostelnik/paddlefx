//
//  GameLogic.m
//  Pong
//
//  Created by Nicholas Kostelnik on 16/03/2010.
//  Copyright 2010 Black Art Studios. All rights reserved.
//

#import "Logic.h"

#import "Direction.h"
#import "Paddle.h"
#import "Ball.h"
#import "GameOver.h"
#import "Net.h"
#import "Scene.h"
#import "UI.h"
#import "Sound.h"
#import "GameStats.h"

@implementation Logic

- (id)initWithScene:(Scene*)s {
	isDemo = true;
	isPlaying = false;
	isSinglePlayer = false;
	sound = [[Sound alloc]init];
  scene = s;
  
  player1Paddle = [[Paddle alloc]initWithPosition:CGPointMake(0.0f, -0.7f)];
  [scene addChild:player1Paddle];
  
  player2Paddle = [[Paddle alloc]initWithPosition:CGPointMake(0.0f, 0.7f)];
  [scene addChild:player2Paddle];
  
  ball = [[Ball alloc] initWithPosition:CGPointZero];
  [scene addChild:ball];
  
  net = [[Net alloc] initWithPosition:CGPointMake(-1.0f, 0.0f)];
  [scene addChild:net];
  
  gameOver1 = [[GameOver alloc]initWithPosition:CGPointMake(0.0f, -0.8f)];
  [scene addChild:gameOver1];
  
  gameOver2 = [[GameOver alloc]initWithPosition:CGPointMake(0.0f, 0.8f)];
  [scene addChild:gameOver2];
  
  ui = [[UI alloc]init:self];
  [scene addChild:ui];
  
  [ball demo];

	return self;
}

- (void)player1LeftDown {
  if (!isDemo) {
    [player1Paddle startMoveLeft]; 
  }
}

- (void)player1LeftUp {
  if (!isDemo) {
    [player1Paddle stopMoveLeft];
  }
}

- (void)player1RightDown {
  if (!isDemo) {
    [player1Paddle startMoveRight]; 
  }
}

- (void)player1RightUp {
  if (!isDemo) {
    [player1Paddle stopMoveRight];
  }
}

- (void)player2LeftDown {
  if (!isDemo) {
    [player2Paddle startMoveLeft]; 
  }
}

- (void)player2LeftUp {
  if (!isDemo) {
    [player2Paddle stopMoveLeft];
  }
}

- (void)player2RightDown {
  if (!isDemo) {
    [player2Paddle startMoveRight]; 
  }
}

- (void)player2RightUp {
  if (!isDemo) {
    [player2Paddle stopMoveRight];
  }
}

- (void)onePlayer {
  [ui onePlayer];
  isSinglePlayer = YES;
  [self newGame];
  [GameStats onePlayer];
}

- (void)twoPlayer { 
  [ui twoPlayer];
  isSinglePlayer = FALSE;
  [self newGame];
  [GameStats twoPlayer];
}

- (void)setIsSinglePlayer:(bool)singlePlayer {
	isSinglePlayer = singlePlayer;
}

- (void)runAI {
	int direction = [ball sideOf:player2Paddle];
	
	if (direction == LEFT) {
		[player2Paddle startMoveRight];
	}
	else if (direction == RIGHT) {
		[player2Paddle startMoveLeft];
	}
	else {
		[player2Paddle stop];
	}
}

- (void)resumeUpdates {
	isPlaying = true;
}

- (void)pauseUpdates:(NSTimeInterval)milliseconds {
	isPlaying = false;
	[NSTimer scheduledTimerWithTimeInterval:milliseconds target:self selector:@selector(resumeUpdates) userInfo:nil repeats:FALSE];
}

- (void)newRound:(int) winningPlayer {
	[ball serve:(winningPlayer == PLAYER1) ? 1.0f : -1.0f];
	[self pauseUpdates:1.0f];
}

- (void)newGame {
	isDemo = false;
	isPlaying = true;
	player1Score = 0;
	player2Score = 0;
	[self newRound:PLAYER1];
}

- (bool)hitTestRoundOver:(GameOver*)entity player:(int)player {
	if ([ball hitTestEntity:entity]) {
		if (player == PLAYER1) {
			player1Score += 1;
			[self newRound:PLAYER1];
		}
		if (player == PLAYER2) {
			player2Score += 1;
			[self newRound:PLAYER2];
		}
    [ui setScores:player2Score player2:player1Score];
		return true;
	}
	return false;
}

- (void)hitTest {	
	if([ball hitTestEntity:player1Paddle] ||
	   [ball hitTestEntity:player2Paddle]) {
		if(isPlaying) {
      [sound playHitSound];
		}
	}
	
	if ([ball hitTestSides]) {
		if(isPlaying) {
      [sound playBounceSound];
		}
	}
	
	if ([self hitTestRoundOver:gameOver1 player:PLAYER2] ||
      [self hitTestRoundOver:gameOver2 player:PLAYER1] ) {
		[sound playScoreSound];		
	}
}

- (void)update:(float)deltaMilliseconds {
	[player1Paddle update:deltaMilliseconds];
	[player2Paddle update:deltaMilliseconds];
	
	if (isPlaying || isDemo) {
		[ball update:deltaMilliseconds];
	}
	
	if (isSinglePlayer) {
		[self runAI];
	}
	
	[self hitTest];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
  [ui touchBegan:touch withEvent:event];
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event 
{
  [ui touchEnded:touch withEvent:event];
}


@end
