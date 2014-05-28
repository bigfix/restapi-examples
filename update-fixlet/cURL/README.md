Usage
---

This command will PUT the `fixlet.xml` file onto the server, updating a fixlet
on the master action site whose fixlet ID is `37`.

    curl -X PUT --data-binary @fixlet.xml --user username:password https://server:port/api/fixlet/master/37

See [cURL overview](../../README.md#cURL) for more information on using cURL.
