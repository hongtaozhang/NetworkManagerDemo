//
//  AiromoRequestManager.m
//  Airomo
//
//  Created by Eugene Pankratov on 20.02.12.
//  Copyright (c) 2012 airupt.com. All rights reserved.
//

#import "AiromoRequestManager.h"
#import "Global.h"
#import "NSString+SBJSON.h"
#import "NSObject+SBJSON.h"
#import "NSString+Extensions.m"

@interface AiromoRequestManager (PrivateMethods)
- (void)sendRequest:(NSString *)queryStringOrServiceName withMethod:(NSString *)method andJSONParams:(NSDictionary *)params;
- (void)performCleanup;
@end

@implementation AiromoRequestManager

@synthesize delegate         = _delegate;
@synthesize status           = _status;
@synthesize tag              = _tag;
@synthesize lastActivityTime = _lastActivityTime;
@synthesize timeoutValue     = _timeoutValue;
@synthesize connectionError  = _connectionError;
@synthesize receivedData     = _receivedData;
@synthesize urlString        = _urlString;
@synthesize queryString      = _queryString;

- (id)init
{
    return [self initWithURLString:AIROMO_URL];
}

- (id)initWithURLString:(NSString *)urlString
{
    return [self initWithURLString:urlString andDelegate:nil];
}

- (id)initWithURLString:(NSString *)urlString andDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.lastActivityTime = [NSDate date];
        _timeoutTimer = nil;
        _urlConnection = nil;
        self.delegate = delegate;
        self.status = kAiromoRequestInProgress;
        self.timeoutValue = AIROMO_REQUEST_TIMEOUT;
        self.connectionError = nil;
        self.receivedData = [NSMutableData data];
        self.urlString = urlString;
    }

    return self;
}

#pragma mark - Helper methods

