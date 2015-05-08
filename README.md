# DKStickyFooterView
The footer view will stick to the bottom when scroll to the *contentOffset* of max or scroll up.

<img width="50%" src="https://raw.githubusercontent.com/zhangao0086/DKStickyFooterView/master/Preview1.gif"/><img width="50%" src="https://raw.githubusercontent.com/zhangao0086/DKStickyFooterView/master/Preview2.gif"/>

# Easy to use

```objective-c
DKStickyFooterView *footerView = [[DKStickyFooterView alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
[self.tableView addSubview:footerView];
```

## Set *zPosition* if added to UITableView

```objective-c
footerView.layer.zPosition = 1;
```

# Based on Key-Value Observing

```objective-c
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:KEY_PATH_CONTENTOFFSET]) {
        CGFloat newOffsetY = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue].y;
        CGFloat oldOffsetY = [[change valueForKey:NSKeyValueChangeOldKey] CGPointValue].y;
        CGFloat delta = newOffsetY - oldOffsetY;
        
        CGFloat totalDelta = self.beganContentOffset.y - newOffsetY;
        
        [self updateYForContentOffset];
        
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
            [self updateYForContentOffset];
        }];
        
    } else if ([keyPath isEqualToString:KEY_PATH_FRAME]) {
        if (!self.isShow) {
            [self updateYForContentOffset];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

```

# Licence
This code is distributed under the terms and conditions of the <a href="https://github.com/zhangao0086/DKStickyFooterView/master/LICENSE">MIT license</a>.
