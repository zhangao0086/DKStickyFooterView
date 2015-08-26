//
//  DKStickyFooterView.m
//  portfolio
//
//  Created by 张雨红 on 15/5/5.
//  Copyright (c) 2015年 DKHS. All rights reserved.
//

#import "DKStickyFooterView.h"

#define KEY_PATH_CONTENTOFFSET      (@"contentOffset")
#define KEY_PATH_FRAME              (@"frame")

#define ANIMATION_DURATION          (0.2)
#define MINIMUM_SCROLLING_LENGTH    (20)

@implementation UIView (DKStickyFrame)

- (CGFloat)x {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)y {
    return CGRectGetMinY(self.frame);
}

- (void)setY:(CGFloat)y {
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (CGFloat)width {
    return CGRectGetWidth(self.frame);
}

- (void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

- (CGFloat)height {
    return CGRectGetHeight(self.frame);
}

@end

////////////////////////////////////////////////////////////////////////////////////////

@interface DKStickyFooterView() 

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) CGPoint beganContentOffset;
@property (nonatomic, assign) BOOL isShow;

@end

@implementation DKStickyFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.isShow = YES;

    self.topBorderColor = [UIColor lightGrayColor];
    self.backgroundColor = [UIColor whiteColor];
    
    self.layer.zPosition = 999;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];

    [self.superview removeObserver:self forKeyPath:KEY_PATH_CONTENTOFFSET context:nil];
    [self.superview removeObserver:self forKeyPath:KEY_PATH_FRAME context:nil];
    [((UIScrollView *)self.superview).panGestureRecognizer removeTarget:self action:@selector(gestureRecognizerStateUpdate:)];
    
    if (newSuperview != nil) {
        assert([newSuperview isKindOfClass:[UIScrollView class]]);
        self.scrollView = (UIScrollView *)newSuperview;
        
        [self.scrollView addObserver:self forKeyPath:KEY_PATH_CONTENTOFFSET options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self.scrollView addObserver:self forKeyPath:KEY_PATH_FRAME options:NSKeyValueObservingOptionNew context:nil];
        [self.scrollView.panGestureRecognizer addTarget:self action:@selector(gestureRecognizerStateUpdate:)];
        
        self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top,
                                                        self.scrollView.contentInset.left,
                                                        self.height,
                                                        self.scrollView.contentInset.right);
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
        
        self.width = self.scrollView.width;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self updateY];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, 0.25);
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), 0.25);
    
    CGContextSetStrokeColorWithColor(context, self.topBorderColor.CGColor);
    CGContextSetLineWidth(context, 0.5);
    
    CGContextStrokePath(context);
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:KEY_PATH_CONTENTOFFSET]) {
        CGFloat newOffsetY = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue].y;
        CGFloat oldOffsetY = [[change valueForKey:NSKeyValueChangeOldKey] CGPointValue].y;
        CGFloat delta = newOffsetY - oldOffsetY;
        
        CGFloat totalDelta = self.beganContentOffset.y - newOffsetY;
        
        [self updateY];
        
        if (ABS(totalDelta) < MINIMUM_SCROLLING_LENGTH || ABS(delta) <= 0.5) {
            return;
        }

        if (delta > 0 && self.scrollView.contentOffset.y > 0.0
            && self.scrollView.contentOffset.y + self.scrollView.height < self.scrollView.contentSize.height) {
            
            if (self.isShow) {
                self.isShow = NO;
            }
        } else {
            if (!self.isShow) {
                self.isShow = YES;
            }
        }
        
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            [self updateY];
        }];
        
    } else if ([keyPath isEqualToString:KEY_PATH_FRAME]) {
        if (!self.isShow) {
            [self updateY];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)gestureRecognizerStateUpdate:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.beganContentOffset = self.scrollView.contentOffset;
    } else if (gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateEnded) {
        self.beganContentOffset = CGPointZero;
    }
}

- (void)updateY {
    if (self.isShow) {
        self.y = self.scrollView.contentOffset.y + self.scrollView.height - self.height;
    } else {
        self.y = self.scrollView.contentOffset.y + self.scrollView.height;
    }
}

- (void)setTopBorderColor:(UIColor *)topBorderColor {
    _topBorderColor = topBorderColor;
    
    [self setNeedsDisplay];
}

@end
