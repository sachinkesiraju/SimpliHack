//
//  NLPClient.m
//  Summarize
//
//  Created by Sachin Kesiraju on 2/28/15.
//  Copyright (c) 2015 Sachin Kesiraju. All rights reserved.
//

#import "NLPClient.h"

static NSString *baseURL = @"https://api.aylien.com/api/v1";
static NSString *appID = @"250f98e8";
static NSString *key = @"e78fe45c85448e212d3a1eb4a990da93";

@implementation NLPClient

+ (void) getSummaryForText:(NSString *)text withCompletion:(CompletionHandler)completion //alyien
{
    NSString *url = [NSString stringWithFormat:@"%@/summarize?text=%@", baseURL, [self getEncodedString:text]];
    NSLog(@"url %@", url);
    __block NSArray *summary;
    __block NSError *jError;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    [self performNetworkRequestWithRequest:request withCompletion:^(NSDictionary *result, NSURLResponse *response, NSError *error)
     {
         jError = error;
         NSLog(@"Summary json %@", result);
         if(result[@"sentences"])
         {
             summary = result[@"sentences"];
             completion(summary, jError);
         }
     }];
}

+ (void) getEntitiesForText:(NSString *)text withCompletion:(CompletionHandler)completion //alchemy
{
    NSString *url = [NSString stringWithFormat:@"http://access.alchemyapi.com/calls/text/TextGetRankedNamedEntities?apikey=4aa1a621abe339cc8b6571257e7dff067f00de9d&text=%@&outputMode=json", [self getEncodedString:text]];
    __block NSArray *summary;
    __block NSError *jError;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self performNetworkRequestWithRequest:request withCompletion:^(NSDictionary *result, NSURLResponse *response, NSError *error)
     {
         jError = error;
         if(result[@"entities"])
         {
             summary = result[@"entities"];
             completion(summary, jError);
         }
     }];
}

+ (void) getKeywordsForText:(NSString *)text withCompletion:(CompletionHandler)completion //alchemy
{
    NSString *url = [NSString stringWithFormat:@"http://access.alchemyapi.com/calls/text/TextGetRankedKeywords?apikey=4aa1a621abe339cc8b6571257e7dff067f00de9d&text=%@&outputMode=json", [self getEncodedString:text]];
    __block NSArray *keywords;
    __block NSError *jError;
    NSLog(@"Called this method with url %@", url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self performNetworkRequestWithRequest:request withCompletion:^(NSDictionary *result, NSURLResponse *response, NSError *error)
     {
         jError = error;
         keywords = result[@"keywords"];
         completion(keywords, jError);
     }];
}

+ (void) getConceptsForText:(NSString *)text withCompletion:(CompletionHandler)completion //Alchemy API
{
    NSString *url = [NSString stringWithFormat:@"http://access.alchemyapi.com/calls/text/TextGetRankedConcepts?apikey=4aa1a621abe339cc8b6571257e7dff067f00de9d&text=%@&outputMode=json", [self getEncodedString:text]];
    __block NSArray *concepts;
    __block NSError *jError;
    NSLog(@"Called this method with url %@", url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self performNetworkRequestWithRequest:request withCompletion:^(NSDictionary *result, NSURLResponse *response, NSError *error)
     {
         jError = error;
         concepts = result[@"concepts"];
         completion(concepts, jError);
     }];
}

+ (NSString *) getEncodedString: (NSString *) stringToEncode
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)stringToEncode,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));
    return encodedString;
}

+ (void) performNetworkRequestWithRequest: (NSMutableURLRequest *) request withCompletion:(void (^)(NSDictionary *, NSURLResponse *, NSError *))completion; //Aylien only
{
    NSLog(@"Request %@", request);
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if(!error)
         {
             NSError *jsonError = nil;
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
             if(!jsonError)
             {
                 completion(json, response, jsonError);
             }
         }
         else
         {
             NSLog(@"Error %@", error);
         }
     }];
}

@end
