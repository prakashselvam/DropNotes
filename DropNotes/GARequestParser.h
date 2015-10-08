//
//  GARequestParser.h
//  perchline
//
//  Created by prakash on 9/4/14.
//  Copyright (c) 2014 GlobalAnalytics. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The GARequestParser class is aimed to load data from the specified URL, make parsing and manage data.
 */
@interface GARequestParser : NSObject {
//	NSMutableData *xmlData; /**< Data downloaded from specified URL */
    BOOL done; /**< A flag to indicate whether the data is loaded and parsed or not */
//    NSURLConnection *urlConnection; /**< Used to create a connection to the server */
//	NSMutableDictionary *dict; /**< Parsed data that was loaded from specified URL  */
//	NSString *notification; /**< A notification, which is sent at the end of loading and parsing data */
//	NSString *data; /**< Data that is sent with the request */
//	BOOL useSecureConnection; /**< A flag to indicate whether to use secure connection or not */
	NSThread *thread; /**< A background thread for loading data */
//    BOOL JSONparseneeded;
}

@property (nonatomic, retain) NSMutableDictionary *dict;
@property (nonatomic, retain) NSString *notification;
@property (nonatomic, retain) NSString *data;
@property (nonatomic, retain) NSMutableData *xmlData;
@property (nonatomic, retain) NSURLConnection *urlConnection;
@property (nonatomic, retain) NSException *exception;
@property BOOL useSecureConnection;
@property BOOL JSONparseneeded;

/**
 * A class constructor.
 * @return id an instance of the class
 */
- (id)init;

/**
 * Called in the background. Creates the connection and starts loading the data in the main thread.
 * Waits until the data is loaded and parsed and sends notification.
 * @param url a NSURL object
 */
- (void)downloadAndParse:(NSURL *)url;

/**
 * Sends a notification, if specified
 */
- (void)postNotification;

/**
 * Inits data for connection and calls downloadAndParse in the background.
 * @param urlStr a NSString object
 * @param _useSecureConnection a BOOl argument
 */
- (void)runParser:(NSString*)urlStr useSecureConnection:(BOOL)_useSecureConnection;

/**
 * A NSURLConnection delegate method. Sent to determine whether the delegate is able to respond to the form of authentication of a protection space.
 * @param connection a NSURLConnection object. A connection sending a message.
 * @param protectionSpace a NSURLProtectionSpace object. A protection space that generates an authentication challenge.
 */
//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;

/**
 * A NSURLConnection delegate method. Sent when a connection must authenticate a challenge in order to download its request.
 * @param connection a NSURLConnection object. The connection sending the message.
 * @param challenge a NSURLAuthenticationChallenge object. The challenge that connection must authenticate in order to download its request.
 */
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

/**
 * A NSURLConnection delegate method. Sent when a connection cancels an authentication challenge.
 * @param connection a NSURLConnection object. The connection sending the message.
 * @param challenge a NSURLAuthenticationChallenge object. The challenge that was canceled.
 */
//- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

/**
 * A NSURLConnection delegate method. Sent before the connection stores a cached response in the cache, to give the delegate an opportunity to alter it.
 * @param connection a NSURLConnection object. The connection sending the message.
 * @param cachedResponse a NSCachedURLResponse object. The proposed cached response to store in the cache.
 */
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse;

/**
 * A NSURLConnection delegate method. Sent when a connection fails to load its request successfully.
 * @param connection a NSURLConnection object. The connection sending the message.
 * @param error a NSError object. An error object containing details of why the connection failed to load the request successfully.
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

/**
 * A NSURLConnection delegate method. Sent as a connection loads data incrementally.
 * @param connection a NSURLConnection object. The connection sending the message.
 * @param aData a NSData object. The newly available data. The delegate should concatenate the contents of each data object delivered to build up the complete data for a URL load.
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)aData;

/**
 * A NSURLConnection delegate method. Sent when a connection has finished loading successfully.
 * Checks the downloaded data for errors and makes parsing.
 * @param connection a NSURLConnection object. The connection sending the message.
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end