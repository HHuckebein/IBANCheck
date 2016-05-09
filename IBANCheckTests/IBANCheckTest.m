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
    HC_assertThatBool([IBANCheck validateIBAN:_correctFormattedGermanIBAN], HC_isTrue());
}

- (void)test_correctSuisseIBAN
{
    HC_assertThatBool([IBANCheck validateIBAN:_correctFormattedCH], HC_isTrue());
}

- (void)test_correctInternationalIBAN
{
    HC_assertThatBool([IBANCheck validateIBAN:_correctFormattedInternationalIBAN], HC_isTrue());
}

- (void)test_germanIBANLengthShouldNotExceedMaximumOf22 {
    // given
    NSString *iban = [_correctFormattedGermanIBAN stringByAppendingString:@"0"];
    
    // then
    HC_assertThatBool([IBANCheck validateIBANLength:iban], HC_isFalse());
}

- (void)test_suisseIBANLengthShouldNotExceedMaximumOf21 {
    // given
    NSString *iban = [_correctFormattedCH stringByAppendingString:@"0"];
    
    // then
    HC_assertThatBool([IBANCheck validateIBANLength:iban], HC_isFalse());
}

- (void)test_internationalIBANLengthShouldNotExceedMaximumOf34 {
    // given
    NSString *addOn = [NSString stringWithFormat:@"%@", @(powf(10, (MAX_LENGHT_INT_IBAN - _correctFormattedInternationalIBAN.length)))];
    NSString *iban = [_correctFormattedInternationalIBAN stringByAppendingString:addOn];
    
    // then
    HC_assertThatBool([IBANCheck validateIBANLength:iban], HC_isFalse());
}

- (void)test_thatgermanIBANisKnownCountryCode {
    // then
    HC_assertThatBool([IBANCheck validateIBANCountryCode:_correctFormattedGermanIBAN], HC_isTrue());
}

- (void)test_IBANwithUnknownCountry {
    // given
    NSString *iban = @"XX47212110090000000235698741";
    
    // then
    HC_assertThatBool([IBANCheck validateIBANCountryCode:iban], HC_isFalse());
}

- (void)test_IBANForAllowedCharacterSet01 {
    // given
    NSString *iban = @"XX472121100900000%0235698741";
    
    // then
    HC_assertThatBool([IBANCheck validateIBANAllowedCharacterSet:iban], HC_isFalse());
}

- (void)test_IBANForAllowedCharacterSet02 {
    // given
    NSString *iban = @"ab4721211009000000235698741";
    
    // then
    HC_assertThatBool([IBANCheck validateIBANAllowedCharacterSet:iban], HC_isTrue());
}

- (void)test_formattedIBAN_DE {
    HC_assertThat([IBANCheck formattedIBAN:_correctFormattedGermanIBAN], HC_is(@"DE08 7009 0100 1234 5678 90"));
}

- (void)test_formattedIBAN_CH {
    HC_assertThat([IBANCheck formattedIBAN:_correctFormattedCH], HC_is(@"CH10 0023 00A1 0235 0260 1"));
}

- (void)test_formattedIBAN_INT {
    HC_assertThat([IBANCheck formattedIBAN:_correctFormattedInternationalIBAN], HC_is(@"AL47 2121 1009 0000 0002 3569 8741"));
}

@end
