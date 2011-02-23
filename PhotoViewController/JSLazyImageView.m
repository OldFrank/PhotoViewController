//
//  XBLazyImageView.m
//  Xblaze-iPhone
//
//  Created by James on 26/04/2010.
//  Copyright 2010 JamSoft. All rights reserved.
//

#import "JSLazyImageView.h"
#import "JSPhotoCache.h"
#import <QuartzCore/QuartzCore.h>

@implementation JSLazyImageView

@synthesize imageURL = _imageURL;
@synthesize showSpinner = _showSpinner;

- (id)initWithFrame:(CGRect)frame imageURL:(NSURL *)imageURL
{
	if ((self = [self initWithFrame:frame]))
	{
		self.imageURL = imageURL;
	}
				
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		self.backgroundColor = [UIColor whiteColor];
		self.layer.borderColor = [[UIColor blackColor] CGColor];
		self.layer.borderWidth = 0;
		self.opaque = YES;
		_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[_spinner setHidesWhenStopped:YES];
		[self addSubview:_spinner];
	}
	
	return self;
}

- (void) dealloc
{
	[_connection cancel];
	[_connection release], _connection = nil;
	
	self.imageURL = nil;
	[_spinner release], _spinner = nil;
	[_imageData release], _imageData = nil;
	[super dealloc];
}

- (void)layoutSubviews
{
	[_spinner setCenter:[self center]];
}

- (void)setImageURL:(NSURL *)imageURL
{
	[_imageURL release];
	_imageURL = [imageURL retain];
	
	if (_imageURL)
	{
		self.layer.borderWidth = 1;
	}
	else
	{
		self.layer.borderWidth = 0;	
	}
}

- (void)setImage:(UIImage *)image
{
	[super setImage:image];
	
	if (image)
	{
		self.layer.borderWidth = 1;
	}
	else
	{
		self.layer.borderWidth = 0;	
	}
}

- (void)startLoad
{
	if (self.showSpinner)
		[_spinner startAnimating];
	
	UIImage *anImage = [JSPhotoCache imageForKey:[self.imageURL absoluteString]];
	
	if (anImage)
	{
		[_spinner stopAnimating];
		[self setImage:anImage];
		return;
	}
	
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.imageURL];
	_connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
	_imageData = [[NSMutableData alloc] init];
	[_connection start];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[_spinner stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[_imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[_spinner stopAnimating];
	
	UIImage *anImage = [[UIImage alloc] initWithData:_imageData];
	[_imageData release], _imageData = nil;
	
	if (anImage)
	{
		[JSPhotoCache writeImageToDisk:anImage withKey:[self.imageURL absoluteString]];
		[self setImage:anImage];
	}
	
	[anImage release], anImage = nil;
}

@end
