<#
    .SYNOPSIS
        Restarts the fluentdwinsvc service. 
    .EXAMPLE
        Restart-Fluentd
#>

function Restart-Fluentd {
    Restart-Service -Name fluentdwinsvc
}
