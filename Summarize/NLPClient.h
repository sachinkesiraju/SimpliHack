//
//  NLPClient.h
//  Summarize
//
//  Created by Sachin Kesiraju on 2/28/15.
//  Copyright (c) 2015 Sachin Kesiraju. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionHandler) (NSArray *resultsArray, NSError *error);

@interface NLPClient : NSObject

+ (void) getSummaryForText: (NSString *) text withCompletion: (CompletionHandler) completion;
+ (void) getKeywordsForText: (NSString *) text withCompletion: (CompletionHandler) completion;
+ (void) getConceptsForText: (NSString *) text withCompletion: (CompletionHandler) completion;
+ (void) getEntitiesForText: (NSString *) text withCompletion: (CompletionHandler) completion;

@end
