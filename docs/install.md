<h1>Install</h1>

The validator has been tested against [DITA-OT 3.x](http://www.dita-ot.org/download). It is recommended that you upgrade to the latest version. Running the validator plug-in against DITA-OT 1.8.5 or earlier versions of DITA-OT will not work as it uses the newer `getVariable` template. To work with DITA-OT 1.8.5 this would need to be refactored to use `getMessage`. The validator can be run safely against DITA-OT 2.x.

Installing DITA-OT
------------------

The DITA Validator is a plug-in for the DITA Open Toolkit.

-  Full installation instructions for downloading DITA-OT can be found [here](https://www.dita-ot.org/3.2/topics/installing-client.html).

    1.  Download the `dita-ot-3.2.zip` package from the project website at [dita-ot.org/download](https://www.dita-ot.org/download)
    2.  Extract the contents of the package to the directory where you want to install DITA-OT.
    3.  **Optional**: Add the absolute path for the `bin` directory to the _PATH_ system variable.
This defines the necessary environment variable to run the `dita` command from the command line.

```bash
curl -LO https://github.com/dita-ot/dita-ot/releases/download/3.2/dita-ot-3.2.zip
unzip -q dita-ot-3.2.zip
rm dita-ot-3.2.zip
```

Installing the Plug-in
----------------------

-  Run the plug-in installation command:

```console
dita -install https://github.com/jason-fox/com.here.validate.svrl/archive/master.zip
```

The `dita` command line tool requires no additional configuration.