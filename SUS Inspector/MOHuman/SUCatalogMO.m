//
//  Copyright (c) 2013 Hannes Juutilainen. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//


#import "SUCatalogMO.h"
#import "ReposadoInstanceMO.h"


@interface SUCatalogMO ()

// Private interface goes here.

@end


@implementation SUCatalogMO

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	// Define keys that depend on
    if ([key isEqualToString:@"catalogURLFromInstanceDefaultURL"])
    {
        NSSet *affectingKeys = [NSSet setWithObjects:@"reposadoInstance.reposadoCatalogsBaseURLString", nil];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKeys];
    }
	
    return keyPaths;
}

- (NSString *)title
{
    return self.catalogTitle;
}

- (NSString *)catalogFilename
{
    NSURL *asURL = [NSURL URLWithString:self.catalogURL];
    return [asURL lastPathComponent];
}

- (NSString *)catalogURLAsString
{
    return self.catalogURL;
}

- (NSString *)catalogURLFromInstanceDefaultURL
{
    NSURL *currentURL = [NSURL URLWithString:self.catalogURL];
    
    NSString *parentBaseString;
    if (![self.reposadoInstance.reposadoCatalogsBaseURLString isEqualToString:@""]) {
        parentBaseString = self.reposadoInstance.reposadoCatalogsBaseURLString;
    } else {
        parentBaseString = [[NSUserDefaults standardUserDefaults] stringForKey:@"reposadoCatalogsBaseURL"];
    }
    
    //NSURL *parentBase = [NSURL URLWithString:parentBaseString];
    //NSURL *new = [NSURL URLWithString:[currentURL relativePath] relativeToURL:parentBase];
    NSString *new = [NSString stringWithFormat:@"%@%@", parentBaseString, [currentURL relativePath]];
    return new;
}

@end
