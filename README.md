
# Use-Fluentd
Powershell Modules for installing and managing FluentD. These modules are currently set up to collect windows event logs but can be altered to suit any Fluentd plugins

This repo includes 8 modules to install, alter, and use Fluentd
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
Now we can start installing the module and installing Fluentd
1. In Powershell run this command to install the necessary modules
> TODO
2. Run the install module with your server information. *This is just an example*
> Install-FluentdClient -Server 192.168.1.40 -Servername fluentd-02 -Tag "it.winevt.raw" Port 7777

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

To see if Fluentd is running currently use:
> Get-FluentdStatus
