# ogc-api-processes-neotl-ets
Executable Test Suite for OGC API Processes written in NeoTL

This repository is part of the D179 - Alternative Test OGC API-Processes of [OGC Testbed 17](https://www.ogc.org/projects/initiatives/t17) and sponsored by the [European Space Agency(ESA)](https://www.esa.int).

The repository contains the OGC API Processes Executable Test Suites written in NeoTL that can be executed in the ETF test framework.

## Run the Cloud Workbench

Click **Open in Gitpod** below to open the repository in the online [Gitpod](https://www.gitpod.io/docs) development environment.

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/jonherrmann/ogc-api-processes-neotl-ets)

As the plugin is not yet published, you need to install it in GitPod manually:
- Open the **Extensions** view on the left side
- Open the extensions menu (three dots) located above the extension search input field
- Select **Install from VSIX...**
- Enter **/workspace/ogc-api-processes-neotl-ets/bin/neotl-vsx.vsix** and click on OK.

Once the plugin is released, this step will no longer be necessary.

## Editing tests

Start by opening the [Executable Test Suite](./ProcessesApi-testsuite.neotl). The tests will be executed on the (not yet public) [ETF instance](https://tb17.staging.etf-validator.com/etf-webapp/).

Please also see:

- the [Workbench feature overview](./doc/Workbench.md)
- the [Quick Start Guide](./doc/Writing_tests.md) for writing tests

## Open points

- automated deployment to ETF instance and the description
- documentation
