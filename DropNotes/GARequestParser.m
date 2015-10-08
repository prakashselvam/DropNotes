//
//  GARequestParser.m
//  perchline
//
//  Created by prakash on 9/4/14.
//  Copyright (c) 2014 GlobalAnalytics. All rights reserved.
//

#import "GARequestParser.h"
#import "DataManager.h"
#import "AppDelegate.h"

@interface GARequestParser ()
@property (nonatomic, retain) NSString* urlString;
@end

@implementation GARequestParser
@synthesize dict, xmlData, urlConnection, notification, useSecureConnection;
@synthesize data, exception, urlString, JSONparseneeded;

- (void)downloadAndParse:(NSURL *)url {
    done = NO;
    xmlData = [[NSMutableData alloc] init];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
	[theRequest setHTTPMethod: @"POST" ];
	[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    //[theRequest setValue:[DataManager sharedDataManager].iOSVersion forHTTPHeaderField:@"iosversion"];
    [theRequest setValue:@"IOS" forHTTPHeaderField:@"type"];
    //[theRequest setValue:(NSString *)[DataManager sharedDataManager].appVersion forHTTPHeaderField:@"appversion"];
    if(data && [data length] > 0) {
		NSData *myRequestData = [ NSData dataWithBytes: [ data UTF8String ] length: strlen([data UTF8String]) ];
		[theRequest setHTTPBody: myRequestData ];
	}
    // create the connection with the request and start loading the data
    urlConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    //[[AppDelegate sharedAppDelegate] reachabilityChanged:nil];
    if (urlConnection != nil) {
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (!done);
        
		if(JSONparseneeded) {
            xmlData = nil;
        }
		[urlConnection cancel];
    }
    
	[self performSelectorOnMainThread:@selector(postNotification) withObject:nil waitUntilDone:YES];
}

- (void)postNotification {
	if(notification != nil){
		[[NSNotificationCenter defaultCenter] postNotificationName:notification object:nil];
	}
}

- (id)init {
	self = [super init];
	if (self != nil) {
		thread = nil;
	}
    self.JSONparseneeded = YES;
	return self;
}

- (void)runParser:(NSString*)urlStr useSecureConnection:(BOOL)_useSecureConnection {
    exception = nil;
	useSecureConnection = _useSecureConnection;
    self.urlString = nil;
	NSString *base_url = nil;
	[[NSURLCache sharedURLCache] removeAllCachedResponses];
	if ([urlStr rangeOfString:@"http:"].location == NSNotFound && [urlStr rangeOfString:@"https:"].location == NSNotFound) {
	} else {
		base_url = urlStr;
	}
	NSURL *url = [NSURL URLWithString:base_url];
#if DEBUG
	NSLog(@"url - %@",base_url);
	NSLog(@"data - %@",data);
#endif
		if (thread) {
			[thread cancel];
		}
		thread = [[NSThread alloc] initWithTarget:self selector:@selector(downloadAndParse:) object:url];
		[thread start];
}

#pragma mark NSURLConnection Delegate methods
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//	NSString *trustedHost = [[NSURL URLWithString:[DataManager sharedDataManager].secureBaseUrl] host];
//	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//		if ([trustedHost isEqualToString:challenge.protectionSpace.host]) {
//			[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
//		}
//	}
//	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
//}
//
//-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//        NSURL* baseURL;
//#if PROD
//        baseURL = [NSURL URLWithString:[[DataManager sharedDataManager].appConfig objectForKey:@"ProductionURL"]];
//#else
//        baseURL = [NSURL URLWithString:[[DataManager sharedDataManager].appConfig objectForKey:@"SingleboxURL"]];
//#endif
//        if ([challenge.protectionSpace.host isEqualToString:baseURL.host]) {
//#if DEBUG
//            NSLog(@"trusting connection to host %@", challenge.protectionSpace.host);
//#endif
//            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
//        } else {
//#if DEBUG
//            NSLog(@"Not trusting connection to host %@", challenge.protectionSpace.host);
//#endif
//        }
//    }
//    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
//}
//
//- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//	NSString *trustedHost = [[NSURL URLWithString:[DataManager sharedDataManager].secureBaseUrl] host];
//	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//		if ([trustedHost isEqualToString:challenge.protectionSpace.host]) {
//			[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
//		}
//	}
//	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
//}

/*
 Disable caching so that each time we run this app we are starting with a clean slate. You may not want to do this in your application.
 */
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

// Forward errors to the delegate.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	exception = [[NSException alloc] initWithName:[error localizedFailureReason] reason:[error localizedDescription] userInfo:nil];
    done = YES;
}

// Called when a chunk of data has been downloaded.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)aData {
    // Append the downloaded chunk of data.
    [xmlData appendData:aData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *content = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
	@try{
        // Dirty, should be refactored
        if ([content rangeOfString:@"404 Not Found"].location != NSNotFound) {
            @throw [NSException exceptionWithName:@"Error" reason:@"ParsingError" userInfo:nil];
            return;
        }
        
		if([xmlData length]>0) {
#if DEBUG
            NSLog(@"%@",content);
#endif
            if(JSONparseneeded) {
                NSError *e;
                NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: xmlData  options: NSJSONReadingMutableContainers error: &e];
                dict = [JSON mutableCopy];
            }
            
            if (JSONparseneeded) {
                if ([dict objectForKey:@"status"] != nil && [dict objectForKey:@"msg"]!= nil && [[dict objectForKey:@"status"]  isEqual: @"error"] && ([[dict objectForKey:@"msg"]  isEqual: @"Invalid Session."] || [[dict objectForKey:@"msg"]  isEqual: @"Invalid session/required post data not present in the request."])) {
                    //[[AppDelegate sharedAppDelegate] hideProgress];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Session Expired" message:@"Please login to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    //[[AppDelegate sharedAppDelegate] setLoginAsRoot];
                }
            }
        } else{
			@throw [NSException exceptionWithName:@"Error" reason:@"No internet connection detected.  You need an internet connection to use this app." userInfo:nil];
		}
	}
	@catch (NSException *e) {
		exception = e;
	}
    done = YES;
}

@end