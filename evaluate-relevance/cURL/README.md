Usage
---

This command will return the result of evaluating the `RELEVANCE` expression passed to the server.

    curl --data-urlencode "relevance=RELEVANCE" --user username:password https://server:port/api/query

[This example](http://bigfix.me/fixlet/details/6116) will create [BaselineComponent](https://forum.bigfix.com/t/sqlite-inspector-read-only-databases/13606/19)s XML from fixlet objects.

    curl --data-urlencode relevance="concatenations %22%22 of (%22<BaselineComponent Name=%2522%22 & ( concatenation %22and%22 of substrings separated by %22%26%22 of item 0 of it) & %22%2522 IncludeInRelevance=%2522%22 & item 1 of it & %22%2522 SourceSiteURL=%2522%22 & item 2 of it & %22%2522 SourceID=%2522%22 & item 3 of it & %22%2522 ActionName=%2522%22 & item 4 of it & %22%2522><ActionScript MIMEType=%2522%22 & item 5 of it & %22%2522>%22 & item 6 of it & %22</ActionScript><SuccessCriteria Option=%2522%22 & item 7 of it & %22%2522>%22 & item 8 of it & %22</SuccessCriteria><Relevance>%22 & item 9 of it & %22</Relevance></BaselineComponent>%22) of (name of it, (it as string as lowercase) of (not success on run to completion of default action of it), url of site of it, (it as string) of id of it, content id of default action of it, script type of default action of it, (%22<![CDATA[%22 & it & %22%5d%5d>%22) of script of default action of it, (if (success on custom relevance of it) then %22CustomRelevance%22 else if (success on original relevance of it) then %22OriginalRelevance%22 else if (success on run to completion of it) then %22RunToCompletion%22 else %22%22) of default action of it, (if (not success on custom relevance of it) then %22%22 else (%22<![CDATA[%22 & it & %22%5d%5d>%22) of (custom success relevance of it)) of default action of it, (%22<![CDATA[%22 & it & %22%5d%5d>%22) of relevance of it) of fixlets whose(name of it does not contain %22(Superseded)%22 AND name of it as lowercase contains %22endpoint manager%22 AND name of it as lowercase contains %22client%22 AND globally visible flag of it) of bes sites whose(%22BES Support%22 = name of it)" --user username:password https://server:port/api/query
    
See [cURL overview](../../README.md#cURL) for more information on using [cURL](http://curl.haxx.se/).

- http://curl.haxx.se/docs/manpage.html#--data-urlencode
