This command will POST the file `operator.xml` to the server to create a
non-master-operator `eddard` with password `winterfell`:

    curl -X POST --data-binary @operator.xml --user username:password https://server:port/api/operators

See [cURL overview](../../README.md#cURL) for more information on using [cURL](http://curl.haxx.se/).
