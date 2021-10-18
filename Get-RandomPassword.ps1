[CmdletBinding()]
param (
    [Parameter()]
    [Int16]
    $NumberOfPasswords = 10,
    [Parameter()]
    [string]
    $OutputPath = ".\Output.txt",
    [switch]
    $OutFile
)

$NumberOfRuns = 0

do {
    $Words = (Invoke-RestMethod -Uri http://api.corpora.uni-leipzig.de/ws/words/deu_news_2012_1M/randomword/?limit=4).word
    # $Words = (Invoke-RestMethod -Uri http://api.corpora.uni-leipzig.de/ws/words/deu_wikipedia_2010_1M/randomword/?limit=4).word
    
    $RawString = $Words[0] + "-" + $Words[1] + "-" + $Words[2] + "-" + $Words[3]
    $FilteredString = $RawString -replace " ", "_" -replace "\.", ""
    $FilteredString += "`n"
    $PasswordOutput += $FilteredString
    $NumberOfRuns++
} while ($NumberOfRuns -lt $NumberOfPasswords)

$PasswordOutput = $PasswordOutput.TrimEnd("`n")

if ($OutFile) {
    $PasswordOutput | Out-File -FilePath $OutputPath
}
else {
    Write-Host $PasswordOutput
    Read-Host "Enter zum beenden..."
}
