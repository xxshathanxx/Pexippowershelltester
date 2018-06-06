Class Conference {
    [string]$name
    [string]$conflocation
    [object]$ecred
    [boolean]$created
    [string]$alias
    [string]$url
    [string]$id
    
    Conference([hashtable]$confinfo){
        $this.name = $confinfo.name
        $this.ecred = $confinfo.ecreds
        $this.created = $FALSE
        $this.alias = $confinfo.alias 
        $this.url = $confinfo.server
    }
    [array]Connect([string]$url, [string]$body, [string]$type) {
        $resheaders = @{}
        if ($body -eq "None")
        {
            $result = Invoke-RestMethod -Method $type -Uri $url -Credential $this.ecred -contenttype 'application/json' -ResponseHeadersVariable resheaders
        }
        else {
            $result = Invoke-RestMethod -Method $type -Uri $url -Credential $this.ecred -contenttype 'application/json' -Body $body -ResponseHeadersVariable resheaders
        }
        $final =@($resheaders,$result)
        return $final
    }
   [void]CreateConf(){
        $data = @{name=$this.name;service_type="conference";aliases=@(@{alias=$this.alias})} | ConvertTo-Json -Compress
        $result = $this.Connect($this.url+"/api/admin/configuration/v1/conference/",$data,"POST")
        write-host $result[0].Location
        $result[0]
        if($result[0].Location){
            $this.conflocation = $result[0].Location
            $this.created = $TRUE
            write-host "create confrence $this.name"
        }
                 
    }
    [void]setconfid(){
        $data ="None"
        $result = $this.Connect($this.url+"/api/admin/status/v1/conference/",$data,"GET")
        foreach ($x in $result.objects){
            if($x.name -eq $this.name)
            {
                $this.id = $x.id
            }
                
        }

    }
    [void]Disconnectall(){
        write-host $this.id
        $data = @{conference_id=$this.id} | ConvertTo-Json -Compress
        write-host $data
        $result = $this.Connect($this.url+"/api/admin/command/v1/conference/disconnect/",$data,"POST")
        write-host "Disconnect Result:"
        $result
    }
    [void]DeleteConf(){
        $data = "None"
        $result = $this.Connect($this.conflocation,$data,"DELETE")
        write-host "Deletion Result: $result"
    }
 
    [void]addtoconf([array]$endpoints){
        foreach ($endpoint in $endpoints){
            $data = @{conference_alias=$this.alias;destination=$endpoint.name; remote_display_name=$endpoint.confname; ;system_location=$endpoint.location; protocol="sip"; role="chair"} | ConvertTo-Json -Compress
            write-host $data
            $result = $this.Connect($this.url+"/api/admin/command/v1/participant/dial/",$data,"POST")
            $result
        }
    }

}
