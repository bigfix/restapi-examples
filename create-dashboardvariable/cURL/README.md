Usage
---

This command will POST the file `dashboardvariables.xml` to the server to create the new DashboardVaribles contained in `dashboardvariables.xml`.

    curl -X POST --data-binary @dashboardvariables.xml --user username:password https://server:port/api/dashboardvariables/Odometer.ojo

See [cURL overview](../../README.md#cURL) for more information on using [cURL](http://curl.haxx.se/).
