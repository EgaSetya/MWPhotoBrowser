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
static const CGFloat widhtLoveButton = 60;

// Private
@interface MWCaptionView () {
    id <MWPhoto> _photo;
    UILabel *_label;
    UIButton *_loveButton;
    UIButton *_downloadButton;
    BOOL _displayActionButtons;
    NSInteger _totalLove;
    BOOL _isLoved;
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
        if ([_photo respondsToSelector:@selector(displayActionButtons)]) {
            if ([_photo displayActionButtons]) {
                _displayActionButtons = YES;
            }
        }
        if ([_photo respondsToSelector:@selector(totalLove)]) {
            _totalLove = [_photo totalLove];
        }
        if ([_photo respondsToSelector:@selector(isLoved)]) {
            _isLoved = [_photo isLoved];
        }
        [self setupCaption];
        if (_displayActionButtons) {
            [self setupActionsButtons];
        }
        
        if (_totalLove > 0) {
            [self updateLoveButtonWithTotalLove:_totalLove isLoved:_isLoved];
        }
        
    }
    return self;
}

- (void)setupActionsButtons {
    
    // download button
    _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_downloadButton setImage:[UIImage imageNamed:@"downloadSummary"] forState:UIControlStateNormal];
    [_downloadButton setImage:[UIImage imageNamed:@"downloadSummary"] forState:UIControlStateHighlighted];
    [_downloadButton setTitle:@"Download" forState:UIControlStateNormal];
    [[_downloadButton titleLabel] setFont:[UIFont fontWithName:@"SourceSansPro-SemiBold" size:16]];
    [_downloadButton addTarget:self action:@selector(downloadButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_downloadButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 0.0)];
    [_downloadButton sizeToFit];
    _downloadButton.frame = CGRectMake(0, self.bounds.size.height/2 - 20,
                                       100,
                                       30);
    
    // add love button
    _loveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loveButton setImage:[UIImage imageNamed:@"loveNormalSummary"] forState:UIControlStateNormal];
    [_loveButton setTitle:@"" forState:UIControlStateNormal];
    [_loveButton.titleLabel setFont:[UIFont fontWithName:@"Calibre-Medium" size:14]];
    [_loveButton setImage:[UIImage imageNamed:@"loveNormalSummary"] forState:UIControlStateHighlighted];
    [_loveButton addTarget:self action:@selector(loveButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_loveButton sizeToFit];
    _loveButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    _loveButton.frame = CGRectMake(0, self.bounds.size.height/2 - 20,
                                   widhtLoveButton,
                                   40);
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem* loveBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:_loveButton];
    UIBarButtonItem* downloadBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_downloadButton];
    self.items = [NSArray arrayWithObjects:flexible,loveBarButtonItem, downloadBarButtonItem, nil];
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
    if (_displayActionButtons) {
        _label = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(labelPadding, 0,
                                                                          self.bounds.size.width - labelPadding*2 - widhtLoveButton - 40,
                                                                          self.bounds.size.height))];
    } else {
        _label = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(labelPadding, 0,
                                                                          self.bounds.size.width-labelPadding*2,
                                                                          self.bounds.size.height))];
    }
    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _label.opaque = NO;
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    
    _label.numberOfLines = 0;
    _label.textColor = [UIColor whiteColor];
    _label.font = [UIFont fontWithName:@"Calibre-Medium" size:14];
    if ([_photo respondsToSelector:@selector(caption)]) {
        _label.text = [_photo caption] ? [_photo caption] : @" ";
    }
    [self addSubview:_label];
}

- (void)updateLoveButtonWithTotalLove:(NSInteger)totalLove isLoved:(BOOL)isLoved {
    if (_loveButton) {
        if (totalLove == 0) {
            return;
        }
        [_loveButton setTitle:[NSString stringWithFormat:@"%ld", (long)totalLove] forState:UIControlStateNormal];
        if (isLoved) {
            [_loveButton setImage:[UIImage imageNamed:@"love_selected"] forState:UIControlStateNormal];
        } else {
            [_loveButton setImage:[UIImage imageNamed:@"loveNormalSummary"] forState:UIControlStateNormal];
        }
    }
}

- (void)loveButtonDidTapped:(id)sender {
    if (self.captionDelegate && [self.captionDelegate respondsToSelector:@selector(loveButtonDidClicked:)]) {
        [self.captionDelegate loveButtonDidClicked:_photo];
    }
}

- (void)downloadButtonDidTapped:(id)sender {
    if (self.captionDelegate && [self.captionDelegate respondsToSelector:@selector(downloadButtonDidClicked:)]) {
        [self.captionDelegate downloadButtonDidClicked:_photo];
    }
}


@end
