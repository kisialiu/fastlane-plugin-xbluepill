# xbluepill plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-xbluepill)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-xbluepill`, add it to your project by running:

```bash
fastlane add_plugin xbluepill
```

## About xbluepill

It is a fastlane plugin that allows to use bluepill (linkedin library) as a fastlane command. It supports Xcode 10.0. There are some differences from other plugins:
- Supports Xcode 10;
- No need to build your project before using the plugin. Builds you project by itself and put xctestrun file automatically;
- Can reset all simulators if needed (removes all current simulators and recreates default from scratch);

Supported options are almost the same as in [Bluepill](https://github.com/linkedin/bluepill). But there are some differences since plugin builds a project by itself:


|   Config Arguments     | Command Line Arguments | Explanation                                                                        | Required | Default value    |
|:----------------------:|:----------------------:|------------------------------------------------------------------------------------|:--------:|:----------------:|
|          `app`         |           -a           | The path to the host application to execute (your .app)                            |     N    | n/a              |
|    `workspace`         |                        | The path to the `.xworkspace` of your project. NOTE: Required if no `project` option set.                                     |     N    | n/a              |
|    `project`           |                        | The path to the `.xcodeproj` of your project. NOTE: Required if no `workspace` option set.                                      |     N    | n/a              |
|    `scheme`            |                        | Your test scheme.                                                                  |     Y    | n/a              |
|    `reset_simulators`  |                        | Delete and re-create all iOS and tvOS simulators.                                  |     N    | false            |
|      `output-dir`      |           -o           | Directory where to put output log files (bluepill only)                            |     Y    | n/a              |
|         config         |           -c           | Read options from the specified configuration file instead of the command line     |     N    | n/a              |
|         device         |           -d           | On which device to run the app.                                                    |     N    | iPhone 6         |
|         exclude        |           -x           | Exclude a testcase in the set of tests to run  (takes priority over `include`).    |     N    | empty            |
|        headless        |           -H           | Run in headless mode (no GUI).                                                     |     N    | off              |
|        xcode-path      |           -X           | Path to xcode.                                                                     |     N    | xcode-select -p  |
|         include        |           -i           | Include a testcase in the set of tests to run (unless specified in `exclude`).     |     N    | all tests        |
|       json-output      |           -J           | Print test timing information in JSON format.                                      |     N    | off              |
|      junit-output      |           -j           | Print results in JUnit format.                                                     |     N    | true             |
|       list-tests       |           -l           | Only list tests in bundle                                                          |     N    | false            |
|        num-sims        |           -n           | Number of simulators to run in parallel. (bluepill only)                           |     N    | 4                |
|      plain-output      |           -p           | Print results in plain text.                                                       |     N    | true             |
|      printf-config     |           -P           | Print a configuration file suitable for passing back using the `-c` option.        |     N    | n/a              |
|      error-retries     |           -R           | Number of times to recover from simulator/app crashing/hanging and continue running|     N    | 5                |
|    failure-tolerance   |           -f           | Number of times to retry on test failures                                          |     N    | 0                |
|    only-retry-failed   |           -F           | When `failure-tolerance` > 0, only retry tests that failed                         |     N    | false            |
|         runtime        |           -r           | What runtime to use.                                                               |     N    | iOS 11.1         |
|      stuck-timeout     |           -S           | Timeout in seconds for a test that seems stuck (no output).                        |     N    | 300s             |
|      test-timeout      |           -T           | Timeout in seconds for a test that is producing output.                            |     N    | 300s             |
|    test-bundle-path    |           -t           | The path to the test bundle to execute (single .xctest).                           |     N    | n/a              |
| additional-unit-xctests|           n/a          | Additional XCTest bundles that is not Plugin folder                                |     N    | n/a              |
|  additional-ui-xctests |           n/a          | Additional XCTUITest bundles that is not Plugin folder                             |     N    | n/a              |
|      repeat-count      |           -C           | Number of times we'll run the entire test suite (used for load testing).           |     N    | 1                |
|        no-split        |           -N           | Test bundles you don't want to be packed into different groups to run in parallel. |     N    | n/a              |
|         quiet          |           -q           | Turn off all output except fatal errors.                                           |     N    | YES              |
|    reuse-simulator     |           n/a          | Enable reusing simulators between test bundles                                     |     N    | NO               |
|       diagnostics      |           n/a          | Enable collection of diagnostics in outputDir in case of test failures             |     N    | NO               |
|          help          |           -h           | Help.                                                                              |     N    | n/a              |
|     runner-app-path    |           -u           | The test runner for UI tests.                                                      |     N    | n/a              |
| screenshots-directory  |           n/a          | Directory where simulator screenshots for failed ui tests will be stored           |     N    | n/a              |
|       video-paths      |           -V           | A list of videos that will be saved in the simulators                              |     N    | n/a              |
|       image-paths      |           -I           | A list of images that will be saved in the simulators                              |     N    | n/a              |


## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin. Try it by cloning the repo, running `fastlane install_plugins` and `bundle exec fastlane test`.

**Note to author:** Please set up a sample project to make it easy for users to explore what your plugin does. Provide everything that is necessary to try out the plugin in this project (including a sample Xcode/Android project if necessary)

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).

## License of Bluepill

BSD 2-CLAUSE LICENSE

Copyright 2016 LinkedIn Corporation.
All Rights Reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

