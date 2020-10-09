
# Use-Fluentd
This is a Powershell Module for installing and managing FluentD. These modules are currently set up to collect windows event logs but can be altered to suit any Fluentd plugins

This repo includes 8 modules to install, configure, and use Fluentd
1. [Disable-Fluentd](https://github.com/azusapacificuniversity/Use-Fluentd/blob/main/Disable-Fluentd.psm1)
2. [Enable-Fluentd](https://github.com/azusapacificuniversity/Use-Fluentd/blob/main/Enable-Fluentd.psm1)
3. [Get-FluentdStatus](https://github.com/azusapacificuniversity/Use-Fluentd/blob/main/Get-FluentdStatus.psm1)
4. [Install-Fluentd](https://github.com/azusapacificuniversity/Use-Fluentd/blob/main/Install-Fluentd.psm1)
5. [Restart-Fluentd](https://github.com/azusapacificuniversity/Use-Fluentd/blob/main/Restart-Fluentd.psm1)
6. [Set-FluentdConfig](https://github.com/azusapacificuniversity/Use-Fluentd/blob/main/Set-FluentdConfig.psm1)
7. [Uninstall-Fluentd](https://github.com/azusapacificuniversity/Use-Fluentd/blob/main/Uninstall-Fluentd.psm1)
8. [Use-Fluentd](https://github.com/azusapacificuniversity/Use-Fluentd/blob/main/Use-Fluentd.psd1)

## Installing Fluentd
In order to properly run the Install-Fluentd module, Powershell 5.1 must be [installed](https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/wmf/setup/install-configure?view=powershell-7).
Now we can start can install the module through Powershell Gallery
1. In Powershell run this command to install the necessary modules
> Install-Module -Name Use-Fluentd
2. Import the module into your session
> Import-Module Use-Fluentd
3. Download the msi from Treasure Data Inc. and configure with your server information. *This is just an example*
> Install-Fluentd -Server 192.168.1.40 -Servername fluentd-02 -Tag "it-winevt.raw" Port 7777
>> Port defaults to 443 & the Tag defaults to winevt.raw

After installation, Fluentd should be up and running.
### Configure Fluentd
This configuration is currently set up using the widows_eventlog2 plugin to check windows logs, but if you wish to change it you can either alter the config file at
> C:\opt\td-agent\etc\td-agent

Or you can edit the **Set-FluentdConfig** module and run it in PS when you are finished
### Uninstall Fluentd
If you no longer wish Fluentd to be on your machine simple use:
> Uninstall-Fluentd

and it will be completley removed from your computer
## Running Fluentd
You can start or stop Fluentd at any time using the following modules:
> Enable-Fluentd
or
Disable-Fluentd

To see information about Fluentd's status and configuration, you can use :
> Get-FluentdStatus

Here is a sample output from that command:
```
Fluentd Details:
Version: 4.0.1
Server:  192.168.1.40
Port:  7777
Tags:  it.winevt.raw
State: Running
```
## Contributing
If you're interested in contributing to this project, we would be honored and happy to have your help. If this is your first project, and you're a little confused on how to get started, be sure to check out [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/) for an overview of good habits, and the Github documentation on [How to create a Pull Request](https://help.github.com/articles/creating-a-pull-request/) for the technical bits.

It can be scary at first, but don't worry - you'll do fine.

#### Please submit all pull requests to the azusapacificuniversity/Use-Fluentd repository in the develop branch!

As you're working on bug-fixes or features, please break them out into their own feature branches and open the pull request against your feature branch. It makes it much easier to decipher down the road, as you open multiple pull requests over time, and makes it much easier for us to approve pull requests quickly.

Another request is that you do not change the current requirements to running this program. An example, is that you might create a new function to get data that is useful to your organization. Our request is that that function isn't required to run natively or is enabled by default, but rather is available to users if they configure their version for it.

#### Pull Request Guidelines:

A good commit message should describe what changed and why. Use-Fluentd hopes to use semantic commit messages to streamline the release process and easily generate changelogs between versions.

Before a pull request can be merged, it must have a pull request title with a semantic prefix.

Examples of commit messages with semantic prefixes:

    Fixed #<issue number>: Fixes Get-FLuentdStatus for X Bug.
    Added #<issue number>: add Get-Config to view the current config.

Please reference the issue or feature request your PR is addressing. Github will automatically link your PR to the issue, which makes it easier to follow the bugfix/feature path in the future.

Whenever possible, please provide a clear summary of what your PR does, both from a technical perspective and from a functionality perspective.

When Contributing, please understand that after a change is submitted, the modules must be resubmitted to Powershell to change the official module, but please feel free to use it in your own builds once you feel confident it works

#### Thank you and we look forward to your contributions
