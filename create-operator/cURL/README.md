Usage
---

This command will POST the `operator.xml` file to the server to create a
non-master-operator `hodor` with password `hodor`:

    curl -X POST --data-binary @operator.xml --user username:password https://server:port/api/operators

See [cURL overview](../../README.md#cURL) for more information on using cURL.
