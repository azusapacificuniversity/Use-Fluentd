<#
    .SYNOPSIS
        .SYNOPSIS
        Enables and stops the fluentdwinsvc service. 
    .EXAMPLE
        Enable-Fluentd
#>

function Enable-Fluentd {
    Set-Service -Name fluentdwinsvc -StartupType Automatic
    Start-Service -Name fluentdwinsvc
}
