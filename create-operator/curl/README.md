This command will POST the operator.xml file to the server to create a
non-master-operator `hodor` with password `hodor`.

    curl -X POST --data-binary @operator.xml --user bigfix:bigfix https://localhost:52311/api/operators
