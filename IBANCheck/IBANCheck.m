#import "IBANCheck.h"
#import <ISO3661-1Alpha2_objc/ISO3661_1alpha2_c.h>

@interface NSString (IBAN)
- (NSString *)ibanTransformedString;
@end

@interface NSMutableString (IBAN)
- (void)ibanTransformCharactersInSet:(NSCharacterSet *)characterSet;
@end

@implementation IBANCheck

static const NSInteger IBAN_LENGTH_DE       = 22;
static const NSInteger IBAN_LENGTH_CH_LI    = 21;
static const NSInteger IBAN_LENGTH_INT      = 34;

static NSInteger _checkSum;

#pragma mark - External Affairs

+ (BOOL)validateIBAN:(NSString *)iban {
    if ([self validateIBANAllowedCharacterSet:iban] == FALSE) { return FALSE; }

    NSString *iIBAN = [iban uppercaseString];
    
    if ([self validateIBANLength:iIBAN] == FALSE) { return FALSE; }
    if ([self validateIBANCountryCode:iIBAN] == FALSE) { return FALSE; }
    
    _checkSum = [[iIBAN substringWithRange:NSMakeRange(2, 2)] integerValue];
    
    return [self ibanModulo9710Check:[self reformatIBAN:iIBAN]];
}

+ (NSString *)formattedIBAN:(NSString *)iban {
    if ([self validateIBAN:iban] == FALSE) { return nil; }
    
    NSMutableString *mString = [[iban uppercaseString] mutableCopy];
    NSInteger index = 4;
    while (index < mString.length) {
        [mString insertString:@" " atIndex:index];
        index += 5;
    }
    return [mString copy];
}

#pragma mark - Helper

+ (NSString *)reformatIBAN:(NSString *)iban {
    NSMutableString *mString = [[iban substringFromIndex:4] mutableCopy];

    [mString ibanTransformCharactersInSet:[self letterSet]];
    
    // character transform follows the formula
    // index of character in alphabet - base character index + 9
    NSString *firstCountryCodeCharacter  = [[iban substringWithRange:NSMakeRange(0, 1)] ibanTransformedString];
    NSString *secondCountryCodeCharacter = [[iban substringWithRange:NSMakeRange(1, 1)] ibanTransformedString];
    
    [mString appendFormat:@"%@%@%@", firstCountryCodeCharacter, secondCountryCodeCharacter, @"00"];
    
    return [mString copy];
}

+ (NSCharacterSet *)letterSet {
    return [NSCharacterSet characterSetWithRange:NSMakeRange((unsigned int)'A', 26)];
}

+ (BOOL)ibanModulo9710Check:(NSString *)iban {
    if (iban.length > 9) {
        NSNumber *value = @([[iban substringToIndex:9] integerValue] % 97);
        return [self ibanModulo9710Check:[[value stringValue] stringByAppendingString:[iban substringFromIndex:9]]];
    }
    NSInteger rest = 98 - [iban integerValue] % 97;
    return rest == _checkSum;
}

+ (BOOL)validateIBANLength:(NSString *)iban {
    NSString *countryCode = [iban substringWithRange:NSMakeRange(0, 2)];
    if ([countryCode isEqualToString:@"DE"]) {
        return iban.length == IBAN_LENGTH_DE;
    }
    else if ([countryCode isEqualToString:@"CH"] || [countryCode isEqualToString:@"LI"]) {
        return iban.length == IBAN_LENGTH_CH_LI;
    }
    else {
        return iban.length <= IBAN_LENGTH_INT;
    }
}

+ (BOOL)validateIBANCountryCode:(NSString *)iban {
    NSString *countryCode = [iban substringWithRange:NSMakeRange(0, 2)];
    return [ISO3661_1alpha2_c knownCodes][countryCode] ? TRUE : FALSE;
}

+ (BOOL)validateIBANAllowedCharacterSet:(NSString *)iban {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES '[0-9a-zA-Z]*'"];
    BOOL result = [predicate evaluateWithObject:iban];
    return result;
}

@end

@implementation NSString (IBAN)

// matches a given character within the range of A-Z
// to 10 .. 35
- (NSString *)ibanTransformedString {
    return [@([self characterAtIndex:0] - [self ibanBase] + 10) stringValue];
}

// index of character A == 1 (one base)
- (unichar)ibanBase {
    return [@"A" characterAtIndex:0];
}

@end

@implementation NSMutableString (IBAN)

// replaces every occurence of characters for the characterSet with
// its transformed value

- (void)ibanTransformCharactersInSet:(NSCharacterSet *)characterSet {
    NSRange range = [self rangeOfCharacterFromSet:characterSet];
    while (range.location != NSNotFound) {
        NSString *outString = [self substringWithRange:range];
        NSString *inString  = [outString ibanTransformedString];
        [self replaceOccurrencesOfString:outString withString:inString options:NSLiteralSearch range:range];
        range = [self rangeOfCharacterFromSet:characterSet];
    }
    
}

@end
