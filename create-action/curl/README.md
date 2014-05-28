Usage
---

This command will POST the file `action.xml` to the server to create and execute the new action contained in `action.xml`.

    curl -X POST --data-binary @action.xml --user username:password https://server:port/api/actions

See [cURL overview](../../README.md#cURL) for more information on using [cURL](http://curl.haxx.se/).
