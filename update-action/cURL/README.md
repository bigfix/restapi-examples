Usage
---

To update an action, you should first stop the action you want to update:

    curl -X POST --user username:password https://server:port/api/action/ACTIONID/stop

where `ACTIONID` is the ID of the action to be updated. Then GET that action and store it in `action.xml` for editing:

    curl --user username:password https://server:port/api/action/ACTIONID > action.xml

After updating `action.xml`, [POST the new action](../../create-action/cURL/README.md). The original action can be optionally deleted.


See [cURL overview](../../README.md#cURL) for more information on using cURL.