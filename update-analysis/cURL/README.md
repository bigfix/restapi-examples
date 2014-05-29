Usage
---

This command will PUT the file `analysis.xml` onto the server to update the analysis with ID `37` for a custom site named `Test-Site`.

    curl -X PUT --data-binary @analysis.xml --user username:password https://server:port/api/analysis/custom/Test-Site/37

See [cURL overview](../../README.md#cURL) for more information on using [cURL](http://curl.haxx.se/).
