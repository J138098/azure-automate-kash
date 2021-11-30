[CmdletBinding()]
param (
    # parameter er ikke obligatorisk siden vi har default verdi
    [Parameter(HelpMessage = "URL til kortstokk", Mandatory = $false)]
    [string]
    # når paramater ikke er gitt brukes default verdi
    $UrlKortstokk = 'http://nav-deckofcards.herokuapp.com/shuffle'
)

$ErrorActionPreference = 'Stop'
$webrequest = Invoke-WebRequest -Uri $UrlKortstokk
$kortstokkJson = $webRequest.Content

$kortstokk = ConvertFrom-Json -InputObject $kortstokkJson

function kortstokkTilStreng {
    [OutputType([string])]
    param (
        [object[]]$kortstokk
    )
    $streng = ""
    foreach ($kort in $kortstokk) {
        $streng = $streng + "$($kort.suit[0])" + "$($kort.value)" + ","
    }
    return $streng.TrimEnd(',')
}

Write-Output "Kortstokk: $(kortstokkTilStreng -kortstokk $kortstokk)"