//
//  MWCaptionView.m
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 30/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MWCommon.h"
#import "MWCaptionView.h"
#import "MWPhoto.h"

static const CGFloat labelPadding = 10;

// Private
@interface MWCaptionView () {
    id <MWPhoto> _photo;
    UILabel *_label;
    UIButton *_loveButton;
}
@end

@implementation MWCaptionView

- (id)initWithPhoto:(id<MWPhoto>)photo {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)]; // Random initial frame
    if (self) {
        self.userInteractionEnabled = YES;
        _photo = photo;
        self.barStyle = UIBarStyleBlackTranslucent;
        self.tintColor = nil;
        self.barTintColor = nil;
        self.barStyle = UIBarStyleBlackTranslucent;
        [self setBackgroundImage:nil forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [self setupCaption];
        [self setupLoveButton];
    }
    return self;
}

- (void)setupLoveButton {
    // add love button
    _loveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loveButton setImage:[UIImage imageNamed:@"loveNormalSummary"] forState:UIControlStateNormal];
    [_loveButton setTitle:@"30" forState:UIControlStateNormal];
    [_loveButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
    [_loveButton setImage:[UIImage imageNamed:@"loveNormalSummary"] forState:UIControlStateHighlighted];
    [_loveButton addTarget:self action:@selector(loveButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_loveButton sizeToFit];
    _loveButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _loveButton.frame = CGRectMake(self.bounds.size.width - 10, self.bounds.size.height/2 - 20,
                                   60,
                                   40);
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem* loveBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:_loveButton];
    self.items = [NSArray arrayWithObjects:flexible,loveBarButtonItem, nil];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat maxHeight = 9999;
    if (_label.numberOfLines > 0) maxHeight = _label.font.leading*_label.numberOfLines;
    CGSize textSize = [_label.text boundingRectWithSize:CGSizeMake(size.width - labelPadding*2, maxHeight)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:_label.font}
                                                context:nil].size;
    return CGSizeMake(size.width, textSize.height + labelPadding * 2);
}

- (void)setupCaption {
    _label = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(labelPadding, 0,
                                                                      self.bounds.size.width-labelPadding*2 - 50,
                                                                      self.bounds.size.height))];
    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _label.opaque = NO;
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    
    _label.numberOfLines = 0;
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    if ([_photo respondsToSelector:@selector(caption)]) {
        _label.text = [_photo caption] ? [_photo caption] : @" ";
    }
    [self addSubview:_label];
}

- (void)loveButtonDidTapped:(id)sender {
    NSLog(@"loveButtonDidTapped");
}


@end
