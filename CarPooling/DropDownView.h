//
//  DropDownView.h
//  CustomTableView
//
//  Created by Ameya on 19/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BLENDIN,
	GROW,
	BOTH
} AnimationType;


@protocol DropDownViewDelegate

@required

-(void)dropDownCellSelected:(NSInteger)returnIndex;

@end


@interface DropDownView : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    
	UITableView *uiTableView;
	
	NSArray *arrayData;
	
	CGFloat heightOfCell;
	
	CGFloat paddingLeft;
	
	CGFloat paddingRight;
	
	CGFloat paddingTop;
	
	CGFloat heightTableView;
	
	UIView *refView;
	
	
    
	
	NSInteger animationType;
	
	CGFloat open;
	
	CGFloat close;
	
}

@property (nonatomic,assign) id<DropDownViewDelegate> delegate;

@property (nonatomic,retain)UITableView *uiTableView;

@property (nonatomic,retain) NSArray *arrayData;

@property (nonatomic) CGFloat heightOfCell;

@property (nonatomic) CGFloat paddingLeft;

@property (nonatomic) CGFloat paddingRight;

@property (nonatomic) CGFloat paddingTop;

@property (nonatomic) CGFloat heightTableView;

@property (nonatomic,retain)UIView *refView;

@property (nonatomic) CGFloat open;

@property (nonatomic) CGFloat close;

@property (nonatomic,strong)NSString *classID;

- (id)initWithArrayData:(NSArray*)data cellHeight:(CGFloat)cHeight heightTableView:(CGFloat)tHeightTableView paddingTop:(CGFloat)tPaddingTop paddingLeft:(CGFloat)tPaddingLeft paddingRight:(CGFloat)tPaddingRight refView:(UIView*)rView animation:(AnimationType)tAnimation  openAnimationDuration:(CGFloat)openDuration closeAnimationDuration:(CGFloat)closeDuration;

- (id)initWithArrayDatas:(NSArray*)data cellHeight:(CGFloat)cHeight heightTableView:(CGFloat)tHeightTableView x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width refView:(UIView*)rView animation:(AnimationType)tAnimation openAnimationDuration:(CGFloat)openDuration closeAnimationDuration:(CGFloat)closeDuration;
-(void)closeAnimation;

-(void)openAnimation;

@end
