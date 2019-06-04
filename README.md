# UKHO.ChromeDriver.BinarySync -Test

UKHO.ChromeDriver.BinarySync is a PowerShell module that can be used to update ChromeDriver to the correct version according to the version of Chrome that is installed. It contains functionality to create a local cache of the ChromeDriver binaries which are then used to decide which version of ChromeDriver to install.

## Capabilities

- Get the version of Chrome that is currently installed
- Get the version of ChromeDriver that should be installed for the version of Chrome that is currently installed
- Update ChromeDriver to the suggested version
- Create a local cache of the ChromeDriver binaries

## Usage

1. Use the Save-ChromeDriverBinaries function to create a cache of the binaries in a shared location.
1. Use the Update-ChromeDriver function to install the correct version of ChromeDriver on the current machine according to the binaries stored in the shared location.

## Security Disclosure

The UK Hydrographic Office (UKHO) collects and supplies hydrographic and geospatial data for the merchant shipping and the Royal Navy, to protect lives at sea. Maintaining the confidentially, integrity and availability of our services is paramount. Found a security bug? You might be saving a life by reporting it to us at UKHO-ITSO@ukho.gov.uk
