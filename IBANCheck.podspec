Pod::Spec.new do |s|
  s.name         = "IBANCheck"
  s.version      = "0.0.1"
  s.summary      = "Validates a given IBAN agains ISO 13616:2007."
  s.description  = <<-DESC
                   Validate comprises length check (precise for DE, CH and LI)
                   Country Code existence, allowed character set and check digit.
                   DESC
  s.homepage     = "https://github.com/HHuckebein/IBANCheck"
  s.license      = { :type => "MIT", :file => "LICENSE.txt" }
  s.author       = { "Bernd Rabe" => "info@berndrabe.de" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/HHuckebein/IBANCheck.git", :tag => s.version.to_s }
  s.source_files = "IBANCheck", "IBANCheck/IBANCheck.{h,m}"
  s.requires_arc = true
  s.dependency "ISO3661-1Alpha2_objc"
end
