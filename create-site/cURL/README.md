Usage
---

This command will POST the file `site.xml` to the server to create the new CustomSite contained in `site.xml`.

    curl -X POST --data-binary @site.xml --user username:password https://server:port/api/sites

See [cURL overview](../../README.md#cURL) for more information on using [cURL](http://curl.haxx.se/).
