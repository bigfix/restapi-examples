This command will POST the file `operator.xml` to the server to update the operator named `eddard`:

    curl -X POST --data-binary @operator.xml --user username:password https://server:port/api/operator/eddard

See [cURL overview](../../README.md#cURL) for more information on using [cURL](http://curl.haxx.se/).
