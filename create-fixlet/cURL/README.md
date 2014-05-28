Usage
---

This command will POST the `fixlet.xml` file to the server, creating a fixlet
from the operator source `bigfix` with severity `critical` to shut down all
clients with an outdated version.

    curl -X POST --data-binary @fixlet.xml --user username:password https://server:port/api/fixlets/operator/bigfix

See [cURL overview](../../README.md#cURL) for more information on using cURL.
