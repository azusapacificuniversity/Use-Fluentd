<#
    .SYNOPSIS
        Disables and stops the fluentdwinsvc service. 
    .EXAMPLE
        Disable-Fluentd
#>

function Disable-Fluentd {
    Set-Service -Name fluentdwinsvc -StartupType Disabled
    Stop-Service -Name fluentdwinsvc
}
