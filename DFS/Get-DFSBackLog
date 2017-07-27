# Function
function Get-DFSBacklog {

    # Get all replication groups
    $ReplicationGroups = dfsradmin rg list;
 
    # Reduce loop by 3 lines to filter out junk from dfsradmin
    $i = 0;
    $imax = ($ReplicationGroups.count - 3);
 
    # Loop through each replication group
    foreach ($ReplicationGroup in $ReplicationGroups) {
 
        # Exclude first and last two lines as junk, and exclude the domain system volume
        if (($i -ge 1) -and ($i -le $imax) -and ($ReplicationGroup -notlike "*domain system volume*")) {
 
            # Format replication group name
            $ReplicationGroup = $ReplicationGroup.split(" ");
            $ReplicationGroup[-1] = "";
            $ReplicationGroup = ($ReplicationGroup.trim() -join " ").trim();
 
            # Get and format replication folder name
            $ReplicationFolder = & cmd /c ("dfsradmin rf list /rgname:`"{0}`"" -f $ReplicationGroup);
            $ReplicationFolder = (($ReplicationFolder[1].split("\"))[0]).trim();
 
            # Get servers for the current replication group
            $ReplicationServers = & cmd /c ("dfsradmin conn list /rgname:`"{0}`"" -f $ReplicationGroup);
 
            # Reduce loop by 3 lines to filter out junk from dfsradmin 
            $j = 0;
            $jmax = ($ReplicationServers.count - 3);
 
            # Loop through each replication member server
            foreach ($ReplicationServer in $ReplicationServers) {
 
                # Exclude first and last two lines as junk
                if (($j -ge 1) -and ($j -le $jmax)) {
 
                    # Format server names
                    $SendingServer = ($ReplicationServer.split()| Where-Object {$_})[0].trim();
                    $ReceivingServer = ($ReplicationServer.split()| Where-Object {$_})[1].trim();
 
                    # Get backlog count with dfsrdiag
                    $Backlog = & cmd /c ("dfsrdiag backlog /rgname:`"{0}`" /rfname:`"{1}`" /smem:{2} /rmem:{3}" -f $ReplicationGroup, $ReplicationFolder, $SendingServer, $ReceivingServer);
 
                    $Backlogcount = ($Backlog[1]).split(":")[1];
 
                    # Format backlog count
                    if ($Backlogcount -ne $null) {
 
                        $Backlogcount = $Backlogcount.trim();
                    }
                    else {
                    
                        $Backlogcount = 0;
                    }
 
                    # Create output string to <replication group> <sending server> <receiving server> <Backlog count>;
                    $outline = $ReplicationGroup + " From: " + $SendingServer + " To: " + $ReceivingServer + " Backlog: " + $Backlogcount;
                    if ($Backlogcount -notlike "0") {

                        Write-Host $outline -ForegroundColor Red   

                    }
                    else {

                        Write-Host $outline -ForegroundColor Green

                    }
 
                }
 
                $j = $j + 1;
            }
 
        }
 
        $i = $i + 1;
    }
}