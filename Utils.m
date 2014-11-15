//
//  Utils.m
//  hn
//
//  Created by Marcin Kmieć on 30.10.2014.
//  Copyright (c) 2014 Marcin. All rights reserved.
//

#import "Utils.h"
#import <UIKit/UIKit.h>
#import "NSString+RemoveTag.h"

@implementation Utils

+ (NSString *)timeAgoFromTimestamp:(NSNumber *)timestamp{
    
    int datePosted = [timestamp intValue];
    int timestampNow = [[NSDate date] timeIntervalSince1970];
    int hoursAgo = (timestampNow - datePosted) / 3600;
    int daysAgo = hoursAgo / 24;
    int yearsAgo = daysAgo / 365;
    
    if(yearsAgo != 0){
        if(yearsAgo == 1)
            return [NSString stringWithFormat:@"%d year ago", yearsAgo];
        else
            return [NSString stringWithFormat:@"%d years ago", yearsAgo];
    }

    if(daysAgo != 0){
        if(daysAgo == 1)
            return [NSString stringWithFormat:@"%d day ago", daysAgo];
        else
            return [NSString stringWithFormat:@"%d days ago", daysAgo];
    }
    
    int minutesAgo;
    
    if(hoursAgo == 0){
        minutesAgo = (timestampNow - datePosted) / 60;
        if(minutesAgo == 1)
        return [NSString stringWithFormat:@"%d minute ago", minutesAgo];
        else
        return [NSString stringWithFormat:@"%d minutes ago", minutesAgo];
    }
    else{
        if( hoursAgo == 1)
        return [NSString stringWithFormat:@"%d hour ago", hoursAgo];
        else
        return [NSString stringWithFormat:@"%d hours ago", hoursAgo];
    }

}

#pragma mark - HTML

+ (NSString *)setCSSForLinks:(NSString *)htmlString{
    return [NSString stringWithFormat:@"<head> <style> a{color: #1569C7;text-decoration: none} </style></head> %@",htmlString];
}


+ (NSString *)makeCodeWrapInHTML:(NSString *)htmlString{
    return [htmlString stringByReplacingOccurrencesOfString:@"<pre>" withString:@"<pre style=\"white-space: pre-wrap;\">"];
}

+ (NSString *)makeLongLinksWrapInHTML:(NSString *)htmlString{
    
    return [NSString stringWithFormat:@"<body style=\"-ms-word-break: break-all;word-break: break-all;word-break: break-word;-webkit-hyphens: auto; -moz-hyphens: auto; hyphens: auto;\">%@</body>",
            htmlString];
}

+ (NSString *)setFont:(NSString *)fontName withSize:(int)size inThisPieceOfHTMLCode:(NSString *)htmlString{
   return [NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %i\">%@</span>",
                  fontName,
                  size,
                  htmlString];
}

+ (NSString *)makeThisPieceOfHTMLBeautiful: (NSString *)htmlString withFont:(NSString *)fontName ofSize:(int)size{
    
    
    htmlString = [Utils setFont:fontName withSize:size inThisPieceOfHTMLCode:htmlString];

    htmlString = [Utils makeCodeWrapInHTML:htmlString];
    htmlString = [Utils makeLongLinksWrapInHTML:htmlString];
    htmlString = [Utils setCSSForLinks:htmlString];
    return htmlString;
    
}

#pragma mark - Strings

+ (NSAttributedString *)convertHTMLToAttributedString:(NSString *)string{
    NSString *result = [Utils replaceSpecialCharactersInString:string];
    result = [Utils addNewLinesWhereIndicated:result];
    result = [Utils extractHTMLLinksFrom:result];
    
    NSAttributedString *attributedString = [Utils addAttributesToString:result];

    return attributedString;
}

+ (NSArray *)getStringsInString:(NSString *)string withTag:(NSString *)tag{
    NSString *closingTag = [tag stringByReplacingOccurrencesOfString:@"<" withString:@"</"];
    NSArray *components = [string componentsSeparatedByString:closingTag];
    NSMutableArray *strings= [NSMutableArray new];
    for(int i = 0; i < [components count] - 1; i++){
        
        NSString *singleComponent = components[i];
        
        NSRange r1 = [singleComponent rangeOfString:tag];
        
        if(r1.length == 0){
            continue;
        }
        
        NSRange rSub = NSMakeRange(r1.location + r1.length, singleComponent.length - r1.location - r1.length);
        NSString *subString = [singleComponent substringWithRange:rSub];
        
        [strings addObject:subString];
    }
    
    return strings;
}

+ (NSAttributedString *)addAttributesToString:(NSString *)string{
    
    NSArray *pTagStrings = [Utils getStringsInString:string withTag:@"<i>"];
    NSArray *preCodeTagStrings = [Utils getStringsInString:string withTag:@"<code>"];
    
    string = [string stringByRemovingTag:@"<i>"];
    string = [string stringByRemovingOpeningTag:@"<pre><code>" withClosingTag:@"</code></pre>"];
    
    UIFont *preferredFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    CGFloat preferredFontSize = [preferredFont pointSize] - 1.0;
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:preferredFontSize];
    NSDictionary *attributes= [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    
    for(NSString *singleString in pTagStrings){
        NSRange r1 = [string rangeOfString:singleString];
        
        UIFont *font = [UIFont fontWithName:@"Helvetica-Oblique" size:preferredFontSize];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        [mutableAttributedString addAttributes:attrsDictionary range:r1];
    }
    
    for(NSString *singleString in preCodeTagStrings){
        NSRange r1 = [string rangeOfString:singleString];
        
        UIFont *font = [UIFont fontWithName:@"Courier New" size:preferredFontSize];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        [mutableAttributedString addAttributes:attrsDictionary range:r1];
    }
    
    
    return [mutableAttributedString copy];
    
}

+ (NSString *)extractHTMLLinksFrom:(NSString *)string{
    
    NSArray *components = [string componentsSeparatedByString:@"</a>"];
    
    
    for(int i = 0; i < [components count] - 1; i++){
        
        NSString *singleComponent = components[i];
        
        NSRange r1 = [singleComponent rangeOfString:@"<a"];
        
        if(r1.length == 0){
            continue;
        }
        
        
        NSRange rSub = NSMakeRange(r1.location, singleComponent.length - r1.location);
        NSString *subString = [singleComponent substringWithRange:rSub];
        
        r1 = [subString rangeOfString:@"href=\""];
        NSRange r2 = [subString rangeOfString:@"\" rel"];
        
        if(r1.length == 0 || r2.length == 0){
            continue;
        }
        
        rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
        NSString *url = [subString substringWithRange:rSub];
        
        string = [string stringByReplacingOccurrencesOfString:subString withString:url];

    }

    
     string = [string stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
    
    return string;

    
}


+ (NSString *)addNewLinesWhereIndicated:(NSString *)string{
    
    NSArray *components = [string componentsSeparatedByString:@"<p>"];
    
    
    for(int i = 0; i < [components count] - 1; i++){
        
        NSString *singleComponent = components[i];
        
        NSString *newSingleComponent = [singleComponent stringByAppendingString:@"\n\n"];
        
        string = [string stringByReplacingOccurrencesOfString:singleComponent withString:newSingleComponent];
    }
    
    string = [string stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    
    return string;

}

+ (NSString *)replaceSpecialCharactersInString:(NSString *)string{

    string = [string stringByReplacingOccurrencesOfString:@"&#x27;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&#x2F;" withString:@"/"];
    string = [string stringByReplacingOccurrencesOfString:@"&#x5C;" withString:@"\\"];
    
    
    return string;
}

@end
