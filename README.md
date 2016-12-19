# HQliquidView-master

![](https://github.com/hosten1/HQliquidView-master/blob/master/HQliquidView/recode.gif)  

防qq小红点 本人只做了修改

#使用方法
```
       HQliquidButton *redPoint = [[HQliquidButton alloc] initWithLocationCenter:CGPointMake(self.view.bounds.size.width-30,20)];
        redPoint.maxTouchDistance = 30;
        redPoint.bagdeLableWidth = 18;
        redPoint.maxDistance = 100;
        redPoint.bagdeNumber = num;
        [cell.contentView addSubview:redPoint];
        redPoint.dragLiquidBlock = ^(HQliquidButton *liquid) {
            if (liquid) {
               
                NSLog(@"hosten HQliquidButton block 这里处理需要的信息");
            }
        };
     
    }


```
*隐藏和显示和普通view处理相同*

例如：
```

redPoint.hiddent = YES;
```
