Usage
---

This command will POST the file `role.xml` to the server to create the new role contained in `role.xml`.

    curl -X POST --data-binary @role.xml --user username:password https://server:port/api/roles

See [cURL overview](../../README.md#cURL) for more information on using [cURL](http://curl.haxx.se/).
