//
//  OCTNotification.m
//  OctoKit
//
//  Created by Josh Abernathy on 1/22/13.
//  Copyright (c) 2013 GitHub. All rights reserved.
//

#import "OCTNotification.h"
#import "NSValueTransformer+OCTPredefinedTransformerAdditions.h"
#import "OCTRepository.h"

@implementation OCTNotification

#pragma mark MTLModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:@{
		@"title": @"subject.title",
		@"threadURL": @"url",
		@"subjectURL": @"subject.url",
		@"type": @"subject.type",
		@"repository": @"repository",
		@"lastUpdatedDate": @"updated_at",
	}];
}

+ (NSValueTransformer *)threadURLJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)subjectURLJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)repositoryJSONTransformer {
	return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:OCTRepository.class];
}

+ (NSValueTransformer *)lastUpdatedDateJSONTransformer {
	return [NSValueTransformer valueTransformerForName:OCTDateValueTransformerName];
}

+ (NSValueTransformer *)typeJSONTransformer {
	NSDictionary *typesByName = @{
		@"Issue": @(OCTNotificationTypeIssue),
		@"PullRequest": @(OCTNotificationTypePullRequest),
		@"Commit": @(OCTNotificationTypeCommit),
	};

	return [MTLValueTransformer transformerWithBlock:^(NSString *name) {
		// If it's some unknown type, let's just pretend it's an issue for now.
		return typesByName[name] ?: @(OCTNotificationTypeIssue);
	}];
}

@end