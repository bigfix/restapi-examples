Usage
---

This command will PUT `role.xml` onto the server, updating details of the role whose ID is `35`. 

    curl -X PUT --data-binary @role.xml --user username:password https://server:port/api/role/35

See [cURL overview](../../README.md#cURL) for more information on using [cURL](http://curl.haxx.se/).
