using Module .\conferenceclass.psm1


Function Main{
    $json = Get-Content 'config.json' | Out-String | ConvertFrom-Json
    $ecreds = Get-credential 
    $confinfo = @{name=$json.conference_name;server=$json.server;alias=$json.alias;ecreds=$ecreds}
    $confname = [Conference]::new($confinfo)
    $confname.CreateConf()
    start-sleep -s 15
    $endpoints = Import-csv .\connections.csv
    $confname.addtoconf($endpoints)
    $confname.setconfid()
    start-sleep -s 30
    $confname.Disconnectall()
    If($confname.created -eq $TRUE){
        write-host "Deleting "
        write-host $confname.conflocation
       $confname.DeleteConf()
    }
    

}

main
