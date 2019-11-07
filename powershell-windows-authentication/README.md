# Usage

This script describes the steps to successfully use BigFix REST-API with Powershell with Integrated Windows Authentication that as been already use with the BigFix Console and with the IEM cli. This latter has the "-WindowsAuthentication" parameter to interrogate the BigFix REST-API using the windows credentials of the logged operator.
This script uses the same principle to obtain a session token that can be utilized for next requests.

By default we set Powershell to skip SSL certificate checks because is not able to verify the chain of the BigFix server certificate.

The first request aims to retrieve the SPN from the server.
The main function GetBigFixToken return a Kerberos token to authenticate the user and to obtain a session token.
The session token can be now used instead of the Kerberos token in the next requests.

Note: This is just an example of how the same requests can be done directly in Powershell and not a replacement of the IEM cli tool.

# Example

```posh
BESWindowsAuthenticationLogin.ps1 -server localhost
```
