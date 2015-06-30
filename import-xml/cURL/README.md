Usage
---

This command will POST `objects.xml` onto the server, importing the provided items in `objects.xml` (`Imported Analysis`, `Imported Fixlet 1` and `Imported Fixlet 2`) into the Custom Site `mySite`.

    curl -X POST --data-binary @objects.xml --user username:password https://server:port/api/import/custom/mySite/

Example
---

 - http://bigfix.me/fixlet/details/6116

---
See [cURL overview](../../README.md#cURL) for more information on using [cURL](http://curl.haxx.se/).
