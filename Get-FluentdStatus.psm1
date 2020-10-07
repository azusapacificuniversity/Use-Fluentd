<#
    .SYNOPSIS
        .SYNOPSIS
        Provides information about Fluentd on the system.  
    .EXAMPLE
        Get-FluentdStatus
#>

function Get-FluentdStatus {
    $TDConfig = Get-Content C:\opt\td-agent\etc\td-agent\td-agent.conf -ErrorAction SilentlyContinue
    $ServiceStatus = $(Get-Service -Name fluentdwinsvc -ErrorAction SilentlyContinue).Status
    $TDAgent = Get-Itemproperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, DisplayVersion, UninstallString, PSChildName | Where-Object { $_.DisplayName -imatch "td-agent" }
    $InstalledVersion = $(if ( $TDAgent.DisplayVersion -ne $null ) {$TDAgent.DisplayVersion}else{"Not Installed"})
    $Tags = $($TDConfig | Select-String -Pattern "[\s\s+]tag \S+" | ForEach-Object { $_.Matches[0].Value } | foreach {$_ -replace "tag ",$null})
    $Server = $($TDConfig | Select-String -Pattern "[\s\s+]host \S+" | ForEach-Object { $_.Matches[0].Value } | foreach {$_ -replace "host ",$null})
    $Port =  $($TDConfig | Select-String -Pattern "[\s\s+]port \S+" | ForEach-Object { $_.Matches[0].Value } | foreach {$_ -replace "port ",$null})
    Write-Host "Fluentd Details:
Version: $InstalledVersion
Server: $Server
Port: $Port
Tags: $Tags
State: $ServiceStatus"
}
