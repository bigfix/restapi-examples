Usage
---

This command will POST the `operator.xml` file to the server to create a
non-master-operator `hodor` with password `hodor`:

    curl -X POST --data-binary @operator.xml --user username:password https://server:port/api/operators

Note
---

For the `curl` command to work successfully:

* `username` must be the username of a master operator.
* `password` must be their password.
* `server` must be the hostname of your root server.
* `port` must be the port of your root server. By default, this is 52311.

Also, you need to either specify `--insecure` to tell curl to disable HTTPS
authentication, or install a
[custom HTTPS certificate](http://www-01.ibm.com/support/docview.wss?uid=swg21505848)
for the server and use the `--cacert` option.