- (void)sendRequest:(NSString *)queryStringOrServiceName withMethod:(NSString *)method andJSONParams:(NSDictionary *)params
{
    NSString *fullURLString = nil;
    if (queryStringOrServiceName == nil) {
        fullURLString = [NSString stringWithString:[NSString encodeHTTPCharactersIn:self.urlString]];
    }
    else {
        NSString *format = @"%@/%@";
        if ([self.urlString hasSuffix:@"/"]) {
            format = @"%@%@";
        }
        fullURLString = [NSString stringWithFormat:format, [NSString encodeHTTPCharactersIn:self.urlString], [NSString encodeHTTPCharactersIn:queryStringOrServiceName]];
    }
    AILOG(@"Requesting url: %@", fullURLString);
    self.queryString = queryStringOrServiceName;
    
	NSURL *url = [NSURL URLWithString:fullURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
														   cachePolicy:NSURLRequestReloadIgnoringCacheData
													   timeoutInterval:AIROMO_REQUEST_TIMEOUT];
    
	[request setHTTPMethod:method];
    if (params != nil && [params count]) {
        [request setHTTPMethod:@"POST"];
        [request addValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
        NSString *json = [params JSONRepresentation];    
        NSData *post = [json dataUsingEncoding:NSUTF8StringEncoding];
        AILOG(@"POST %@", json);
        [request setValue:[NSString stringWithFormat:@"%d", [post length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:post]; 
    }
    [request setTimeoutInterval:AIROMO_REQUEST_TIMEOUT];

    // Init the timer
    _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:AIROMO_REQUEST_TIMEOUT target:self selector:@selector(checkActivity:) userInfo:nil repeats:YES];

    // Turn on indicator
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // Start query
    _urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)performCleanup;
{
    // Cancel connection in case of timeout or manual brake
	if (_status == kAiromoRequestCanceled || _status == kAiromoRequestTimedOut) {
		[_urlConnection cancel];
	}
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Invalidate timer
    if ([_timeoutTimer isValid]) {
        [_timeoutTimer invalidate];
    }
    
    // Perform finishing selectors only when
    if (_status != kAiromoRequestFailed && _status != kAiromoRequestTimedOut && [_delegate respondsToSelector:@selector(requestFinished:)]) {
		[_delegate requestFinished:self];
    }
    
	[_urlConnection release];
	_urlConnection = nil;
}

#pragma mark - Main routines

- (void)sendEmptyPostRequest
{
    [self sendPostRequest:nil];
}

- (void)sendPostRequest:(NSString *)queryString
{
    [self sendRequest:queryString withMethod:@"POST" andJSONParams:nil];
}

- (void)sendPostRequest:(NSString *)queryString withJSONParams:(NSDictionary *)params
{
    [self sendRequest:queryString withMethod:@"POST" andJSONParams:params];
}

- (void)sendEmptyGetRequest
{
    [self sendGetRequest:nil];
}

- (void)sendGetRequest:(NSString *)queryString
{
    [self sendRequest:queryString withMethod:@"GET" andJSONParams:nil];
}

- (void)sendGetRequest:(NSString *)queryString withJSONParams:(NSDictionary *)params
{
    [self sendRequest:queryString withMethod:@"GET" andJSONParams:params];
}

- (void)cancelRequest
{
    _status = kAiromoRequestCanceled;
    [self performCleanup];
}

- (id)encodedResponse
{
    id response = nil;
    if (self.receivedData) {
        NSString *stringReply = (NSString *)[[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
        if (stringReply) {
            if ([stringReply respondsToSelector:@selector(JSONValue)])
                response = [stringReply JSONValue];
            if (response == nil)
                response = [NSString stringWithString:stringReply];
            [stringReply release];
        }
    }
	return response;
}

#pragma mark - Timeout handling features

-(void)checkActivity:(NSTimer *)timer
{
    if ([[NSDate date] timeIntervalSinceDate:self.lastActivityTime] > self.timeoutValue) {
        AILOG(@"Request timeout");
        _status = kAiromoRequestTimedOut;
        if([_delegate respondsToSelector:@selector(requestTimeoutExceeded:)]) {
            [_delegate requestTimeoutExceeded:self];
        }
        [self performCleanup];
    }
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response
{
	// Initial response
	[self.receivedData setLength:0];
    // Update activity
    self.lastActivityTime = [NSDate date];

	NSHTTPURLResponse *httpResponse = [(NSHTTPURLResponse*)response retain];
    
	// Check the status code and respond appropriately.
	switch ([httpResponse statusCode]) {
		case 200: {
			// Got a response so extract any cookies.  The array will be empty if there are none.
			NSDictionary *theHeaders = [httpResponse allHeaderFields];
			NSArray *theCookies = [NSHTTPCookie cookiesWithResponseHeaderFields:theHeaders forURL:[response URL]];
			for (NSHTTPCookie *cookie in theCookies)
			{
                AILOG(@"Cookie: %@", cookie);
			}
			
			break;
		}
		default:
			break;
	}
    
	[httpResponse release];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    // Update activity
    self.lastActivityTime = [NSDate date];
    // And data
	[self.receivedData appendData:data];

    // Execute callback
    if([_delegate respondsToSelector:@selector(requestDataRecieved:)]) {
        [_delegate requestDataRecieved:self];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{	
	_status = kAiromoRequestSuccessfulyCompleted;
	[self performCleanup];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
	_status = kAiromoRequestFailed;
	self.connectionError = error;

    // Execute callback
    if([_delegate respondsToSelector:@selector(requestFailed:)]) {
        [_delegate requestFailed:self];
    }

	[self performCleanup];
}

#pragma mark - NSURLConnectionDelegate methods

// For more details, see following link
// http://stackoverflow.com/questions/933331/how-to-use-nsurlconnection-to-connect-with-ssl-for-an-untrusted-cert/2033823#2033823
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];	
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

#pragma mark - Memory

-(void)dealloc
{
    [_lastActivityTime release];
    [_urlString release];
    [_queryString release];
	[_receivedData release];
	[_connectionError release];
	
	[super dealloc];
}

@end
