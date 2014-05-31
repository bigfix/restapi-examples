Usage
---

This command will POST the file `analysis.xml` to the server to create a new analysis called `My Custom Analysis' for a custom site named `Test-Site`.

    curl -X POST --data-binary @analysis.xml --user username:password https://server:port/api/analyses/custom/Test-Site

See [cURL overview](../../README.md#cURL) for more information on using [cURL](http://curl.haxx.se/).
