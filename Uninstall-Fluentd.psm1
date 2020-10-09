<#
    .SYNOPSIS
        This Uninstalls the fluentd windows service and files from a host.
    .EXAMPLE
        Uninstall-FluentdClient
#>
function Uninstall-Fluentd {
    $TDAgent = Get-Itemproperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, DisplayVersion, UninstallString, PSChildName | Where-Object { $_.DisplayName -imatch "td-agent" }
    $ProductCode = $TDAgent.PSChildName
    if ( $ProductCode -eq $null ){
        Write-Error -Message "No installation of td-agent was found." -Category NotInstalled -ErrorAction Stop
    }

    if ( $(Get-Service -Name fluentdwinsvc) -ne $null ) {
        Write-Host "Unregistering Windows service."
        Disable-Fluentd
        Start-Process "C:\opt\td-agent\bin\fluentd" -ArgumentList "--reg-winsvc u" -Wait -Verb RunAs
        Write-Verbose "You need to restart to completely remove the product." -Verbose
    }
    Write-Host "Uninstalling td-agent..."
    Start-Process "msiexec.exe" -Args "/qn /x ${ProductCode}" -Wait -Verb RunAs
    
    if (Test-Path "C:\opt\td-agent") {
        Remove-Item C:\opt\td-agent -Recurse -Force -Confirm:$false
        if(!(Test-Path "C:\opt\*")) {
            Remove-Item C:\opt -Recurse -Force -Confirm:$false
        }
    }
}
