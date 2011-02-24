//
//  XBLazyImageView.h
//  Xblaze-iPhone
//
//  Created by James on 26/04/2010.
//  Copyright 2010 JamSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JSLazyImageView : UIImageView {

	NSURL *_imageURL;
	UIActivityIndicatorView *_spinner;
	NSURLConnection *_connection;
	NSMutableData *_imageData;
	
	BOOL _showSpinner;
	BOOL _showBorder;
	BOOL _isLoading;
}

@property (nonatomic, retain) NSURL *imageURL;
@property (nonatomic, assign) BOOL showSpinner;
@property (nonatomic, assign) BOOL showBorder;
@property (nonatomic, assign) BOOL isLoading;

- (id)initWithFrame:(CGRect)frame imageURL:(NSURL *)imageURL;
- (void)startLoad;
- (void)cancelLoad;

@end
