Usage
---

This command will upload multiple files to the server. Additional files can be added using -F.

	curl --user username:password -F file=@file1.txt -F file=@file2.txt "https://server:port/api/upload"
	
See [cURL overview](../../README.md#cURL) for more information on using [cURL](http://curl.haxx.se/).