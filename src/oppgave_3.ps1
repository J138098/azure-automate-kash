$ErrorActionPreference = 'Stop'

$webrequest = Invoke-WebRequest -Uri http://nav-deckofcards.herokuapp.com/shuffle
$kortstokkJson = $webRequest.Content

$kortstokk = ConvertFrom-Json -InputObject $kortstokkJson

$kortstring = @()
foreach ($kort in $kortstokk) {
    $kortstring = $kortstring + ($kort.suit[0] + $kort.value) 
    
}
Write-Host "Kortstokk: $kortstring"

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