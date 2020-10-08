<#
    .SYNOPSIS
        This downlaods, installs and configures a fluentd windows agent via td-agent to forward logs to a centeralized server.
    .PARAMETER Server
        The IP or FQDN of the fluentd server to forward the packets to.
    .PARAMETER Servername
        The hostname of the fluentd server to forward the packets to.
    .PARAMETER Port
        The port number of the server to specify (defaults to 443)
    .EXAMPLE
        Set-FluentdCconfig -Server logs.example.com -port 7777
#>

function Set-FluentdConfig {
[CmdletBinding()]
param(
[Parameter()]
[string]$Server,
[string]$Servername,
[string]$Tag='winevt.raw',
[int]$Port=443
)
$ConfigFileBasline = "
#==============================================================================
# FluentD (aka td-agent) - Azusa Pacific University
#==============================================================================
#--------------------------------------
# INPUT PLUGINS
#--------------------------------------
<source>
    @type windows_eventlog2
    @id windows_eventlog2
    channels application,system,security
    read_existing_events false
    read_interval 2
    tag $Tag
    rate_limit 300
    <storage>
        persistent true
        path C:\opt\td-agent\winevt.pos
    </storage>
    <subscribe>
		channels application,system,security
		read_existing_events false
	</subscribe>
</source>

#--------------------------------------
# FILTER PLUGIN
#--------------------------------------
# This is used to ensure backwards compatibility with windows_eventlog (version 1)
# since windows_eventlog2 uses 'Description' vs 'description'
# This will be deprecated in a future version
<filter **>
   @type record_transformer
   <record>
		description `${record[`"Description`"]}
   </record>
   remove_keys Description
</filter>

#--------------------------------------
# OUTPUT PLUGINS
#--------------------------------------
## Forward to central fluent aggregator
<match **>
    @type copy
    <store>
        @type stdout
    </store>
    <store>
        @type forward
        send_timeout 5s
        recover_wait 10s
        heartbeat_interval 1s
        phi_threshold 16
        hard_timeout 60s
        <server>
            name $(if ($ServerName){$ServerName}else{$Server})
            host $Server
            port $Port
        </server>
        <secondary>
            @type file
            path C:/opt/td-agent/forward-failed
        </secondary>
        <buffer>
            @type file
            path C:/opt/td-agent/fluent.general
            flush_interval 10s
        </buffer>
    </store>
</match>
"
Out-File -Encoding utf8 -Force -FilePath "C:\opt\td-agent\etc\td-agent\td-agent.conf" -InputObject $ConfigFileBasline
}
