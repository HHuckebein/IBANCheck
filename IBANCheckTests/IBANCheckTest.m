//
//  IBANCheck - IBANCheckTest.m
//  Copyright 2015 RABE_IT Services. All rights reserved.
//
//  Created by: Rabe, Bernd
//

    // Class under test
#import "IBANCheck.h"

    // Collaborators

    // Test support
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>

#define MAX_LENGHT_INT_IBAN     34
#define MAX_LENGHT_DE_IBAN      22

@interface IBANCheck ()
+ (BOOL)validateIBANLength:(NSString *)iban;
+ (BOOL)validateIBANCountryCode:(NSString *)iban;
+ (BOOL)validateIBANAllowedCharacterSet:(NSString *)iban;
+ (NSString *)formattedIBAN:(NSString *)iban;
@end

@interface IBANCheckTest : XCTestCase
@property (nonatomic) IBANCheck *sut;
@end

@implementation IBANCheckTest
{
    NSString *_correctFormattedGermanIBAN;
    NSString *_correctFormattedInternationalIBAN;
    NSString *_correctFormattedCH;
}

- (void)setUp {
    _correctFormattedGermanIBAN         = @"DE08700901001234567890";
    _correctFormattedInternationalIBAN  = @"AL47212110090000000235698741";
    _correctFormattedCH                 = @"CH10002300A1023502601";
}

- (void)test_correctGermanIBAN
{
    assertThatBool([IBANCheck validateIBAN:_correctFormattedGermanIBAN], isTrue());
}

- (void)test_correctSuisseIBAN
{
    assertThatBool([IBANCheck validateIBAN:_correctFormattedCH], isTrue());
}

- (void)test_correctInternationalIBAN
{
    assertThatBool([IBANCheck validateIBAN:_correctFormattedInternationalIBAN], isTrue());
}

- (void)test_germanIBANLengthShouldNotExceedMaximumOf22 {
    // given
    NSString *iban = [_correctFormattedGermanIBAN stringByAppendingString:@"0"];
    
    // then
    assertThatBool([IBANCheck validateIBANLength:iban], isFalse());
}

- (void)test_suisseIBANLengthShouldNotExceedMaximumOf21 {
    // given
    NSString *iban = [_correctFormattedCH stringByAppendingString:@"0"];
    
    // then
    assertThatBool([IBANCheck validateIBANLength:iban], isFalse());
}

- (void)test_internationalIBANLengthShouldNotExceedMaximumOf34 {
    // given
    NSString *addOn = [NSString stringWithFormat:@"%@", @(powf(10, (MAX_LENGHT_INT_IBAN - _correctFormattedInternationalIBAN.length)))];
    NSString *iban = [_correctFormattedInternationalIBAN stringByAppendingString:addOn];
    
    // then
    assertThatBool([IBANCheck validateIBANLength:iban], isFalse());
}

- (void)test_thatgermanIBANisKnownCountryCode {
    // then
    assertThatBool([IBANCheck validateIBANCountryCode:_correctFormattedGermanIBAN], isTrue());
}

- (void)test_IBANwithUnknownCountry {
    // given
    NSString *iban = @"XX47212110090000000235698741";
    
    // then
    assertThatBool([IBANCheck validateIBANCountryCode:iban], isFalse());
}

- (void)test_IBANForAllowedCharacterSet01 {
    // given
    NSString *iban = @"XX472121100900000%0235698741";
    
    // then
    assertThatBool([IBANCheck validateIBANAllowedCharacterSet:iban], isFalse());
}

- (void)test_IBANForAllowedCharacterSet02 {
    // given
    NSString *iban = @"ab4721211009000000235698741";
    
    // then
    assertThatBool([IBANCheck validateIBANAllowedCharacterSet:iban], isTrue());
}

- (void)test_formattedIBAN_DE {
    assertThat([IBANCheck formattedIBAN:_correctFormattedGermanIBAN], is(@"DE08 7009 0100 1234 5678 90"));
}

- (void)test_formattedIBAN_CH {
    assertThat([IBANCheck formattedIBAN:_correctFormattedCH], is(@"CH10 0023 00A1 0235 0260 1"));
}

- (void)test_formattedIBAN_INT {
    assertThat([IBANCheck formattedIBAN:_correctFormattedInternationalIBAN], is(@"AL47 2121 1009 0000 0002 3569 8741"));
}

@end
