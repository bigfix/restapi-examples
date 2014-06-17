Usage
---

This command will PUT 'site.xml' onto the server, updating the example site's description.

	curl -X PUt --data-binary @site.xml --user username:password https://server:port/api/site/{site type}/{site name}
	
See [cURL overview](../../README.md#cURL) for more information on using [cURL](http://curl.haxx.se/).
