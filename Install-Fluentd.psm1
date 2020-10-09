<#
    .SYNOPSIS
        This downlaods, installs and configures a fluentd windows agent via td-agent to forward logs to a centeralized server. 
    .PARAMETER Server
        The FQDN or IP of the fluentd server to forward the packets to. 
    .PARAMETER Port
        The port number of the server to specify (Defaults to 443)
    .PARAMETER Tag
        The tag to forward the logs with. (defaults to winevt.raw) 
    .PARAMETER Version
        The version of td-agent to install. (Defaults to 4.0.1)
    .EXAMPLE
        Install-Fluentd -Server 192.168.1.40 -Servername fluentd-02 -Tag "it.winevt.raw" Port 7777
#>

function Install-Fluentd {
[CmdletBinding()]
param(
[Parameter()]
[string]$Server,
[string]$Servername,
[string]$Tag='winevt.raw',
[int]$Port=443,
[version]$Version='4.0.1'
) 

# Set some more variables for the installation:
$StartDTM = (Get-Date)
$Vendor = "TreasureData"
$Product = "td-agent"
$PackageName = "td-agent-$Version$(if ($Version.Major -eq 3 ){Write-Output '-0'})-x64"
$InstallerType = "msi"
$Path = "C:\Windows\Installers\"
$Installer = "$packageName.$installerType"
$InstallerPath = "$Path$($Installer)"

# Build a URL with the version number and fail if it's obviously the wrong version
if ($Version.Major -ge 3 ){
    $DownloadURL="http://packages.treasuredata.com.s3.amazonaws.com/$($Version.Major)/windows/td-agent-$Version$(if ($Version.Major -eq 3 ){Write-Output '-0'})-x64.msi"
}else{
    Write-Error -Message "The version of td-agent does not exist." -Category InvalidArgument -ErrorAction Stop
}

# Fail if there's a bad response from the url we built
if ( $(Test-URL $DownloadURL) -eq $false ) {
    $ErrorMessage = "Could not verify a download link for the specified version: $Version "
    Write-Error -Message $ErrorMessage -Category ResourceUnavailable -ErrorAction Stop
}


# Error if td-agent is already installed. 
$TDAgent = Get-Itemproperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, DisplayVersion, UninstallString, PSChildName | Where-Object { $_.DisplayName -imatch "td-agent" }
$ProductCode = $TDAgent.PSChildName
if ( $ProductCode -ne $null ){
    Write-Error -Message "Another install was already found. Use Uninstall-Fluentd to remove it." -Category DeviceError -ErrorAction Stop
}

# Check if $Path exists if not create it
if (Test-Path -Path $Path -PathType Container)
{ Write-Verbose "$Path already exists" -Verbose }
else
{ New-Item -Path $Path  -ItemType directory }

# Download the Installer
Write-Verbose "Downloading $Vendor $Product $Version" -Verbose
Invoke-WebRequest $DownloadURL -OutFile $InstallerPath

# Start the installation
Write-Verbose "Installing $Vendor $Product $Version" -Verbose
Start-Process msiexec -ArgumentList "/i $InstallerPath", "/qn" -Wait

# Remove the installer
rm -Force $InstallerPath

# Configure the Service
Set-FluentdConfig -Servername $(if ($ServerName){$ServerName}else{$Server}) -Server $Server -Tag $Tag -Port $Port

# Register the fluentd service and set it to automatically start. 
Start-Process "C:\opt\td-agent\bin\fluentd" -ArgumentList "--reg-winsvc i" -Wait -Verb RunAs
Start-Process "C:\opt\td-agent\bin\fluentd" -ArgumentList "--reg-winsvc-fluentdopt '-c C:/opt/td-agent/etc/td-agent/td-agent.conf -o C:/opt/td-agent/td-agent.log'" -Wait -Verb RunAs

# Add windows_eventlog plugin
Start-Process "C:\opt\td-agent\bin\fluentd" -ArgumentList "fluent-gem install fluent-plugin-windows-eventlog" -Wait -Verb RunAs

Enable-Fluentd
}

function Test-URL {
[CmdletBinding()]
param(
[Parameter(Mandatory=$True,Position=1)]
[string]$URL
)
    # First we create the request.
    $HTTP_Request = [System.Net.WebRequest]::Create($URL)

    # We then get a response from the site.
    $HTTP_Response = $HTTP_Request.GetResponse()

    # We then get the HTTP code as an integer.
    $HTTP_Status = [int]$HTTP_Response.StatusCode
    
    # Finally, we clean up the http request by closing it.
    If ($HTTP_Response -eq $null) { } Else { $HTTP_Response.Close() }

    If ($HTTP_Status -eq 200) {
        return $true
    } Else {
        return $false
    }
}
