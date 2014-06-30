A collection of examples to demonstrate the usage of the IBM Endpoint Manager
RESTAPI.

cURL
===

Options
---

For the `curl` commands to work successfully:

* `username` must be your username.
* `password` must be your password.
* `server` must be the hostname of your root server.
* `port` must be the port of your root server. By default, this is 52311.

Security
---

In order for curl to secure the connection to the server, you must install a
[custom HTTPS certificate](http://www-01.ibm.com/support/docview.wss?uid=swg21505848)
and use the `--cacert` option.

Alternatively, you can use the `--insecure` option to disable HTTPS
certificate verification. This is not recommended.

Support
===
Any issues or questions regarding this software should be filed via [GitHub issues](https://github.com/bigfix/restapi-examples/issues).
