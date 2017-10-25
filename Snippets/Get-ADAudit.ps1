function Get-ADAudit () {
    Param(
        ## Parameter Child Domain
        [Parameter(Mandatory = $false)]
        [ValidateSet("DFW", "HKG", "IAD", "LON", "ORD", "SYD", "RSGlobal")]
        [string]
        $Domain,
        ## Parameter Account Number
        [Parameter(Mandatory = $false)]
        [int32]
        $Account
    )
    ## Parameter Domain Input/Validation
    if (!($Domain -eq $null)) {
        do {
            try {
                [ValidateSet("DFW", "HKG", "IAD", "LON", "ORD", "SYD","RSGlobal")]$Domain = Read-Host -Prompt "Enter Domain (e.g. DFW/HKG/IAD/LON/ORD/SYD/RSGlobal)"
            } catch {}
        } until ($?)
    }
    ## Check for Intensive/RSGlobal
    if ($Domain -eq "RSGlobal") {
        $DistinguishedName = $Domain + "RS.Global"
    } else {
        $DistinguishedName = $Domain + "intensive.int"
    }
    ## Parameter Account Input/Validation
    if (!($Account -eq $null)) {
        do {
            try {
                [ValidatePattern('[0-9]')]$Account = Read-Host -Prompt "Enter Account Number"
            }
            catch {}
        } until (($?) -and (Get-ADOrganizationalUnit -Identity ""))
        
    }    
    ## Distinguished Name Array
    $DistinguishedName = $DistinguishedName.Split('.')
    foreach ($v in $DistinguishedName) {
        $DistinguishedName += "DC=" + $v
        $DistinguishedName = $DistinguishedName -ne $v
    }
    
    $Output = Get-ADUser -Server "$Domain.intensive.int" -SearchBase "OU=$Account,OU=Rax,OU=Dallas,DC=$DistinguishedName[0],DC=,DC=" -Filter * -Properties *
    $Output | Format-Table -AutoSize Name, Enabled
}
