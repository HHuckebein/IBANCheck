/* @brief Validates a given IBAN against ISO 13616:2007
  Sanity check is defined by ECBS (European Committee for Banking Standards).
  Calculation according ISO 7064 per Modulo 97-10.
  @ref http://www.iban.de/iban-pruefsumme.html
  @ref http://www.pruefziffernberechnung.de/Originaldokumente/IBAN/Prufziffer_07.00.pdf
  @ref http://en.wikipedia.org/wiki/International_Bank_Account_Number
  IBAN Construction (Germany)
       LL - (Country Code)      2 digits (conforms to ISO 3166-1 alpha-2)
       PZ - (check digit)       2 digits
       BLZ - (sorting code)     8 digits
       KTO - (account number)   10 digits (if shorted head padded with 0)
  International IBAN can have a length for the so called BBAN (Basic
  Banking Account Number, consisting of BLZ and KTO, of 30.
 */

 #import <Foundation/Foundation.h>

@interface IBANCheck : NSObject
@property (nonatomic, readonly) NSInteger checkDigit;

/* Validates a given IBAN for correctness against ISO 13616:2007.
 IBAN can be any international IBAN.
 Validates character set, length, country codes and check digit.
 Currently length precise length check is made for CH, LI and DE.
 @param IBAN
 @result Wether the IBAN conforms to the standard
 */
+ (BOOL)validateIBAN:(NSString *)iban;

/* Formats a given IBAN in groups of 4 characters
   after validation
 @param IBAN
 @result If it is a correct formed IBAN, the formatted IBAN, nil otherwise
 */
+ (NSString *)formattedIBAN:(NSString *)iban;

@end
